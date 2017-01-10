% Controlla che l'immagine dovrà essere girata in senso
% orario (TRUE) o antiorario (FALSE)
function clockwise = Iverso(im)

    Y = size(im, 1);
    X = size(im, 2);

    Y2 = round(Y / 2 - 30);

    for i = 1 : 15
        k = 1;
        while im(Y2 + i*4, k) ~= 1
            k = k + 1;
        end
        cateti(i) = k;
    end

    counter = 0;

    for j = 4 : size(cateti, 2)
        if cateti(j - 1) < cateti(j) | cateti(j - 2) < cateti(j) | cateti(j - 3) < cateti(j)
            counter = counter + 1;
        end
    end

    if counter > 8     % NON LO SO ANCORA
        clockwise = -1;
    else
        clockwise = 1;
    end

end
