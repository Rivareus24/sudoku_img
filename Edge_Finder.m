function img_edged = Edge_Finder(img)

    %%%%%%%%%%%%%%% CANNY probabilmente è meglio
    fl = [0,-1,0;  -1,4,-1;   0,-1,0];
    fX = [1, 2,1;   0,0, 0;   1, 2,1];
    fY = [1, 0,1;   2,0, 2;   1, 0,1];

    X_edged = imfilter(img, fX);
    Y_edged = imfilter(img, fY);
    img = abs(X_edged) + abs(Y_edged);
    img_edged = imfilter(img, fl);

end
