function sudokuDritto = sudokuRotation(main_Properties, box, original_rows, original_cols, original_img)




    %+++++++++++++++++++++ ROTAZIONE IMMAGINE +++++++++++++++++++++++++++
    %++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    %++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    main_ConvexImg = main_Properties(box).ConvexImage;
    main_Bordo = round(main_Properties(box).BoundingBox);
    mask = zeros(original_rows, original_cols);
    mask(main_Bordo(2):main_Bordo(2)+main_Bordo(4), main_Bordo(1):main_Bordo(1)+main_Bordo(3)) = 1;
    temp_img = mask .* original_img;
    temp_img = imcrop(temp_img, [main_Bordo(1) main_Bordo(2) main_Bordo(3) main_Bordo(4)]);

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
    %temp_img = imrotate(temp_img, angle, 'bilinear');

    angle2 = angle;
    angle2 = deg2rad(angle2);
    c = cos(abs(angle2));
    s = sin(abs(angle2));
    %nuove = [main_Bordo(1), main_Bordo(2)] * [c -s;s c];
    %nuove = abs(nuove)
    nuove(1)  = original_rows * s
    nuove(2) = main_Bordo(2) / c
    c
    s
    main_Bordo(2)
    angle

    temp_img = imrotate(original_img, angle, 'bilinear');

    figure, imshow(temp_img);
    %figure, imshow(original_img);

    temp_img = imcrop(temp_img, [nuove(1) nuove(2) 1000 1000]);
    sudokuDritto = temp_img;


end
