function out = caricanumero(img)
        %figure, imshow(img);
    [labels, n] = bwlabel(img);
    prop = regionprops(labels, 'BoundingBox', 'EulerNumber', 'Area'); % SPOSTO QUESTO IN RIDOTTO
    %figure, imagesc(labels), title('Labelling'), axis image;
    [x, y] = size(img);
    temp = x * y * 0.05;
    flag = true;

    if (n == 0)  %completamente vuota
        out = {zeros(28, 28), 0};
        return
    else
        for i = 1 : n
            if prop(i).Area > temp % controllo che sia effettivamente un numero
                flag = false;
                break
            end
        end
    end

    if (flag) %roba no numero
        out = {zeros(28, 28), 0};
        return
    end

    bordo = prop(i).BoundingBox;
    e = prop(i).EulerNumber;
    img = imcrop(img, [bordo(1) bordo(2) bordo(3) bordo(4)]);
    %figure, imshow(img);
    if  bordo(3) < bordo(4) / 2 % E' UN UNO
        img = imresize(img, [20 6]);
        img = padarray(img, [4 11]);
        img = imclose(img, ones(3));
        %img = imopen(img, ones(3));
    else
        img = imresize(img, [20 20]);
        %figure, imshow(img);
        img = padarray(img, [4 4]);
    end
    img(img < 1) = 0;
    img(img >= 1) = 1;
    img = img';
    %figure, imshow(img);
    img = img .* 255;
    %figure, imshow(img);
    img = imfill(img, 8 , 'holes');
    %figure, imshow(img);
    out = {img, e};
end
