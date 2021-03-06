%Name: ReshuffleControl.m
%Author: Dhruv Raina
%resets the control directory to the '1' position for cutoff finding.
%gui version

function varargout = ReshuffleControl(treatment_dirs)
slashtype = '/';
ridx = strfind(treatment_dirs,slashtype);
ridx = cell2mat(ridx);
ridx = ridx(end);
for aa = 1:length(treatment_dirs)                                          %reused code, getting dir names
    resultfile{aa} = treatment_dirs{aa}(ridx+1:end);
end
cfinder = cellfun('isempty', strfind(resultfile, 'ontrol'));               % Can be 'C' or 'c'
cidx = find(~cfinder);
tidx = find(cfinder);
%Resetting Control to position number 1:
if cidx~=1
    reshuffle{1} = treatment_dirs{cidx};
    for bb = 2:length(treatment_dirs)
        cc = bb-1;
        reshuffle{bb,1}=treatment_dirs{tidx(cc)};
    end
else
    reshuffle = treatment_dirs;
end
varargout{1}=reshuffle;