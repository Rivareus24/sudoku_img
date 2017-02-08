function img_enhanced = Enhancement(img)


    %%%%%%%%%%%%%%%%%%%% Calcolo la media del canale s di HSV
    %histogram = imhist(img);
    hsv = rgb2hsv(img);
    %h = hsv(:, :, 1);
    s = hsv(:, :, 2);
    v = hsv(:, :, 3);
    %media = mean(s(:));
    h = imhist(s);
    bianchi = sum(h(10:70));
    %%%%%%%%%%%%%%%%%%%% Scelgo il metodo per migliorare l'immagine
    %if media > 0.3          % COSTANTE DA DECIDERE
    if (bianchi / (size(s,1) * size(s,2))) < 0.4
        disp(['Metodo Utilizzato: ', 'SATURATION', char(10)]);
        img_enhanced = histStrec(img);
        img_enhanced = rgb2gray(img_enhanced);
        %img_enhanced = cercabianco(img, s);
    else
        disp(['Metodo Utilizzato: ', 'GAMMA', char(10)]);
        img_enhanced = Local_Gamma_Correction(v);
        %img_enhanced = LocalGammaCorrection(v);
    end


    %img_enhanced = im2double(img_enhanced);

end
