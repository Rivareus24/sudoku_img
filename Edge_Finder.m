function img_edged = Edge_Finder(img)

    img_canny = edge(img, 'canny', [0.1, 0.3]);

    img_edged = imdilate(img_canny, ones(5));

end
