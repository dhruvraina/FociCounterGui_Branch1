%Dependencies: barwitherr.m (MATLAB FileExchange) datExtract5 FociCounter5
%ClearNuc DirSwitch ReshuffleControl CutoffFinder
%Description: Coordinates between other programs. Defines jobs.
%Author: Dhruv Raina
%Last Edit: 080814
%ImageLoader for GUI.

function ImgLoader2(dateID, savepath, loadpath, analysisflag, selcrit_inputs, graph_flags, channel_flag, tflag, slashtype)
tic
%% For Standalone Running:
% dateID = '240714'; %date of analysis:
% savepath = 'F:\Dhruv\CCBT2\ImgLoader_images'; %to save images
% loadpath = 'F:\Dhruv\CCBT2\matfiles'; %to load matfiles
% analysisflag = 1; %1=spot extraction + filtering, 0=spot filtering only(matfiles needed)

%% Constants:
if nargin<9
    slashtype = '/';
end
watershed_flag = selcrit_inputs(4);
bitdepth = selcrit_inputs(7);
cellnum2=[];
treatment_dirs = loadpath;
nameset = {'FL-1', 'FL-2'};

ctrstart=1;                                                                % Dealing with 2 or 1 channel sets (eg. D+FITC, D+Cy5 both or only one)
ctrend = 1;
if channel_flag(1)==0
    ctrstart = 2;
end
if channel_flag(2)>0
    ctrend = 2;
end


%% Main:
handle_msgbox = msgbox('Running....Please Wait!', 'FociCounterGUI');
disp('Running...')
for zz = ctrstart:ctrend                                                   % zz=channelFlag
    int_cutvec(1:2)=0;                                                     % Init to avoid information carryover in loop
    savepath2 = [savepath slashtype nameset{zz}];
    chan = channel_flag(zz);
    
    %Image Processing + Analysis:
    if analysisflag==1
        for aa = 1:length(treatment_dirs)
            [resultfile int_cutvec resfin_Area resfin_MeanInt resfin_Hetero] = FociCounter5(savepath2, treatment_dirs{aa},watershed_flag,dateID, int_cutvec, chan, bitdepth, tflag);
            [cellnum3{aa} whstruct(aa,:) focint{aa}] = datExtract5(selcrit_inputs, graph_flags, savepath2, int_cutvec, dateID, resultfile, resfin_Area,resfin_MeanInt, resfin_Hetero);
            tidx = strfind(treatment_dirs{aa},slashtype);
            tidx = tidx(end);
            tid = treatment_dirs{aa}(tidx+1:end);
            cellnumid{aa} = tid;
            intvec{aa} = int_cutvec;                                       % for debugging, tracking changes in intensity cutoffs
            
            %Messagebox:
            if ishandle(handle_msgbox)                                     % Check if msgbox is still open or user has closed it
                delete(handle_msgbox);
                clear('handle_msgbox');
            end
            handle_msgbox = msgbox([num2str(floor((aa/length(treatment_dirs))*100)) '% Done for Channel: '  nameset{zz} '... Please Wait'], 'FociCounterGUI');
            disp([num2str(floor((aa/length(treatment_dirs))*100)) '% Done for Channel: '  nameset{zz} '... Please Wait'])
        end
        
    %Analysis only, no processing:
    elseif analysisflag==0;
        for aa=1:length(treatment_dirs)
            tidx = strfind(treatment_dirs{aa},slashtype);
            tidx = tidx(end)+length(dateID);                               % getting rid of 'dateID'
            tid = treatment_dirs{aa}(tidx+1:end-18);                       % 'datextractvers.mat' is 18 chars long!
            cellnumid{aa} = tid;
            if ~strcmp(treatment_dirs{aa}(end-3:end),'.mat')
                errordlg('Invalid FileType! Program expects .mat files!')
            end
            load([treatment_dirs{aa}])                                     % Loading datextract files
            [cellnum3{aa} whstruct(aa,:) focint{aa}] = datExtract5(selcrit_inputs, graph_flags, savepath2, int_cutvec, dateID, resultfile, resfin_Area,resfin_MeanInt, resfin_Hetero);
            
            %Messagebox:
            if ishandle(handle_msgbox)                                     % Check if msgbox is still open or user has closed it
                delete(handle_msgbox);
                clear('handle_msgbox');
            end
            handle_msgbox = msgbox([num2str(floor((aa/length(treatment_dirs))*100)) '% Done ... Please Wait'], 'FociCounterGUI');
            disp([num2str(floor((aa/length(treatment_dirs))*100)) '% Done ... Please Wait'])
        end
        
    end
    %% Plotting Final Data Set:
    %Part1 - Pulling out the data:
    whst_cell = arrayfun(@(x) [num2cell([x.whMean])], whstruct, 'UniformOutput', 0); % Nucleus Int
    whst_cell = cellfun(@(x) cell2mat(x), whst_cell, 'UniformOutput', 0);
    whst_cell = cell2mat(whst_cell);
    
    het_cell = arrayfun(@(x) [num2cell([x.hetMean])], whstruct, 'UniformOutput', 0); % Texture: Clumping
    het_cell = cellfun(@(x) cell2mat(x), het_cell, 'UniformOutput',0);
    het_cell = cell2mat(het_cell);
    
    clump_cell = arrayfun(@(x) [num2cell([x.clumpMean])], whstruct, 'UniformOutput', 0); % Texture: Hetero
    clump_cell = cellfun(@(x) cell2mat(x), clump_cell, 'UniformOutput', 0);
    clump_cell = cell2mat(clump_cell);
    
    avgnumfoci_cell = arrayfun(@(x) [num2cell(x.avgFocNum)], whstruct, 'UniformOutput', 0'); %Num Foci/Cell
    avgnumfoci_cell = cellfun(@(x) cell2mat(x), avgnumfoci_cell, 'UniformOutput', 0);
    avgnumfoci_cell = cell2mat(avgnumfoci_cell);
    
    cellnumvec = cell2mat(cellnum3');                                      % Perc Cells x foci
    focintvec = cell2mat(focint');
    
    for qq = 1:size(whst_cell,1)                                           % Calculating Means and Stdev:
        whst_mean(qq) = mean(nonzeros(whst_cell(qq,:)));
        whst_std(qq) = std(nonzeros(whst_cell(qq,:)));
        cellnum_mean(qq) = mean(nonzeros(cellnumvec(qq,:)));
        cellnum_std(qq) = std(nonzeros(cellnumvec(qq,:)));
        het_mean(qq) = mean(nonzeros(het_cell(qq,:)));
        het_std(qq) = std(nonzeros(het_cell(qq,:)));
        clump_mean(qq) = mean(nonzeros(clump_cell(qq,:)));
        clump_std(qq) = std(nonzeros(clump_cell(qq,:)));
    end
    
    %Part2 - Writing Data to file:
    outvec = {'Name' 'Dish1_MeanNucInt' 'Dish2_MeanNucInt' 'D1 Perc Cells' 'D2 Perc Cells' 'D1_Avg Integrated Foci Inten' 'D2_Avg Integrated Foci Inten' 'D1_FL_Het' 'D2_FL_Het' 'D1_FL_Clump' 'D2_FL_Clump' 'D1_AvgNumFoci' 'D2_AvgNumFoci'};
    for nn = 1:length(cellnum3)
        mm = nn+1;%offset header
        outvec{mm,1} = cellnumid{nn};
        outvec{mm,2} = whst_cell(nn,1);
        outvec{mm,3} = whst_cell(nn,2);
        outvec{mm,4} = cellnumvec(nn,1);
        outvec{mm,5} = cellnumvec(nn,2);
        outvec{mm,6} = focintvec(nn,1);
        outvec{mm,7} = focintvec(nn,2);
        outvec{mm,8} = het_cell(nn,1);
        outvec{mm,9} = het_cell(nn,2);
        outvec{mm,10} = clump_cell(nn,1);
        outvec{mm,11} = clump_cell(nn,2);
        outvec{mm,12} = avgnumfoci_cell(nn,1);
        outvec{mm,13} = avgnumfoci_cell(nn,2);
    end
    try
        xlswrite([savepath2 slashtype dateID '.xlsx'], outvec);
    catch
        errordlg('The output excel file may be in use or the disk may be write protected. Please close all MS Excel windows or select an alternate output folder and try again.')
    end
    
    %Part3 - Plotting:
    %Whole Nuc Int
    if graph_flags(3)==1
        xv1 = 1:size(whst_cell,1);
        yv1 = whst_mean;
        yv1 = floor(yv1.*100);                                             % Rounding down to 2 decimal points
        yv1 = yv1./100;
        ev1 = whst_std;
        figure, barwitherr(ev1,yv1)
        ylabel('Mean Intensity')
        title('Treatment efficacy')
        set(gca, 'XTickLabel', cellnumid, 'YLim', [0 45000])
        set(gcf, 'visible', 'off')
        for i=1:size(whst_cell,1)
            text(xv1(i), yv1(i), num2str(yv1(i)),'HorizontalAlignment','center', 'VerticalAlignment','bottom')
        end
        hgexport(gcf, [savepath2 slashtype dateID '_' num2str(qq) '_WholeNucBar.jpg'], hgexport('factorystyle'), 'Format', 'jpeg');
    end
    
    %Perc Cells With x foci
    if graph_flags(4)==1
        xv2 = 1:length(cellnum3);
        yv2 = cellnum_mean;
        yv2 = floor(yv2.*100);                                             % Rounding down to 2 decimal points
        yv2 = yv2./100;
        ev2 = cellnum_std;
        figure, barwitherr(ev2,yv2)
        ylabel(['Percentage of Cells with > ' num2str(selcrit_inputs(3)) ' foci'])
        title('Treatment efficacy')
        set(gca, 'XTickLabel', cellnumid, 'YLim', [0 100])
        set(gcf, 'visible', 'off')
        for i=1:length(cellnum3)
            text(xv2(i), yv2(i), num2str(yv2(i)),'HorizontalAlignment','center', 'VerticalAlignment','bottom')
        end
        hgexport(gcf, [savepath2 slashtype dateID  '_' num2str(qq) '_PcCellsFociBar.jpg'], hgexport('factorystyle'), 'Format', 'jpeg');
        clear whstruct cellnumid cellnum2;
    end
    
    %MessageBox:
    if ishandle(handle_msgbox)                                             
        delete(handle_msgbox);
        clear('handle_msgbox');
    end
    handle_msgbox = msgbox([nameset{zz} ' Done. Working...'], 'FociCounterGUI');
    clear hetero;
end

%MessageBox:
if ishandle(handle_msgbox)                                                 
    delete(handle_msgbox);
    clear('handle_msgbox');
end
handle_msgbox = msgbox('   Done.','FociCounterGUI');
disp('Done.')
end