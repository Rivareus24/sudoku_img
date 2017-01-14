%figure('units','normalized','outerposition',[0 0 1 1])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% OUTPUT??????????????????????????%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%% Pulisco tutto
close all
clear all   % da togliere
clc

% 7,

for Numero_Immagine = 19 : 19
%%%%%%%%%%%%%%%%%%%% Scelgo l'immagine dal dataset immagini/
path = string('immagini/');
img_Number = Numero_Immagine;
extension = ('.jpg');
disp(['Immagine Numero: ', num2str(img_Number), char(10)]);


%%%%%%%%%%%%%%%%%%%% Number dell'immagine base
Img = struct();


%%%%%%%%%%%%%%%%%%%% Leggo l'immagine
Img = Add_Property(Img, 'HD', Read_Img(path, img_Number, extension));

%%%%%%%%%%%%%%%%%%%% Salvo le dimensioni dell'immagine base
[img_rows, img_cols, ~] = size(Img.HD);
Img = Add_Property(Img, 'rows_HD', img_rows);
Img = Add_Property(Img, 'cols_HD', img_cols);
%Show_Img(Img.HD, 'Original');

%%%%%%%%%%%%%%%%%%%% La scalo a 1000x1000 more or less
[img_downScaled, ratio] = Down_Scale(Img.HD);
Img = Add_Property(Img, 'down_scaled', img_downScaled);
Img = Add_Property(Img, 'ratio', ratio);
%%%%%%%%%%%%%%%%%%%% Salvo le dimensioni dell'immagine Down_Scaled
[img_rows, img_cols, ~] = size(img_downScaled);
Img = Add_Property(Img, 'rows', img_rows);
Img = Add_Property(Img, 'cols', img_cols);


clear img_rows
clear img_cols
clear img_downScaled
clear img_HD
clear path
clear img_Number
clear extension


%%%%%%%%%%%%%%%%%%%% Miglioramento dell'immagine
%Img.down_scaled = LocalGammaCorrection(Img.down_scaled);
img = Img.down_scaled;
Img.down_scaled = Enhancement(Img.down_scaled);
%Show_Img(Img.down_scaled, 'Gamma');


%%%%%%%%%%%%%%%%%%%% Definisco gli edge
Img.down_scaled = Edge_Finder(Img.down_scaled);
%Show_Img(Img.down_scaled, 'Edge');


%%%%%%%%%%%%%%%%%%%% Threshold      ?????? threshold&edge functions
Img.down_scaled = imclose(Img.down_scaled, ones(6));
Img.down_scaled = Threshold(Img.down_scaled);
%Show_Img(Img.down_scaled, 'BW');


%%%%%%%%%%%%%%%%%%%% Seleziono l'indice della componente connessa
%%%%%%%%%%%%%%%%%%%% Posso girare l'immagine delle labels?
[Img, sudoku_index] = Sudoku_Seeking(Img, Img.down_scaled);


%%%%%%%%%%%%%%%%%%%% Number della BoundingBox del Sudoku
Sudoku = struct( ...
    'CI', Img.properties(sudoku_index).ConvexImage);
%Show_Img(Sudoku.CI, 'ConvexImage Sudoku');


%%%%%%%%%%%%%%%%%%%% Calcolo l'angolo di rotazione per riportare
%%%%%%%%%%%%%%%%%%%% il sudoku perdendicolare alla BoundingBox
angle = Sudoku_Rotation(Sudoku.CI);


%%%%%%%%%%%%%%%%%%%% Ruoto il Sudoku dell'angolazione corretta
%figure, imagesc(Img.labels);
Img.labels = imrotate(Img.labels, angle);
%figure, imagesc(Img.labels);
img = imrotate(img, angle, 'bilinear');
%Show_Img(img, 'des');

porcoDemonio = regionprops(Img.labels, 'BoundingBox');

b = round(porcoDemonio(sudoku_index).BoundingBox);
img2 = imcrop(img, [b(1) b(2) b(3) b(4)]);
%figure, imshow(img2);
img2 = rgb2gray(img2);
%figure, imshow(img2);

img2 = sauvola(img2, [15 15], otsuthresh(imhist(img2)));
figure, imshow(img2);
img2 = imopen(img2, ones(9));   % WARNING
figure, imshow(img2);

Number = struct();
[labels, labels_number] = bwlabel(img2);
[Number(:).labels] = labels;
[Number(:).labels_number] = labels_number;
figure, imagesc(Number.labels), title('Labelling'), axis image;
[Number(:).properties] = regionprops(Number.labels, ...
    'EulerNumber', 'Area', 'ConvexImage', 'BoundingBox');

% togliere da s1 e s2 un pezzo
[s1, s2] = size(img2);
area_cella = s1 * s2 / 81;
kkk = 0;
for index = 1 : labels_number
    if abs(Number.properties(index).Area - 0) < 7000
        if abs(Number.properties(index).Area - 0) > 3000
            kkk = kkk + 1;

        end
    end
end


disp(['The End', char(10)]);
end
