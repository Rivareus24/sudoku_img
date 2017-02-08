function out = Local_Gamma_Correction(im)

    im = im2double(im);

    average_matrix = imfilter(im, fspecial('average', [3 3]));

    average_matrix = average_matrix - 0.5;    % -0.5 <-> 0.5

    average_matrix = average_matrix .* 2;

    esp_matrix = exp(average_matrix);

    esp_matrix = 1 ./ esp_matrix;

    temp = im .^ esp_matrix;

    massimo = max(temp(:));

    temp = temp ./ massimo;

    out = temp;

end
