%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% OUTPUT??????????????????????????%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all, clear all, clc;

num = 29;
for manolo = num : num

[original_rows, original_cols, original_img] = start(manolo);
img = original_img;     % copia in RGB
original_img = im2double(original_img);

hsv = rgb2hsv(img);
s = hsv(:, :, 2);
m = mean(s(:));

if m < 0.3
    img = gammaC(img);
    'GAMMA'
else
    img = cercabianco(img, s);
    'SATURATION'
end

img = im2double(img);

img = sudokuEdge(img);
%figure('units','normalized','outerposition',[0 0 1 1]), subplot(2, 2, 1), imshow(img), title('Edge');
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%+++++++++++++++++++++++ THRESHOLDING +++++++++++++++++++++++++++++++
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
img = imclose(img, ones(6));
thresh = graythresh(img);
img(img > thresh) = 1;
img(img <= thresh) = 0;
%subplot(2, 2, 2), imshow(img), title('BlackWhite');
clear thresh;

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%+++++++++++++++++ LABELING COMPONENTI CONNESSE ++++++++++++++++++++
[main_Labels, main_N] = bwlabel(img);
%figure, imagesc(main_Labels), axis image, colorbar;
%subplot(2, 2, 3), imagesc(main_Labels), axis image, colorbar;
main_Properties = regionprops(main_Labels, 'ConvexImage', 'EulerNumber', 'BoundingBox', 'Area');


%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%++++++++++++++++++ SCELTA COMPONENTE CORRETTA ++++++++++++++++++++++
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
tempArea = [];
tempIndex = [];
tempEuler = [];

for i = 1 : main_N
    if main_Properties(i).EulerNumber < -20
        tempIndex = [tempIndex, i];
        tempEuler = [tempEuler, main_Properties(i).EulerNumber];
        tempArea = [tempArea, main_Properties(i).Area];
    end
end

    eul_massimo = max(abs(tempEuler));
    indexE = find(abs(tempEuler) == eul_massimo);
    area_massimo = max(tempArea);
    indexA = find(tempArea == area_massimo);

    if indexA == indexE
        index = tempIndex(indexA);
    else
        'Indici di area massima e di eulero massimo DIVERSI'
    end

    img = sudokuRotation(main_Properties, index, original_rows, original_cols, original_img);
    %subplot(2, 2, 4), imshow(img), title('Ruotata');
    figure, imshow(img), title('Ruotata');

    img = rgb2gray(img);

    %figure, imshow(sudokuEdge(img));
    
    %img = imclose(img, ones(10));
    thresh = graythresh(img);
    img(img > thresh) = 1;
    img(img <= thresh) = 0;
    %subplot(2, 2, 2), imshow(img), title('BlackWhite');
    clear thresh;

    %figure, imshow(sudokuEdge(img));

end
