% Author:Dhruv Raina
% Last Edit:290614
% Program Name: ClearNuc.m
% Usage: ClearNuc(nuc) where nuc is a uint8 or double nuclear image.
% Nucleus Extractor
% Can handle dirty images (i.e. gfp background instead of DAPI) for
% segmentation

function varargout = ClearNuc(nuc)
%A. Clean up Nuclear Image:
se1 = strel('disk', 5);
nuc_Ie = imerode(nuc, se1);
nucImg = imreconstruct(nuc_Ie, nuc);
nucImg = mat2gray(nucImg);
if 1.4*graythresh(nucImg)>1                                                %Nuclei Intensity threshold
    LEVEL = 1;
else
    LEVEL = 1.4*graythresh(nucImg);
end
nucMask = im2bw(nucImg, LEVEL);
imclear = bwareaopen(nucMask, 1000);                                       %clearing small objects (av nuclear size ~1700-2500)
imclear2 = imclearborder(imclear);                                         %clearing border
imclear2 = imfill(imclear2, 'holes');
imrp = regionprops(imclear2, 'Area', 'MajorAxisLength', 'MinorAxisLength', 'Perimeter');
[lbl num] = bwlabel(imclear2);

if num>=1
    for aa = 1:length(imrp)
        %malen(aa,1)= imrp(aa).MajorAxisLength;
        %milen(aa,1)= imrp(aa).MinorAxisLength;
        arlen(aa,1)= imrp(aa).Area;
        perilen(aa,1)= imrp(aa).Perimeter;
    end
    
    perirat = perilen./arlen;                                              %to check the circularity of the object
    %imconsol = malen./milen; %major-to-minor axis length
    
    threshval = sum(arlen)/length(arlen);
    threshval1 = threshval*3;                                              %3 times avg object size is set as area threshold
    threshmax = arlen(:)>threshval1;
    Threshmax2 = find(threshmax);                                          %vector containing nuc numbers for too large nuclei
    Threshmax2 = Threshmax2';
    
    threshcirc = 1.3*(sum(perirat)/length(perirat));                       %1.3 * avg circularity. objects above this are removed.
    minvec = perirat(:)>threshcirc;
    Minvec2 = find(minvec);                                                %finding poorly segmented/overly segmented nuclei
    Minvec2 = Minvec2';
    
    %Removing Clumped Nuclei:
    if find(Threshmax2)>=1
        for bb = Threshmax2
            imclear2(lbl==bb)=0;
        end
        [lbl num] = bwlabel(imclear2);                                     %re-labelling after getting rid of nuclei
    %else
        %disp('.')
    end
    
    %Restoring Oversegmented Nuclei:
    if find(Minvec2)>=1
        dilel = strel('disk', 5);
        for bb2 = Minvec2
            imtemp = zeros(512, 512);
            imtemp(lbl==bb2)=lbl(lbl==bb2);
            imtemp = imdilate(imtemp, dilel);
            lbl(imtemp==bb2)=bb2;
        end
    %else
        %disp('Restoring Nucleus');
    end
else
    lbl=zeros(512, 512);
    num = 0;
end
varargout{1}=lbl;
varargout{2}=num;
