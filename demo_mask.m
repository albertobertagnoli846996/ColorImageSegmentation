clear all


img = imread('TestImages/good_8.jpg');

% Convert RGB image to chosen color space
I = rgb2lab(img);

Img_L = I(:,:,1);
Img_a = I(:,:,2);
Img_b = I(:,:,3);

% a_max = max(Img_a, [], 'all');
% b_max = max(Img_b, [], 'all');

a_mean = mean2(Img_a);
b_mean = mean2(Img_b);

L_mode = mode(round(Img_L), 'all');
a_mode = mode(round(Img_a), 'all');
b_mode = mode(round(Img_b), 'all');


a_var = sqrt(var(Img_a, [], 'all'));
b_var = sqrt(var(Img_b, [], 'all'));


[a_hist, a_bins] = histcounts(Img_a);
[a_peaks, a_pLocs] = findpeaks(a_hist, 'MinPeakHeight', mean(a_hist) + std(a_hist));
if numel(a_peaks) > 1
    [a_peaks, a_pLocs] = findpeaks(a_peaks, 'MinPeakHeight', mean(a_peaks));
end

[b_hist, b_bins] = histcounts(Img_b);
[b_peaks, b_pLocs] = findpeaks(b_hist, 'MinPeakHeight', mean(b_hist) + std(b_hist));
if numel(a_peaks) > 1
    [b_peaks, b_pLocs] = findpeaks(b_peaks, 'MinPeakHeight', mean(b_peaks));
end


if (a_var < 100 && b_var < 100)
    sliderBW = (I(:,:,1) >= 0.000 ) & (I(:,:,1) <= 100);
    
    for i = 1:numel(a_peaks)
        a_peakIndexValue = find(a_hist == a_peaks(i));
        [min, max] = binspeakerror(a_hist, a_bins, a_peaks(i));
        sliderBW = sliderBW & ((I(:,:,2) >= min ) & (I(:,:,2) <= max ));
    end
    
    
    for i = 1: numel(b_peaks)
        b_peakIndexValue = find(b_hist == b_peaks(i));
        b_peakValue = b_bins(b_peakIndexValue);
        sliderBW = sliderBW & ((I(:,:,3) >= b_peakValue-20 ) & (I(:,:,3) <= b_peakValue+20 ));
    end
end

BW = sliderBW;

 

% Invert mask
BW = ~BW;

BW = imfill(BW,'holes');

%Initialize output masked image based on input image.
maskedRGBImage = img;

%Set background pixels where BW is false to zero.
maskedRGBImage(repmat(~BW,[1 1 3])) = 0;

imshow(maskedRGBImage)
