function varargout = gradientThresh(inputmat)
hist1 = sort(nonzeros(inputmat));
perc50 = floor(0.5*length(hist1));
fx = gradient(hist1); %normalized values in hist1; delta between successive values.
averager = mean(fx(1:perc50)); %Takes average change between first 50pc successive values.
filt1 = find(fx>100*averager); %Look for changes in slope >100 times the norm. (Plot 'fx', the point where the slope changes is ~100x averager)
filt2 = hist1(filt1);
if ~isempty(filt2)
    cutoff = min(filt2);
else
    cutoff = 1;
end
varargout{1} = cutoff;
end
