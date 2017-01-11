function [original_rows, original_cols, original_img] = read_Img(i)

    %++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    %+++++++++++++++++++++ ACQUISIZIONE IMMAGINE ++++++++++++++++++++++++
    %++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    img = strcat('immagini/', num2str(i), '.jpg');
    img = imread(img);

    %++++++++++++++++ SCALA A QUALCOSA DI CIRCA 1000 x 1000 +++++++++++++
    img = Iscale(img);

    %++++++++++++++++ SALVO UNA COPIA DELL'IMMAGINE +++++++++++++++++++++
    original_img = img;
    [original_rows, original_cols, ~] = size(original_img);


end
