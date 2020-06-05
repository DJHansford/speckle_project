% Point MATLAB to a folder with speckle JPG images (and no other JPGs) and
% this will normalise them to the following criteria before saving them:
% - Intensity as high as possible for all images without over-exposing
% - Mean intensity same for all images for direct comparison
% - No change in Speckle Contrast values

clear all

s = dir('*.jpg');
file_list={s.name}';
for n=1:length(file_list)
    A(:,:,n) = double(imread(file_list{n}))./256;
    B(n,:) = reshape(A(:,:,n),length(A(:,:,n))^2,1);
    
%     Calculate stats including speckle contrast
    Mean(n) = mean(B(n,:));
    SD(n) = std(B(n,:));
    C = SD./Mean;
    Max(n) = max(B(n,:));
    
%     Calculate which image has biggest SD (spread of values) to use a
%     normalisation standard for all images
    [~, bigSD] = max(SD);
end

for n=1:length(file_list)
%     Normalise images and save new data to compare to old
    A(:,:,n) = A(:,:,n).*(1/Max(1,bigSD)).*(Mean(1,bigSD)/Mean(1,n));
    B(n,:) = reshape(A(:,:,n),length(A(:,:,n))^2,1);
    Mean(2,n) = mean(B(n,:));
    SD(2,n) = std(B(n,:));
    C = SD./Mean;
    Max(2,n) = max(B(n,:));
    
%     figure
%     imshow(A(:,:,n));
    imwrite(A(:,:,n),['Normalised ',file_list{n}]);
    
%     plot(A(:,100,n))
%     ylim([0 1])
%     set(gca,'YTick', linspace(0,1,3),'YTickLabel', linspace(0,1,3))
%     set(gca, 'XTick', [0 1], 'XTickLabel', [])
end