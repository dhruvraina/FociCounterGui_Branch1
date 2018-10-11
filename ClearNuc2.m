% Author:Dhruv Raina
% Last Edit:280814
% Program Name: ClearNuc.m
% Usage: ClearNuc(nuc) where nuc is a uint16 or double nuclear image.
% Nucleus Extractor

function varargout = ClearNuc2(nuc)
%A. Clean up Nuclear Image:
se1 = strel('disk', 5);
nuc_Ie = imerode(nuc, se1);
nucImg = imreconstruct(nuc_Ie, nuc);
nucImg = mat2gray(nucImg);

if 1.2*graythresh(nucImg)>1  %1.4 previously                                              % Nuclei Intensity threshold
    LEVEL = 1;
else
    LEVEL = 1.2*graythresh(nucImg);
end
nucMask = im2bw(nucImg, LEVEL);
imclear2 = imclearborder(nucMask);
imclear2 = imfill(imclear2, 'holes');
imclear3 = imerode(imclear2, strel('disk',10));                            % Separating Touching Objects
imclear3 = bwareaopen(imclear3, 350);                                      % Removing Small Objects
[lbl num] = bwlabel(imclear3);

if num>=1
    %lbl2 = imdilate(lbl, strel('disk', 14));                               % Restoring Mask Size
    lbl2 = imdilate(lbl, strel('disk', 20));
    I = edge(lbl2, 'canny');                                               % To separate touching objects
    I = ~(imdilate(I, strel('disk',1)));
    lbl3 = lbl2.*I;
    bwimg = zeros(512,512);
    bwimg(lbl3>0)=1;
    meanarea = sum(bwimg(:))/num;                                          % Eliminate Clumped Objects
    t_imclear4 = bwareaopen(bwimg, floor(meanarea*2));
    imclear4 = bwimg;
    imclear4(t_imclear4>0)=0;
    
else
    lbl=zeros(512, 512);
    num = 0;
end

varargout{1}=lbl;
varargout{2}=num;
