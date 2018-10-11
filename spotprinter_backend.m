%Spot Printer: for checking cutoffs and printing sample images.
%author: dhruv raina
%last edit: 220814

function varargout = spotprinter_backend(filepath, savepath, InputVars)
load(filepath)
BatchMode = InputVars{1};
ahicut = InputVars{2};
alowcut = InputVars{3};
ilocut = InputVars{4}; %(sd multiplier)
ihicut = InputVars{5}; %(sd multiplier)
dishnum = InputVars{6};
save_flag = 0;

if BatchMode==1
    pp = 1;
    qq = length(vec_raw_nuc);
    save_flag = 1;
elseif BatchMode==0
    pp = InputVars{7};
    qq = pp;
end
    
for cc1 = pp:qq
    tspotmask = vec_spot_mask{cc1, dishnum};
    tspotimg = vec_raw_fitc{cc1, dishnum};
    [spot_lbl spot_num] = bwlabel(vec_spot_mask{cc1, dishnum});
    tprop = regionprops(spot_lbl, 'Area');
    
    %Spot Area Vector:
    arvec = [tprop(:).Area];
    
    %filt1
    filtA1 = find(arvec<alowcut);
    filtA2 = find(arvec>ahicut);
    filtA3 = [filtA1'; filtA2'];
    filtA3 = filtA3';
    
    %clearing
    for cc2 = filtA3
        tspotmask(spot_lbl==cc2)=0;
    end
    
    clear spot_lbl spot_num tprop;
    [spot_lbl spot_num] = bwlabel(tspotmask);
    tprop = regionprops(spot_lbl, tspotimg, 'MeanIntensity');
    
    %Spot Int Vector:
    intvec = [tprop(:).MeanIntensity];
    
    %filt2
    filti1 = find(intvec<ilocut);
    filti2 = find(intvec>ihicut);
    filti3 = [filti1'; filti2'];
    filti3 = filti3';
    
    %clearing
    for cc2 = filti3
        tspotmask(spot_lbl==cc2)=0;
    end
    
    figure, imshow(tspotmask)
    if save_flag==1
    hgexport(gcf, [savepath num2str(cc1) 'spotimg.jpg'], hgexport('factorystyle'), 'Format', 'jpeg');
    close gcf;
    else
    end
    figure,imshow(tspotimg)
    if save_flag==1
    hgexport(gcf, [savepath num2str(cc1) 'origimg.jpg'], hgexport('factorystyle'), 'Format', 'jpeg');
    close gcf;
    else
    end
end



