%Dependencies: barwitherr.m (MATLAB FileExchange) datExtract5 FociCounter5
%ClearNuc DirSwitch ReshuffleControl CutoffFinder

%ImageLoader for GUI:

function ImgLoader2(dateID, savepath, loadpath, analysisflag, selcrit_inputs, graph_flags, channel_flag, slashtype)
tic
%% For Standalone Running:
% ntreat=1; %Number of Treatment sets with matched controls
% dateID = '240714'; %date of analysis:
% savepath = 'F:\Dhruv\CCBT2\ImgLoader_images'; %to save images
% loadpath = 'F:\Dhruv\CCBT2\matfiles'; %to load matfiles
% analysisflag = 1; %1=spot extraction + filtering, 0=spot filtering only(matfiles needed)
%% Constants:
if nargin<8
    slashtype = '/';
end
watershed_flag = selcrit_inputs(4);
cellnum2=[];
treatment_dirs = loadpath;
int_cutoffL=0;
nameset = {'FITC', 'Cy5'};
handle_msgbox = msgbox('Running....Please Wait!', 'FociCounterGUI');
disp('Running....')
ctrstart = 1;
ctrend = channel_flag;
if channel_flag==3
    ctrstart = 2;
    ctrend = 2;
end
%% Main:
for zz = ctrstart:ctrend
    savepath2 = [savepath slashtype nameset{zz}];
    if analysisflag==1
        for aa = 1:length(treatment_dirs)
            [resultfile int_cutoffL resfin_Area resfin_MeanInt]=FociCounter5(savepath2, treatment_dirs{aa},watershed_flag,dateID, int_cutoffL, zz);
            [cellnum3{aa} whstruct(aa,:)] = datExtract5(selcrit_inputs, graph_flags, savepath2, int_cutoffL, dateID, resultfile, resfin_Area,resfin_MeanInt);
            tidx = strfind(treatment_dirs{aa},slashtype);
            tidx = tidx(end);
            tid = treatment_dirs{aa}(tidx+1:end);
            cellnumid{aa} = tid;
            intvec(aa)=int_cutoffL; %for debugging
            
            if ishandle(handle_msgbox) %Check if msgbox is still open or user has closed it
                delete(handle_msgbox);
                clear('handle_msgbox');
            end
            
            handle_msgbox = msgbox([num2str(floor((aa/length(treatment_dirs))*100)) '% Done for Channel: '  nameset{zz} '... Please Wait'], 'FociCounterGUI');
            disp([num2str(floor((aa/length(treatment_dirs))*100)) '% Done for Channel: '  nameset{zz} '... Please Wait'])
            
        end
    elseif analysisflag==0;
        
        for aa=1:length(treatment_dirs)
            tidx = strfind(treatment_dirs{aa},slashtype);
            tidx = tidx(end)+length(dateID); %getting rid of the dateID
            tid = treatment_dirs{aa}(tidx+1:end-18); %'datextractvers.mat' is 18 chars long!
            cellnumid{aa} = tid;
            if ~strcmp(treatment_dirs{aa}(end-3:end),'.mat')
                errordlg('Invalid FileType! Program expects .mat files!')
            end
            load([treatment_dirs{aa}])
            [cellnum3{aa} whstruct(aa,:)]=datExtract5(selcrit_inputs, graph_flags, savepath2, int_cutoffL, dateID, resultfile, resfin_Area,resfin_MeanInt);
            
            if ishandle(handle_msgbox) %Check if msgbox is still open or user has closed it
                delete(handle_msgbox);
                clear('handle_msgbox');
            end
            
            handle_msgbox = msgbox([num2str(floor((aa/length(treatment_dirs))*100)) '% Done ... Please Wait'], 'FociCounterGUI');
            disp([num2str(floor((aa/length(treatment_dirs))*100)) '% Done ... Please Wait'])
        end
        
    end
    %% Plotting Final Data Set:
    %Part1 - Pulling out the data:
    whst_cell = arrayfun(@(x) [num2cell([x.whMean])], whstruct, 'UniformOutput', 0); %Nucleus Int
    whst_cell = cellfun(@(x) cell2mat(x), whst_cell, 'UniformOutput', 0);
    whst_cell = cell2mat(whst_cell);
    
    cellnumvec = cell2mat(cellnum3'); %Perc Cells x foci
    
    for qq = 1:size(whst_cell,1) %Calculating Means and Stdev:
        whst_mean(qq) = mean(nonzeros(whst_cell(qq,:)));
        whst_std(qq) = std(nonzeros(whst_cell(qq,:)));
        cellnum_mean(qq) = mean(nonzeros(cellnumvec(qq,:)));
        cellnum_std(qq) = std(nonzeros(cellnumvec(qq,:)));
    end
    toc
    
    %Part2 - Writing Data to file:
    outvec = {'Name' 'Whole Int d1' 'Whole Int d2' 'Perc Cells d1' 'Perc Cells d2'};
    for nn = 1:length(cellnum3)
        mm = nn+1;
        outvec{mm,1} = cellnumid{nn};
        outvec{mm,2} = whst_cell(nn,1);
        outvec{mm,3} = whst_cell(nn,2);
        outvec{mm,4} = cellnumvec(nn,1);
        outvec{mm,5} = cellnumvec(nn,2);
    end
    xlswrite([savepath2 slashtype dateID '.xlsx'], outvec);
    
    
    %Part3 - Plotting:
    %Whole Nuc Int
    if graph_flags(3)==1
        xv1 = 1:size(whst_cell,1);
        yv1 = whst_mean;
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
        ev2 = cellnum_std;
        figure, barwitherr(ev2,yv2)
        ylabel('Percentage of Cells with >10 foci')
        title('Treatment efficacy')
        set(gca, 'XTickLabel', cellnumid, 'YLim', [0 100])
        set(gcf, 'visible', 'off')
        for i=1:length(cellnum3)
            text(xv2(i), yv2(i), num2str(yv2(i)),'HorizontalAlignment','center', 'VerticalAlignment','bottom')
        end
        hgexport(gcf, [savepath2 slashtype dateID  '_' num2str(qq) '_PcCellsFociBar.jpg'], hgexport('factorystyle'), 'Format', 'jpeg');
        clear whstruct cellnumid cellnum2;
    end
    
    if ishandle(handle_msgbox) %Check if msgbox is still open or user has closed it
        delete(handle_msgbox);
        clear('handle_msgbox');
    end
    
    handle_msgbox = msgbox([nameset{zz} ' Done. Working...'], 'FociCounterGUI');
end
if ishandle(handle_msgbox) %Check if msgbox is still open or user has closed it
    delete(handle_msgbox);
    clear('handle_msgbox');
end
handle_msgbox = msgbox('   Done.','FociCounterGUI');
disp('Done.')
end
% close gcf;