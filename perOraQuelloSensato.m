%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% OUTPUT??????????????????????????%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all, clear all, clc;
num = 29;
for manolo = num : num

[original_rows, original_cols, original_img] = read_Img(manolo);
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
%figure, imagesc(main_Labels), title('Label Numero 1'), axis image, colorbar;
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


    main_ConvexImg = main_Properties(index).ConvexImage;
    %figure, imshow(main_ConvexImg);
    main_Bordo = round(main_Properties(index).BoundingBox);

    stacco = 10;

    img = imcrop(original_img, [main_Bordo(1)-stacco main_Bordo(2)-stacco main_Bordo(3)+stacco*2 main_Bordo(4)+stacco*2]);

    %figure, imshow(img), title('Crop');


    angle = sudokuRotation(main_Properties, index, original_rows, original_cols, original_img);
    %subplot(2, 2, 4), imshow(img), title('Ruotata');
    %figure, imshow(img), title('Ruotata');

    img = imrotate(img, angle, 'bilinear');

    diocane = img;

    img = rgb2gray(img);
    %img = sudokuEdge(img);
    %figure, imshow(img), title('gray');
    %figure, imshow(img), title('Edge');

    %figure, imshow();

    %img = imclose(img, ones(6));
    %img = imerode(img, ones(3));
    img(img == 0) = 0.5;


    %intervalloSauvola = max(main_Bordo(3), main_Bordo(4)) / 15;

    %img = sauvola(img, [intervalloSauvola intervalloSauvola], graythresh(img));

    img = imerode(img, ones(3));

    figure, imshow(img), title('bfvrfeseodews');

    [H, theta, rho] = hough(img, 'Theta', -90);

    P = houghpeaks(H, 10, 'threshold', ceil(0.8 * max(H(:))));

    lines = houghlines (img, theta, rho, P, 'FillGap', 5, 'MinLength', 7);

    figure, imshow(img), hold on

    max_len = 0;
    for k = 1: length(lines)
       xy = [lines(k).point1; lines(k).point2];
       plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

       % Plot beginnings and ends of lines
       plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
       plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

       % Determine the endpoints of the longest line segment
       len = norm(lines(k).point1 - lines(k).point2);
       if ( len > max_len)
          max_len = len;
          xy_long = xy;
       end
    end
    % highlight the longest line segment
    plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','red');



    %img = imclose(img, ones(6));

    [lollo, penna] = bwlabel(img);
    %figure, imagesc(lollo), title('Label Number 2'), axis image, colorbar;


    %%%%%%% CAMBIARE NOME VARIABILI %%%%%%%%%%%%%%

    proprietaaa = regionprops(lollo, 'EulerNumber', 'Area', 'BoundingBox');

    tempArea = [];
    tempIndex = [];
    tempEuler = [];

    for i = 1 : penna
        if proprietaaa(i).EulerNumber < -20
            tempIndex = [tempIndex, i];
            tempEuler = [tempEuler, proprietaaa(i).EulerNumber];
            tempArea = [tempArea, proprietaaa(i).Area];
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

    XXXBordi = proprietaaa(index).BoundingBox;
    img = imcrop(diocane, [XXXBordi(1) XXXBordi(2) XXXBordi(3) XXXBordi(4)]);
    figure, imshow(img), title('DIOCANE');






end
