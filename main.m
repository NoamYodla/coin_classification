% Coin Classification using Image Processing & Clustering

% 1. Image Preparation
filtsize = 85;
filtsizeh = floor(filtsize/2);

im1 = imread('coins.png');
im2 = 255 - imread('eight.tif'); % Invert for consistency

[r1, c1] = size(im1);
[r2, ~] = size(im2);

im = zeros(r1 + r2 + filtsize, c1 + filtsize);
im(filtsizeh+1:filtsizeh+r1+r2, filtsizeh+1:filtsizeh+c1) = [im1; im2(:,1:c1)];

imagesc(im); colormap(gray); title('Test Image'); axis equal;

% 2. Segmentation and Centroid Detection
msk = OtsuThreshold(im);
msk_dil = imdilate(msk, ones(9,9));
msk_dil_erd = imerode(msk_dil, ones(23,23));

figure; imagesc(msk); colormap(gray); title('Otsu Threshold'); axis equal;
figure; imagesc(msk_dil); colormap(gray); title('Dilated Mask'); axis equal;
figure; imagesc(msk_dil_erd); colormap(gray); title('Eroded Mask'); axis equal;

cc = bwconncomp(msk_dil_erd);
props = regionprops(cc);
centroid = round(reshape([props.Centroid],2,[])');
component_size = [props.Area]';

% 3. Feature Extraction using Matching Filters
dimediameter = 31; nickeldiameter = 41; quarterdiameter = 51;

dimefilter = MakeCircleMatchingFilter(dimediameter, filtsize);
nickelfilter = MakeCircleMatchingFilter(nickeldiameter, filtsize);
quarterfilter = MakeCircleMatchingFilter(quarterdiameter, filtsize);

figure;
subplot(1,3,1); imagesc(dimefilter); colormap(gray); title('Dime Filter'); axis tight equal;
subplot(1,3,2); imagesc(nickelfilter); colormap(gray); title('Nickel Filter'); axis tight equal;
subplot(1,3,3); imagesc(quarterfilter); colormap(gray); title('Quarter Filter'); axis tight equal;

D = zeros(length(centroid), 3);
for i = 1:length(centroid)
    region = reshape(msk_dil_erd(centroid(i,2)-filtsizeh:centroid(i,2)+filtsizeh, ...
                                 centroid(i,1)-filtsizeh:centroid(i,1)+filtsizeh), [], 1);
    D(i,1) = corr(dimefilter(:), region);
    D(i,2) = corr(nickelfilter(:), region);
    D(i,3) = corr(quarterfilter(:), region);
end

% 4. Clustering and Classification
rng(0);
k = 3;
cls_init = kmeans(D, k);

avg_sizes = [mean(component_size(cls_init==1)); 
             mean(component_size(cls_init==2)); 
             mean(component_size(cls_init==3))];

[~, classmap] = sort(avg_sizes);
cls = arrayfun(@(x) find(classmap == x), cls_init);

% 5. Visualization
figure; imagesc(im); colormap(gray); title('Detected Coins'); hold on; axis equal;

totcount = zeros(size(cls));
for i = 1:length(cls)
    [coinvalue, ~, ~, ~] = AddCoinToPlotAndCount(centroid(i,1), centroid(i,2), cls(i));
    totcount(i) = coinvalue;
end
totcount = sum(totcount);
title([num2str(totcount), ' cents']);