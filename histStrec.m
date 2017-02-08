function img = histStrec(im)

cform = makecform('srgb2lab');
lab_he = applycform(im,cform);


ab = double(lab_he(:,:,2:3));
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,2);

nColors = 3;
cluster_idx = kmeans(ab,nColors,'distance','sqEuclidean', ...
                                      'Replicates',3);

pixel_labels = reshape(cluster_idx,nrows,ncols);

segmented_images = cell(1,3);
rgb_label = repmat(pixel_labels,[1 1 3]);

for k = 1:nColors
    color = im;
    color(rgb_label ~= k) = 0;
    segmented_images{k} = color;
end

x1 = sum(segmented_images{1}(:))/ nnz(segmented_images{1}(:));
x2 = sum(segmented_images{2}(:))/ nnz(segmented_images{2}(:));
x3 = sum(segmented_images{3}(:))/ nnz(segmented_images{3}(:));

if max([x1; x2; x3]) == x1
    img = segmented_images{1};
end
if max([x1; x2; x3]) == x2
    img = segmented_images{1};
end
if max([x1; x2; x3]) == x3
    img = segmented_images{1};
end

figure, imshow(img);
figure, imshow(segmented_images{1}), title('objects in cluster 1');
figure, imshow(segmented_images{2}), title('objects in cluster 2');
figure, imshow(segmented_images{3}), title('objects in cluster 3');
end
