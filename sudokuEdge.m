function sudokuEdgeato = sudokuEdge(img)

    fl = [0,-1,0;  -1,4,-1;   0,-1,0];
    fx = [1, 2,1;   0,0, 0;   1, 2,1];
    fy = [1, 0,1;   2,0, 2;   1, 0,1];

    imx = imfilter(img, fx);
    imy = imfilter(img, fy);
    img = abs(imx) + abs(imy); % non vanno la 5 e la 2 ma va la 10
    img = imfilter(img, fl);        % ??
    %figure, imshow(img), title('Edge-ata');

    sudokuEdgeato = img;

end
