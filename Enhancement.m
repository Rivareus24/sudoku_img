function img_enhanced = Enhancement(img)


    %%%%%%%%%%%%%%%%%%%% Calcolo la media del canale s di HSV
    hsv = rgb2hsv(img);
    %h = hsv(:, :, 1);
    s = hsv(:, :, 2);
    %v = hsv(:, :, 3);
    media = mean(s(:));


    %%%%%%%%%%%%%%%%%%%% Scelgo il metodo per migliorare l'immagine
    if media < 0.3          % COSTANTE DA DECIDERE
        disp(['Metodo Utilizzato: ', 'GAMMA', char(10)]);
        img_enhanced = LocalGammaCorrection(img);
    else
        disp(['Metodo Utilizzato: ', 'SATURATION', char(10)]);
        img_enhanced = cercabianco(img, s);
    end


    %img_enhanced = im2double(img_enhanced);

end
