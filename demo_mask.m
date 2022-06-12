clear all


img = imread('coral-314834.jpg');

% [BW, RGBmasked] = createMaskMAX(img);

% Convert RGB image to chosen color space
I = rgb2lab(img);

% Img_a = double(I(:,:,2))./255;
% Img_b = double(I(:,:,3))./255;

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
    disp('quo');
    sliderBW = (I(:,:,1) >= 0.000 ) & (I(:,:,1) <= 100);
    
    for i = 1:numel(a_peaks)
        a_peakIndexValue = find(a_hist == a_peaks(i));
        a_peakValue = a_bins(a_peakIndexValue);
        sliderBW = sliderBW & ((I(:,:,2) >= a_peakValue-20 ) & (I(:,:,2) <= a_peakValue+20 ));
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
disp('qui');

imshow(maskedRGBImage)



%         % Define thresholds for channel 1 based on histogram settings
%         channel1Min = 0.000;
%         channel1Max = 97.752;
%
%         % Define thresholds for channel 2 based on histogram settings
%         channel2Min = a_mode - 10;
%         channel2Max = a_mode + 10;
%
%         % Define thresholds for channel 3 based on histogram settings
%         channel3Min = b_mode - 10;
%         channel3Max = b_mode + 10;
%
%         % Create mask based on chosen histogram thresholds
%         sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
%             (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
%             (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
%         BW = sliderBW;
%
%         % Invert mask
%         BW = ~BW;
%
%         % Initialize output masked image based on input image.
%         maskedRGBImage = img;
%
%         % Set background pixels where BW is false to zero.
%         maskedRGBImage(repmat(~BW,[1 1 3])) = 0;
%         disp('qui');


% end
% end
% imshow(maskedRGBImage)