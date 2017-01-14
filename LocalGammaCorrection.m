function out = LocalGammaCorrection(im)

    %clear massimo;
    im = double(im);

    pad = padarray(V, [2 2], 'symmetric');


    [rows, cols] = size(pad);
    copia = pad;

    raggio_I = 2;

    for i = 1 + raggio_I : rows - raggio_I
        for j = 1 + raggio_I : cols - raggio_I
                %index = index + 1;
                intorno = pad(i - raggio_I : i + raggio_I, j - raggio_I : j + raggio_I);

                media_intorno = mean2(intorno);           % 0.0 <= media <= 255.0

                media = (media_intorno / 127.5);          % 0.0 <= media <= 2.0

                costante = 1;                               % per mantenere esp nell'intorno di media

                if     media == 2       esp = 1;
                elseif media == 0       esp = 1;
                elseif media > 1        esp = media * costante;
                elseif media < 1        esp = (1 / (2 - media)) * costante;
                else                    esp = 1;
                end

                pad(i, j)  = pad(i, j) / 255;
                copia(i, j) = power(pad(i, j), esp);
                copia(i, j) = copia(i, j) * 255;
         end
    end

    copia = copia(1 + raggio_I : rows - raggio_I, 1 + raggio_I : cols - raggio_I);

    massimo = max(copia(:));
    copia = copia / massimo;
    % figure, imshow(copia);

    pad = pad(1 + raggio_I : rows - raggio_I, 1 + raggio_I : cols - raggio_I);
    % PAD DIOCANE
    %pad = im2double(pad);

    %out = cat(3, H, S, copia);

    %out = hsv2rgb(out);
    %subplot(1, 2, 2), imshow(copia), title('Modificata');
    out = copia;
end
