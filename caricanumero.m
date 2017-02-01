function out = caricanumero(img)
        %figure, imshow(img);
    [labels, n] = bwlabel(img);
    prop = regionprops(labels, 'BoundingBox', 'EulerNumber', 'Area'); % SPOSTO QUESTO IN RIDOTTO
    %figure, imagesc(labels), title('Labelling'), axis image;
    temp = -1;
    for i = 1 : n
        if prop(i).Area > temp
            break
        end
    end

    bordo = prop(i).BoundingBox;
    e = prop(i).EulerNumber;
    img = imcrop(img, [bordo(1) bordo(2) bordo(3) bordo(4)]);
    %Show_Img(img, '3erfd')
    if  bordo(3) < bordo(4)/2 % E' UN UNO
        img = imresize(img, [20 6]);
        img = padarray(img, [4 11]);
        img = imclose(img, ones(3));
        %img = imopen(img, ones(3));
    else
        img = imresize(img, [20 20]);
        img = padarray(img, [4 4]);
    end
    img(img < 1) = 0;
    img(img >= 1) = 1;
    img = img';
    img = img .* 255;
    img = imfill(img,'holes');
    out = {img, e};
end
