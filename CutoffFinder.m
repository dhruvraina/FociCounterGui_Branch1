%For calculating low int cutoff in FociCounter4.m


function varargout = CutoffFinder(resfin_MeanInt)
itotvec = [];
resTot_MeanInt = reshape(resfin_MeanInt, length(resfin_MeanInt(:,1))+length(resfin_MeanInt(:,2)),1);
for aa = 1:size(resTot_MeanInt,1)
   itotvec= [itotvec; resTot_MeanInt{aa,1}];
end
itotvec = itotvec';
itotvec(1,:)=0;
itotvec2 = nonzeros(itotvec(:));
meanval = mean(itotvec2);
stdval = std(itotvec2);
int_cutoffL = meanval+(1*stdval);
varargout{1} = int_cutoffL;
end