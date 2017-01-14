function [img_downScaled, img_HD] = Read_Img(path, img_Number, extension)

    img_path = strcat(char(path), num2str(img_Number), char(extension));
    img_HD = imread(img_path);

    %++++++++++++++++ SCALA A QUALCOSA DI CIRCA 1000 x 1000 +++++++++++++
    img_downScaled = Down_Scale(img_HD);

end
