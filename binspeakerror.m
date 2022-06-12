function [min, max] = binspeakerror(hist, bins, peak)
peakLabValue = bins(hist == peak);
bins = cast(bins, 'single');
freqMinIndex =  find(bins == peakLabValue - 30);
freqMaxIndex =  find(bins == peakLabValue + 30);

freqRangeAroundPeak = hist(freqMinIndex:freqMaxIndex);

tot=0;
for i = 1:numel(freqRangeAroundPeak)
   tot = tot + (freqRangeAroundPeak(i) - peak)^2; 
end

peakError = round(sqrt(tot/numel(freqRangeAroundPeak)));
min = bins(knnsearch(hist, peak - peakError));
max = bins(knnseacrch(hist, peak + peakError));

end

