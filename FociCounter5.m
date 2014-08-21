% Program Name: FociCounter.m
% Author:Dhruv Raina
% Last Edit:210714
% A Program to extract nuclear foci properties
% Dependencies: ClearNuc.m, datExtract2.m, ImgLoader.m
% Usage:
%Counters:
% dd: Image Counter
% cc: Nuclei Counter (within image)
% ee: Spot Counter (within nucleus)

function varargout = FociCounter5(savepath1, ImDir,w_flag,dateID, int_cutoffL, channel_flag)

%% For Standalone Running:
% close all; clearvars -except treatment_dirs
% ImDir = {'F:\Dhruv\CCBT2\Data\Shruthi\110714\150ncs'};
% ImDir = treatment_dirs{1};
% w_flag=0; %watershed flag
% dateID = 'Tester';
% int_cutoffL = 0;

%% Constants:
savepath= [savepath1 '/matfiles'];                                         %Matfiles for debugging/re-analysis
savepath2 = [savepath1 '/SpotPrinterVars'];                                %Variables for SpotPrinter
hy = fspecial('sobel');
hx = hy';                                                                  %Sobel Filter for watershed transform
se1=strel ('disk',1);
spot_total=zeros(512,512);
spot_img=[];
restemp_MeanInt = {};

%% Reading Directory Structure:
chset1 = {'img_000000000_Dapi_000.tif' 'img_000000000_FITC_000.tif', 'img_000000000_Cy5_000.tif'};
channel_flag = channel_flag+1;
chset = {chset1{1}, chset1{channel_flag}};
dishset = {'dish1' 'dish2'};
slashtype = '/';
for jj = 1:length(dishset)
    if iscell(ImDir)
        ImDir = cell2mat(ImDir);
    end
    Working_Dir = [ImDir slashtype dishset{jj}];
    if isdir(Working_Dir)
        dirlist = dir(Working_Dir);
        for bb = 3:length(dirlist)
            dir_lst{bb}=dirlist(bb).name;
        end
        ct = 0; %for disp
        if exist('dir_lst', 'var')
            %% Main:
            for dd = 3:length(dir_lst)
                
                %Reading Images + Processing:
                tImg_d = imread([Working_Dir slashtype dir_lst{dd} slashtype chset{1}]);
                tImg_fitc = imread([Working_Dir slashtype dir_lst{dd} slashtype chset{2}]);
               
                [nucMask nucNum] = ClearNuc(tImg_d);
                tImg_fitc1 = mat2gray(tImg_fitc, [0 65535]);                           %tImg_fitc1 = mat2gray(tImg_fitc);
                tImg_d = mat2gray(tImg_d, [0 65535]);                                  %tImg_d = mat2gray(tImg_d);
                tImg_fitc=imtophat(tImg_fitc1, strel('disk',5));
                
                %Initializing + to get even length vectors for vertcat
                resvec_Area=zeros(nucNum,50);
                resvec_Perimeter=zeros(nucNum,50);
                resvec_MeanInt=zeros(nucNum, 50);
                spot_total = zeros(512,512);
                ridx = strfind(ImDir,slashtype);
                ridx = ridx(end);
                resultfile = ImDir(ridx+1:end);
                
                %Per Nucleus Spot Information:
                if nucNum~=0                                                           %error handling for no nuclei
                    for cc = 1:max(nucMask(:))
                        tIm_olay = zeros(512,512);
                        tIm_olay(nucMask==cc)=1;
                        tIm_nucolay = tIm_olay.*tImg_fitc1;%#^ tImg_d for nuc; to record mean whole nuclear fitc
                        tIm_spolay = tIm_olay.*tImg_fitc;
                        
                        %intensity-based thresholding
                        thresh_olay = sort(nonzeros(tIm_spolay(nucMask==cc)));
                        threshval = 1.4*graythresh(thresh_olay);
                        if threshval>=1
                            threshval = 0.9                                            %set to output intentionally
                        else
                        end
                        spot_mask = im2bw(tIm_spolay, threshval);
                        spot_mask = imdilate(spot_mask, se1);                          %dilate the spot masks to get better segmentation of spots
                        [spot_mask_lbl spot_num] = bwlabel(spot_mask);
                        
                        
                        if spot_num>=1&&spot_num<60                                    %error handling for no spots/vertcat
                            spot_mask_im = spot_mask.*tImg_fitc;
                            smoothened=medfilt2(spot_mask_im);                         %Local Maxima Marker (used for watershed only)
                            for ee = 1:spot_num
                                spot_im2=zeros(512, 512);
                                spot_im2(spot_mask_lbl==ee)=smoothened(spot_mask_lbl==ee);
                                
                                %Marker-based watershed on large spots(above area 60px):
                                if length(nonzeros(spot_im2(:)))>60 && w_flag==1
                                    Iy = imfilter(double(spot_im2), hy, 'replicate');  %Sobel differential filter for GradMag
                                    Ix = imfilter(double(spot_im2), hx, 'replicate');
                                    gradmag = sqrt(Ix.^2 + Iy.^2);
                                    maximg = imregionalmax(spot_im2);
                                    maximg = imdilate(maximg,se1);                     %Foreground marker
                                    minimg=bwdist(spot_im2);
                                    minimgW= watershed(minimg);
                                    minimgD=minimgW==0;                                %Background marker
                                    impmin= imimposemin(gradmag, minimgD | maximg);
                                    W = watershed(impmin);
                                    modalval = mode(W(:));
                                    W(W==modalval)=0;
                                    spot_mask2 = im2bw(W,0.5);
                                    spot_mask(spot_mask_lbl==ee)=0;                    %Clearing Large Spots
                                    spot_mask(spot_mask2==1)=1;                        %Re-Writing post-watershed spot
                                else
                                end
                            end
                            spot_mask_im = spot_mask.*tImg_fitc1;                      %fitc1 is the spot_orginal
                            [spot_mask_lbl spot_num]=bwlabel(spot_mask);
                            
                            %Data Readout + Storage:
                            if spot_num>40
                                disp('Dropping Over-Segmented Cell')                   %watershedding can sometimes oversegment
                            else
                                rp_spot=regionprops(spot_mask, spot_mask_im, 'Area', 'Perimeter', 'MeanIntensity'); %Spot Params
                                for ee=1:spot_num                                      %storing data
                                    ff=ee+2;                                           %make space for nuc/other params
                                    resvec_Area(cc,ff)=rp_spot(ee).Area;
                                    resvec_Perimeter(cc,ff)=rp_spot(ee).Perimeter;
                                    resvec_MeanInt(cc,ff)=rp_spot(ee).MeanIntensity;
                                end
                                rp_nuc = regionprops(tIm_olay, tIm_nucolay, 'Area', 'Perimeter', 'MeanIntensity'); %Nuclear Params
                                %resvec_MeanInt(cc,2) = other params;                  %write in other params stored in varctr
                                resvec_Area(cc,1) = rp_nuc.Area;
                                resvec_Perimeter(cc,1) = rp_nuc.Perimeter;
                                resvec_MeanInt(cc,1) = rp_nuc.MeanIntensity;
                            end
                            spot_total = spot_mask+spot_total;
                        else
                        end
                    end %Nuclear Counter Loop
                else
                    disp(['No Nuclei found in Img ' Working_Dir slashtype dir_lst{dd}])
                end
                
                gg = dd-2;
                %%
                vec_raw_fitc{gg,jj} = tImg_fitc1;                                      %saving for spot_printer
                vec_raw_nuc{gg,jj} = tImg_d;
                vec_nuc_mask{gg,jj} = nucMask;
                vec_spot_mask{gg,jj}=spot_total;
                
                resfin_Area{gg,jj}=resvec_Area;                                        %saving for dat_extract
                resfin_Peri{gg,jj}=resvec_Perimeter;
                resfin_MeanInt{gg,jj}=resvec_MeanInt;
                clear resvec_Area resvec_Perimeter resvec_MeanInt nucMask nucNum
                ct = ct+1;
                disp(['Dish No. ' num2str(jj) ' Field No. ' num2str(ct) ' Done'])
            end
            clear dirlist dir_lst
        else %If dir_lst exists (unkn error)
            msgbox('No Directory Exists!! Please call Dhruv!')
            keyboard
        end
    else %If working directory exists (dish1 v dish2)
        if jj==1 %If sub-folder is not named 'dish1' 
            errordlg('Folder Structure is Incorrect!');
        else
        msgbox(['Only 1 Replicate for ' resultfile], 'Warning!')
            resfin_MeanInt{1,2}=zeros(1,50);                                          %to prevent erroring out in the int_cutoff finder.m
            resfin_Area{1,2}=zeros(1,50);
        end
        end
    end
    
    if int_cutoffL==0
        int_cutoffL = CutoffFinder(resfin_MeanInt);
    else
    end
    
    %% saving matfiles for debugging & Output:
    if ~exist(savepath, 'dir')
        mkdir(savepath)
    end
    if ~exist(savepath2, 'dir')
        mkdir(savepath2)
    end
    save([savepath slashtype dateID resultfile 'datExtractVars.mat'], 'resfin_Area', 'resfin_MeanInt', 'dateID', 'resultfile', 'int_cutoffL');
    save([savepath2 slashtype dateID resultfile 'SpotPrinter.mat'], 'vec_spot_mask', 'vec_raw_fitc', 'vec_raw_nuc', 'vec_nuc_mask', 'int_cutoffL');
    
    varargout{1} = resultfile;
    varargout{2} = int_cutoffL;
    varargout{3} = resfin_Area;
    varargout{4} = resfin_MeanInt;
end