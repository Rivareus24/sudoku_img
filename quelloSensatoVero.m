%figure('units','normalized','outerposition',[0 0 1 1])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% OUTPUT??????????????????????????%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%% Pulisco tutto
close all
clear all   % da togliere
clc

% 7,

for Numero_Immagine = 29 : 29
%%%%%%%%%%%%%%%%%%%% Scelgo l'immagine dal dataset immagini/
path = string('immagini/');
img_Number = Numero_Immagine;
extension = ('.jpg');
disp(['Immagine Numero: ', num2str(img_Number), char(10)]);


%%%%%%%%%%%%%%%%%%%% Struct dell'immagine base
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
Img.down_scaled = Enhancement(Img.down_scaled);
Show_Img(Img.down_scaled, 'Gamma');

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


%%%%%%%%%%%%%%%%%%%% Struct della BoundingBox del Sudoku
Sudoku = struct( ...
    'CI', Img.properties(sudoku_index).ConvexImage, ...
    'BB', Img.properties(sudoku_index).BoundingBox);
Show_Img(Sudoku.CI, 'ConvexImage Sudoku');

clear sudoku_index


[Sudoku(:).rows Sudoku(:).cols] = size(Sudoku.CI); % forse npon serve


%%%%%%%%%%%%%%%%%%%% Crop-po nell'img_HD un rettangolo più
%%%%%%%%%%%%%%%%%%%% grande della BB del Sudoku trovato
padding = 10 * Img.ratio;   %%%%% WARNING
Sudoku.BB = Sudoku.BB * Img.ratio;
% rendere Img.HD 1000x1000 e poi forse la miglioriamo
[Sudoku(:).Img] = ...
imcrop(Img.HD, [ ...
    Sudoku.BB(1) - padding ...
    Sudoku.BB(2) - padding ...
    Sudoku.BB(3) + padding * 2 ...
    Sudoku.BB(4) + padding * 2]);
Show_Img(Sudoku.Img, 'Sudoku');


clear padding


%%%%%%%%%%%%%%%%%%%% Calcolo l'angolo di rotazione per riportare
%%%%%%%%%%%%%%%%%%%% il sudoku perdendicolare alla BoundingBox
angle = Sudoku_Rotation(Sudoku.CI);


%%%%%%%%%%%%%%%%%%%% Ruoto il Sudoku dell'angolazione corretta
Sudoku.Img = imrotate(Sudoku.Img, angle, 'bilinear');
Show_Img(Sudoku.Img, 'Sudoku Dritto');

 = regionprops(Sudoku.Img, ...
    'EulerNumber', 'Area', 'ConvexImage', 'BoundingBox');


%%%%%%%%%%%%%%%%%%%% Salvo l'immagine da croppare
% non serve
Sudoku = Add_Property(Sudoku, 'RGB', Sudoku.Img);


%%%%%%%%%%%%%%%%%%%% Miglioramento dell'immagine
% Input RGB
% Output
% Sudoku.Img = Enhancement(Sudoku.Img);   % non serve
% If (condition)
% Sudoku.Img = LocalGammaCorrection(Sudoku.Img);
%Sudoku.Img = rgb2gray(Sudoku.Img);


%%%%%%%%%%%%%%%%%%%% Definisco gli edge
%Sudoku.Img = Edge_Finder(Sudoku.Img);   % non serve
%Show_Img(Img.down_scaled, 'Edge');


%%%%%%%%%%%%%%%%%%%% Threshold      ?????? threshhold&edge functions
%%%%%%%%%%%%%%%%%%%% Dinamico (ombre solo mezzo sudoku)
%%%%%%%%%%%%%%%%%%%% Media e varianza
Sudoku.Img = Threshold(Sudoku.Img);
%Show_Img(Img.down_scaled, 'BW');


%%%%%%%%%%%%%%%%%%%% Seleziono l'indice della componente connessa
[Sudoku, sudoku_index] = Sudoku_Seeking(Sudoku, Sudoku.Img);


%%%%%%%%%%%%%%%%%%%% Struct della BoundingBox del Sudoku
Sudoku = Add_Property(Sudoku, 'CI_Final', ...
    Sudoku.properties(sudoku_index).ConvexImage);
Sudoku = Add_Property(Sudoku, 'BB_Final', ...
    Sudoku.properties(sudoku_index).BoundingBox);


%%%%%%%%%%%%%%%%%%%% Croppo il Sudoku dritto
padding = -5 * ratio;   % WARNING
Sudoku.Img = imcrop(Sudoku.RGB, [ ...
    Sudoku.BB_Final(1) - padding ...
    Sudoku.BB_Final(2) - padding...
    Sudoku.BB_Final(3) + padding * 2 ...
    Sudoku.BB_Final(4) + padding * 2]);
%Show_Img(Sudoku.Img, strcat('Final - ', num2str(Numero_Immagine)));


%%%%%%%%%%%%%%%%%%%% Miglioramento dell'immagine
%Sudoku.Img = Enhancement(Sudoku.Img);
Sudoku.Img = rgb2gray(Sudoku.Img);
Show_Img(Sudoku.Img, 'Grayscaled');

%%%%%%%%%%%%%%%%%%%% Definisco gli edge
%Sudoku.Img = Edge_Finder(Sudoku.Img);
%Show_Img(Sudoku.Img, 'Edge');


%%%%%%%%%%%%%%%%%%%% Threshold      ?????? threshhold&edge functions
%Sudoku.Img = Threshold(Sudoku.Img);
%thresh = graythresh(Sudoku.Img) * 255;
%thresh = 91;
%figure, plot(imhist(Sudoku.Img));
%Sudoku.Img(Sudoku.Img > thresh) = 255;
%Sudoku.Img(Sudoku.Img <= thresh) = 0;

%Show_Img(Sudoku.Img, 'BW');


%%%%%%%%%%%%%%%%%%%% Cerco le cifre
%Numbers = struct();
%[labels, labels_number] = bwlabel(Sudoku.Img);
%[Numbers(:).labels] = labels;
%[Numbers(:).labels_number] = labels_number;
%figure, imagesc(Numbers.labels), title('Labelling'), axis image;
%[Numbers(:).properties] = regionprops(Numbers.labels, ...
%    'EulerNumber', 'Area', 'ConvexImage', 'BoundingBox');



disp(['The End', char(10)]);
end
