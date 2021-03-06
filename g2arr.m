
invec = {'CCA4_C_1.xls' 'CCA4_C_2.xls' 'CCA4_4_1.xls' 'CCA4_4_2.xls' 'CCA4_8_1.xls' 'CCA4_8_2.xls' 'CCA4_12_1.xls' 'CCA4_12_2.xls'}; %Trial 1
%inname = {'150nM NCS 8h - dish1' '150nM NCS 8h - dish2' '150nM NCS 12h - dish1' '150nM NCS 12h - dish2' 'Control - dish1'};
inname = {'Control - dish1' 'Control - dish2' '150nM NCS 4h - dish1' '150nM NCS 4h - dish2' '150nM NCS 8h - dish1' '150nM NCS 8h - dish2' '150nM NCS 12h - dish1' '150nM NCS 12h - dish2'};
inputdir = 'C:\Users\ncbs\Desktop\CCA\4';
slashtype = '/';
inputdir(inputdir=='\')='/';

close all
for ii = 1:8
inputxls = xlsread([inputdir slashtype invec{ii}],'G1:I1000');
dapivals = inputxls(:,1);
fitcvals = inputxls(:,3);

dapivals = dapivals./1000;
fitcvals = fitcvals./1000;
cellnum(ii) = length(dapivals);

%DAPI filters
idx = find(dapivals>135);
templen_ch1_d = dapivals(idx);
templen_ch2_d = fitcvals(idx);

%FITC filters
idx2 = find(fitcvals>135);
templen_ch1_f = dapivals(idx2);
templen_ch2_f = fitcvals(idx2);

percells_d(ii) = (length(templen_ch1_d)/length(dapivals))*100;
percells_f(ii) = (length(templen_ch2_f)/length(fitcvals))*100;

% figure, scatter(templen_ch1_f, templen_ch2_f, '.')
% set(gca, 'XLim', [0 450], 'YLim', [0 350]);
% legend(['%pH3 positive: ' num2str(floor(percells_f(ii)))])
figure, hist(dapivals, 250)
xlabel('DAPI intensity (x1000)')
ylabel('Counts')
set(gca, 'XLim', [0 450], 'YLim', [0 30])
legend(['% G2 population: ' num2str(floor(percells_d(ii))) ' ;n= ' num2str(cellnum(ii))])
title(inname{ii})
% figure, scatter(dapivals, fitcvals, '.')
% set(gca, 'XLim', [0 450], 'YLim', [0 350]);
% legend(['%pH3 positive: ' num2str(floor(percells_f(ii)))])

end