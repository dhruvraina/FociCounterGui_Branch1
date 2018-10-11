%Function Name: hetero(input nuclear mask, input mat2gray fluorescence image
%Description: Outputs the granularity and clumping of the nucleus.
%Calculated using Young and Mayhall(1986). Divides nucleus into 3 groups of
%pixels by intensity. In datExtract, hetero = Ng/(Ntot); clump = |Nb-Nw|/(Nb+Nw)
%Nb = num black pixels, Nw = num white px, Ng = num gray pixels
%Author: Dhruv Raina
%Last Edit: 29092014

function varargout = hetero(nucMask, flInput)
outimg = zeros(512,512);
hetimg = outimg;
nucNum = max(nucMask(:));
for ii = 1:nucNum
    tmask = zeros(512, 512);
    tlog1_1 = zeros(512,512);
    tmask(nucMask==ii)=1;
    tvec = tmask.*flInput;
    tvec = tvec(:);
    tvecmean = mean(nonzeros(tvec));
    tvecCut = 0.2*tvecmean;                                                % 20% from the mean on either side
    tvecL1 = tvecmean-tvecCut;
    tvecL2 = tvecmean+tvecCut;
    tlog1 = tvec<tvecL1;
    tlog2 = tvec>tvecL2;
    tlog3 = ~tlog1.*~tlog2;
    %tbin1 = tlog1.*tvec;
    %tbin2 = nonzeros(tlog2.*tvec);
    %tbin3 = nonzeros(tlog3.*tvec);
    outimg(tlog1==1)=1;                                                    %Black Pixels (includes entire image background. tlog1 is recalculated as tlog1_1
    outimg(tlog2==1)=2;                                                    %White Pixels
    outimg(tlog3==1)=1.5;                                                  %Gray Pixels
    outimg = outimg.*tmask;
    tlog1_1(outimg==1)=1;                                                  %Actual count of total black pixels
    hetimg = hetimg+outimg;
    hetperc(1,ii)= length(nonzeros(tlog1_1(:)))/length(nonzeros(tvec));
    hetperc(2,ii)= length(nonzeros(tlog2))/length(nonzeros(tvec));
    hetperc(3,ii)= length(nonzeros(tlog3))/length(nonzeros(tvec));
    hetperc(4,ii)= length(nonzeros(tvec));
    tvecMean(ii) = tvecmean;                                               %not required. Only used during testing.
    tvecfin{ii}=hist(nonzeros(tvec));                                      %not required. Only used during testing.
end

varargout{1} = hetperc;
varargout{2} = hetimg;
end