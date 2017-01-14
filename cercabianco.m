function out = cercabianco(img, s)
    m = mean(s(:));
    thresh = m - (m/3);  % poi vedo

    s(s >  thresh) = 1;
    s(s <= thresh) = 0;
    s = 1 - s;
    img = im2double(img);
    img = s .* rgb2gray(img);
        %figure, imshow(img);
    out = img;
end
