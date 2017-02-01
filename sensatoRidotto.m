%figure('units','normalized','outerposition',[0 0 1 1])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% OUTPUT??????????????????????????%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%% Pulisco tutto
close all
clear all   % da togliere
clc

% 7,

for Numero_Immagine = 31 : 31
%%%%%%%%%%%%%%%%%%%% Scelgo l'immagine dal dataset immagini/
path = string('immagini/');
img_Cells = Numero_Immagine;
extension = ('.jpg');
disp(['Immagine Numero: ', num2str(img_Cells), char(10)]);


%%%%%%%%%%%%%%%%%%%% Cells dell'immagine base
Img = struct();


%%%%%%%%%%%%%%%%%%%% Leggo l'immagine
Img = Add_Property(Img, 'HD', Read_Img(path, img_Cells, extension));

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
clear img_Cells
clear extension


%%%%%%%%%%%%%%%%%%%% Miglioramento dell'immagine
%Img.down_scaled = LocalGammaCorrection(Img.down_scaled);
img_down_scaled_RGB = Img.down_scaled;
Img.down_scaled = Enhancement(Img.down_scaled);
% img_copy .^ media
%Show_Img(Img.down_scaled, 'Gamma');


%%%%%%%%%%%%%%%%%%%% Definisco gli edge
%Img.down_scaled = Edge_Finder(Img.down_scaled);
Img.down_scaled = edge(Img.down_scaled, 'canny');
Img.down_scaled = imclose(Img.down_scaled, ones(5));
base_Canny = Img.down_scaled;
%Show_Img(Img.down_scaled, 'CANNY');

%%%%%%%%%%%%%%%%%%%% Threshold      ?????? threshold&edge functions
%Img.down_scaled = imclose(Img.down_scaled, ones(6));
%Img.down_scaled = Threshold(Img.down_scaled);
%Show_Img(Img.down_scaled, 'BW');


%%%%%%%%%%%%%%%%%%%% Seleziono l'indice della componente connessa
%%%%%%%%%%%%%%%%%%%% Posso girare l'immagine delle labels?
[Img, sudoku_index] = Sudoku_Seeking(Img, Img.down_scaled);


%%%%%%%%%%%%%%%%%%%% Cells della BoundingBox del Sudoku
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
base_Canny_dritta = imrotate(base_Canny, angle, 'bilinear');
%img_down_scaled_RGB_dritta = imrotate(img_down_scaled_RGB, angle, 'bilinear');
%Show_Img(img, 'des');

[Sudoku(:).properties] = regionprops(Img.labels, 'BoundingBox');

b = round(Sudoku.properties(sudoku_index).BoundingBox);
sudoku_face = imcrop(base_Canny_dritta, [b(1) b(2) b(3) b(4)]);
%sudoku_face_temp = sudoku_face;         % XXXXXXXXXXXXXXXXXXXXXXXXXXXX
%figure, imshow(sudoku_face);
%sudoku_face = rgb2gray(sudoku_face);
%figure, imshow(img2);

%sudoku_face = sauvola(sudoku_face, [15 15], otsuthresh(imhist(sudoku_face)));
%figure, imshow(img2);
%sudoku_face = imopen(sudoku_face, ones(9));   % WARNING
%figure, imshow(1 - sudoku_face);

[labels, labels_Cells] = bwlabel(sudoku_face);
%figure, imagesc(labels), title('QUADRATO'), axis image;
prop = regionprops(labels, ...
    'EulerNumber', 'Area', 'ConvexArea', 'BoundingBox', 'Centroid');

Area = -1;
for i = 1 : labels_Cells
    if prop(i).EulerNumber < -50
            Area = prop(i).ConvexArea;
        break
    end
end
Area_Cell = Area / 81;

Cells = struct();
[labels, labels_Cells] = bwlabel(1 - sudoku_face);
[Cells(:).labels] = labels;
[Cells(:).labels_Cells] = labels_Cells;
%figure, imagesc(Cells.labels), title('CELLE'), axis image;
[Cells(:).properties] = regionprops(Cells.labels, ...
    'Eccentricity', 'ConvexArea', 'BoundingBox', 'Centroid');



% Inserisco l'indice delle 81 celle nell'array Cells
% togliere da s1 e s2 un pezzo
[s1, s2] = size(sudoku_face);

[Cells(:).indexes] = [];
for index = 1 : labels_Cells
    if abs(Area_Cell - Cells.properties(index).ConvexArea) < (Area_Cell * 0.3) ...
            &&  Cells.properties(index).Eccentricity < 0.7 % quadrato circa 0.2
       Cells.indexes = [Cells.indexes, index];
    end
end

'Errore!! Non ha trovato tutte le celle' % CONTROLLO

Nlist = cell(1, size(Cells.indexes, 2));

tuned = load('tuned.mat');

%for index = 1 : size(Cells.indexes, 2)
for index = 11 : 11
    BB = Cells.properties(Cells.indexes(index)).BoundingBox;
    centroide = Cells.properties(Cells.indexes(index)).Centroid;
    cut = ceil(0.1 * min([BB(3),BB(4)]));
    image = imcrop(sudoku_face, ...
        [BB(1) + cut BB(2) + cut BB(3) - 2 * cut BB(4) - 2 * cut]);
        %figure, imshow(image);  % 9 bianco
    booo = caricanumero(255 * image);
    Nactual = booo{1};
    e = booo{2};
        %figure, imshow(Nactual);
    somma = sum(Nactual(:));
    if somma > 1
        x = ones(28)*255;
        r = tuned(x(:));
        %r = tuned(Nactual(:));
        Nactual = Nvalue(r, e);
    else
        Nactual = 0;
    end
    Nlist{index} = [Nactual; centroide(1); centroide(2)];
end
Nlist = cell2mat(Nlist);

%%%%%%%%%%%%%%%%%%%% ORDINO I VALORI (VISTO CHE IL LABELING FA SCHIFO)
% NON SO PENSARE

NX = transpose(sortrows(Nlist', 2));
NY = transpose(sortrows(Nlist', 3));
NXV = NX(1,:);
NYV = NY(1,:);
k = 1;
res = cell(1, 9);
for i = 1 : 9 : 81
    res{k} = sortrows(NX(i : i + 9), 3);
    k = k + 1;
end

%res = cell2mat(res);
%res = reshape(res ,[9 9]);


disp(['The End', char(10)]);
end
