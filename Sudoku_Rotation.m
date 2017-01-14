function angle = Sudoku_Rotation(Sudoku_CI)

    %%%%%%%%%%%%%%%%%%%% Identifico il senso in cui dovrò girare il Sudoku
    %%%%%%%%%%%%%%%%%%%% clockwise = true =====> Senso Orario
    clockwise = IsClockwise(Sudoku_CI);


    %%%%%%%%%%%%%%%%%%%% Struct dell'immagine ruotante
    Img_Rotated = struct();
    Img_Rotated = Add_Property(Img_Rotated, 'CI_temp', Sudoku_CI);
    Img_Rotated = Add_Property(Img_Rotated, 'CI_rotated', Sudoku_CI);
    Img_Rotated = Add_Property(Img_Rotated, 'black_perc_old', 1);
    Img_Rotated = Add_Property(Img_Rotated, 'coeff_old', 0);


    while true


        %%%%%%%%%%%%%%%%%%%% Calcolo le dimensioni
        [rows, cols] = size(Img_Rotated.CI_rotated);
        Img_Rotated = Add_Property(Img_Rotated, 'rows', rows);
        Img_Rotated = Add_Property(Img_Rotated, 'cols', cols);
        Img_Rotated = Add_Property(Img_Rotated, 'pixels', ...
            Img_Rotated.rows * Img_Rotated.cols);


        %%%%%%%%%%%%%%%%%%%% Calcolo Percentuali & Coefficienti
        Img_Rotated = Add_Property(Img_Rotated, 'black_pixels', ...
            sum(~Img_Rotated.CI_rotated(:)));
        Img_Rotated = Add_Property(Img_Rotated, 'black_perc_new', ...
            Img_Rotated.black_pixels / Img_Rotated.pixels);
        Img_Rotated = Add_Property(Img_Rotated, 'coeff_new', ...
            Img_Rotated.coeff_old + (Img_Rotated.black_perc_new * 5));
        %%%%%%%%%%%%%%%%%%%% WARNING 5?????????????????


        %%%%%%%%%%%%%%%%%%%% Controllo se il nero è aumentato, nel caso esco
        if Img_Rotated.black_perc_new > Img_Rotated.black_perc_old && ...
                Img_Rotated.black_perc_old < 3 %%%%%%%%%%% WARNING
            angle = clockwise * Img_Rotated.coeff_new;
            break;
        end


        %%%%%%%%%%%%%%%%%%%% Calcolo angolo di rotazione, ruoto la CI
        Img_Rotated = Add_Property(Img_Rotated, 'angle', ...
            clockwise * Img_Rotated.coeff_new);
        Img_Rotated = Add_Property(Img_Rotated, 'CI_rotated', ...
        ceil(imrotate(Img_Rotated.CI_temp, Img_Rotated.angle, 'bilinear')));


        %%%%%%%%%%%%%%%%%%%% Labelling componenti connesse
        [R_labels, R_n] = bwlabel(Img_Rotated.CI_rotated);
        Img_Rotated = Add_Property(Img_Rotated, 'labels', R_labels);
        Img_Rotated = Add_Property(Img_Rotated, 'labels_number', R_n);


        %%%%%%%%%%%%%%%%%%%% Regionprops
        Img_Rotated = Add_Property(Img_Rotated, 'properties', ...
            regionprops(Img_Rotated.labels, 'ConvexImage', 'BoundingBox'));
        Img_Rotated.CI_rotated = Img_Rotated.properties(1).ConvexImage;


        %%%%%%%%%%%%%%%%%%%% Salvo la percentuale e il coefficiente
        Img_Rotated.black_perc_old = Img_Rotated.black_perc_new;
        Img_Rotated.coeff_old = Img_Rotated.coeff_new;


    end


end
