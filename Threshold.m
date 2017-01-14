function img_BW = Threshold(img)

    thresh = graythresh(img);
    img(img > thresh) = 1;
    img(img <= thresh) = 0;


    img_BW = img;

end
