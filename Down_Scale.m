function [img_downScaled, ratio] = Down_Scale(img)

    [rows, cols, channels] = size(img);

    ratio = round(min(cols, rows) / 1000);

    img_downScaled = imresize(img, [round(rows / ratio) round(cols / ratio)]);

end
