function angle = sudokuRotation(main_Properties, box, original_rows, original_cols, original_img)




    %+++++++++++++++++++++ ROTAZIONE IMMAGINE +++++++++++++++++++++++++++
    %++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    %++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    main_ConvexImg = main_Properties(box).ConvexImage;
    %figure, imshow(main_ConvexImg);
    main_Bordo = round(main_Properties(box).BoundingBox);
    temp_img = imcrop(original_img, [main_Bordo(1)-5 main_Bordo(2)-5 main_Bordo(3) + 10 main_Bordo(4) + 10]);

    pixels = size(main_ConvexImg, 1) * size(main_ConvexImg, 2);
    temp = 1 - main_ConvexImg;
    extra = sum(temp(:));
    new_perc = extra / pixels;
    coeff = new_perc;
    %figure, imshow(main_ConvexImg);

    oldCoeff = coeff * 5;
    old_perc = new_perc;
    ruotataPrec = main_ConvexImg;

    clockwise = Iverso(main_ConvexImg);

    while true

        R_ConvexImg = ceil(imrotate(main_ConvexImg, clockwise * coeff, 'bilinear'));
        R_original_img = ceil(imrotate(original_img, clockwise * coeff, 'bilinear'));
        [r, c] = size(R_original_img);

        [R_labels, R_n] = bwlabel(R_ConvexImg);
        R_properties = regionprops(R_labels, 'ConvexImage', 'ConvexArea', 'BoundingBox');
        R_ConvexImg = R_properties(1).ConvexImage;
        R_bordo = round(R_properties(1).BoundingBox);

        [R_rows, R_cols] = size(R_ConvexImg);
        pixels = R_rows * R_cols;
        R_ConvexImg_negative = 1 - R_ConvexImg;
        extra = sum(R_ConvexImg_negative(:));
        new_perc = extra / pixels;
        coeff = new_perc * 5;
        coeff = oldCoeff + coeff;

        %newBordo(1) = main_Bordo(1) + R_bordo(1);
        %newBordo(2) = main_Bordo(2) + R_bordo(2);
        %newBordo(3) = round(newBordo(1) + R_bordo(3));
        %newBordo(4) = round(newBordo(2) + R_bordo(4));
        R_original_mask = zeros(r, c);
        R_original_mask(main_Bordo(2) : main_Bordo(2) + main_Bordo(4), main_Bordo(1) : main_Bordo(1) + main_Bordo(3)) = 1;
        %R_original_img_masked = R_original_mask .* R_original_img;
        %original_img_masked_cropped = imcrop(R_original_img_masked, [main_Bordo(1) main_Bordo(2) main_Bordo(3) main_Bordo(4)]);

        %figure, imshow(R_original_img_masked);

        if old_perc < new_perc && old_perc < 3
            angle = clockwise * coeff;
            break;
        end

        oldCoeff = coeff;
        old_perc = new_perc;
        ruotataPrec = R_ConvexImg;

    end
    %figure, imshow(temp_img);
    %[row_temp_img, col_temp_img, ~] = size(temp_img)

    %media = mean2(temp_img);
    %temp_img = imrotate(temp_img, angle, 'bilinear');
    %temp_img = rgb2gray(temp_img);
    %figure, imshow(temp_img);



    %temp_img(temp_img ~= 0) = 1;
    %figure, imshow(temp_img);


    %rad = deg2rad(angle);
    %t = tan(abs(rad));
    %c = cos(abs(rad));
    %s = sin(abs(rad));

    %cateto = max(row_temp_img, col_temp_img) / (t + 1)
    %cateto2 = min(row_temp_img, col_temp_img) - cateto
    %ipotenusa = (cateto^2 + cateto2^2)^(1/2)
    %temp_img = imcrop(temp_img, [cateto cateto2 ipotenusa ipotenusa]);

    %figure, imshow(temp_img), title('AAAAAAAAAAAAAAAAAAAAaa');

    %nuove = [main_Bordo(1), main_Bordo(2)] * [c -s;s c];
    %nuove = abs(nuove)
    %nuove(1)  = original_rows * s;
    %nuove(2) = main_Bordo(2) / c;

    %temp_img = imrotate(original_img, angle, 'bilinear', 'crop');

    %figure, imshow(temp_img);
    %figure, imshow(original_img);

end
