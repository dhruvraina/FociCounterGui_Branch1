% Author:Dhruv Raina
% Last Edit:240714
% Dependencies: resfin files obtained from FociCounter.m
%data viewer for FociCounter. Reads in resfin_MeanInt etc.

% clearvars -except resfin_Area resfin_MeanInt resfin_Peri dateID
% resultfile

function varargout = datExtract5(selcrit_inputs, graph_flags, savepath, int_cutoffL, dateID, resultfile, resfin_Area, resfin_MeanInt, resfin_OtherParams)
%% Standalone Running:
%dateID = {'tester'};
%resultfile = {'testerf'};
%int_cutoffL = 0.1407; %arbit number
%graph_flags = ones(4);
%selcrit_inputs(1) = 7;
%selcrit_inputs(2) = 60;
%selcrit_inputs(3) = 10;
%savepath = 'C:/Users/ncbs/Desktop'

%% Constants:
savepath = [savepath '/datExtract_images/'];
if ~exist(savepath,'dir')
    mkdir(savepath);
end
savescat = graph_flags(1); %save flags
savebar = graph_flags(2);
convfac = 65535;
aselcritH = selcrit_inputs(1);
aselcritL = selcrit_inputs(2);
iselcritH = 1; %Max Intensity, i.e. no cutoff
iselcritL = int_cutoffL; %Comes from matched controls
nspot = selcrit_inputs(3); %cells with greater than nspot are recorded for final dat set
dishset = {'d1' 'd2'};

%% Parsing,Reformatting:
if nargin<7
    resfin_OtherParams=[];
else
end
for cc=1:size(resfin_MeanInt,2)
    atotvec = [];
    itotvec = [];
    
    for aa = 1:size(resfin_MeanInt, 1)
        atotvec = [atotvec; resfin_Area{aa,cc}];
        itotvec = [itotvec; resfin_MeanInt{aa,cc}];
    end
    nucnum = size(atotvec,cc);
    atotvec = atotvec';
    itotvec = itotvec';
    
    %Whole Nuc intensity:
    whInt = itotvec(1,:);
    whInt = whInt';
    whstruct(cc).whInt = whInt.*convfac; %Storing per-dish whole nuc int + mean
    whstruct(cc).whMean = mean(whstruct(cc).whInt);
    %whstruct.whStd = std(whstruct(:).whInt);
    
    %% Filters:
    ttt = find(atotvec>aselcritH); %Area Filter
    ttt2 = find(atotvec<aselcritL);
    ttt3 = [ttt;ttt2];
    atotvec(ttt3)=0;
    itotvec(ttt3)=0;
    
    ggg = find(itotvec<iselcritL); %Int Filter
    ggg2 = find(itotvec>iselcritH);
    ggg3 = [ggg;ggg2];
    atotvec(ggg3) = 0;
    itotvec(ggg3) = 0;
    
    intconv = nonzeros(itotvec(:));
    arconv = nonzeros(atotvec(:));
    intconv = intconv.*convfac;
    
    meanconv = floor(mean(intconv));
    stdconv = floor(std(intconv));
    numconv = size(atotvec,2);
    
    %% Plotting Scatter: (ar vs. int)
    if savescat==1
        figure,scatter(arconv, intconv,2);
        xlabel('Area')
        ylabel('Intensity')
        title([resultfile dishset{cc}])
        legend(['Mean Intensity: ' num2str(meanconv) '  InternalStDev: ' num2str(stdconv) ' n= ' num2str(numconv)] )
        set(gca, 'XLim', [0 80], 'YLim', [100 65535])
        set(gcf, 'visible', 'off')
        hgexport(gcf, [savepath 'Scat_' dateID resultfile dishset{cc} '.jpg'], hgexport('factorystyle'), 'Format', 'jpeg');
        close gcf;
    else
    end
    
    %% Calculating Bar: (no. foci per nuc)
    [~, dd] = size(atotvec);
    for ab = 1:dd
        temp_ctr = nonzeros(atotvec(:,ab));
        spot_ctr(ab,1)=length(temp_ctr);
        clear temp_ctr;
    end
    
    for ac = 1:50 %max num of spots
        temp_vec=find(spot_ctr==ac);
        spot_hist(ac)=length(temp_vec);
        clear temp_vec;
    end
    spot_histp=(spot_hist./dd).*100;
    
    %% Plotting Bar:
    if savebar==1
        figure, bar(spot_histp)
        xlabel('Number of Foci')
        ylabel('Percentage of Cells')
        title([resultfile dishset{cc}])
        %legend(['n= ' num2str(numconv)])
        legend(['Int Cutoff= ' num2str(int_cutoffL*convfac) ' n= ' num2str(numconv)])
        set(gca, 'XLim', [0 30], 'YLim', [0 35])
        set(gcf, 'visible', 'off')
        %set(gca, 'XLim', [0 45], 'YLim', [0 40])
        hgexport(gcf, [savepath 'Bar_' dateID resultfile dishset{cc} '.jpg'], hgexport('factorystyle'), 'Format', 'jpeg');
        close gcf;
    else
    end
    
    %% Plotting percentage cells with >n spots:
    cellnum = sum(spot_hist(nspot:50));
    cellnum2=(cellnum/dd)*100;
    
    %storing per-dish values:
    cellnum3(cc)= cellnum2;
    clear cellnum2 cellnum ttt ttt2 ttt3 ggg ggg2 ggg3 intconv arconv spot_histp whInt spot_ctr spot_hist
end

varargout{1} = cellnum3;
varargout{2} = whstruct;
end
