%figure('units','normalized','outerposition',[0 0 1 1])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% OUTPUT??????????????????????????%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%% Pulisco tutto
close all
clear all   % da togliere
clc
% 31, 29, 15, 13, 1, 2,
x = 15;
for Numero_Immagine = x : x
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
img_down_scaled_RGB = Img.down_scaled;
Img.down_scaled = Enhancement(Img.down_scaled);


%%%%%%%%%%%%%%%%%%%% Salvo l'immagine che cropperò e userò
%%%%%%%%%%%%%%%%%%%% come base per le prossime labelling
immagine_base = Img.down_scaled;


%%%%%%%%%%%%%%%%%%%% Definisco gli edge
Img.down_scaled = Edge_Finder(Img.down_scaled);


%%%%%%%%%%%%%%%%%%%% Seleziono l'indice della componente connessa
[Img, sudoku_index] = Sudoku_Seeking(Img, Img.down_scaled);


%%%%%%%%%%%%%%%%%%%% Cells della BoundingBox del Sudoku
Sudoku = struct( ...
    'CI', Img.properties(sudoku_index).ConvexImage);
%Show_Img(Sudoku.CI, 'ConvexImage Sudoku');


%%%%%%%%%%%%%%%%%%%% Calcolo l'angolo di rotazione per riportare
%%%%%%%%%%%%%%%%%%%% il sudoku perdendicolare alla BoundingBox
angle = Sudoku_Rotation(Sudoku.CI);


%%%%%%%%%%%%%%%%%%%% Ruoto il Sudoku dell'angolazione corretta
Img.labels = imrotate(Img.labels, angle);
%figure, imagesc(Img.labels);
immagine_base = imrotate(immagine_base, angle, 'bilinear');


[Sudoku(:).properties] = regionprops(Img.labels, 'BoundingBox');

b = round(Sudoku.properties(sudoku_index).BoundingBox);
img22 = imcrop(immagine_base, [b(1) b(2) b(3) b(4)]);


copia = img22;
img22 = edge(img22, 'canny', [0.1, 0.3]);
[sudoku_x sudoku_y] = size(img22);
img22 = imdilate(img22, ones(5));


%%%%%%%%%%%%%%%%%%%% TRASFORMATA HOUGH
angoli = [0, 90];
errore = 10;
theta_ortogonale = [-90 : 1 : -90 + errore];
theta_ortogonale = [theta_ortogonale, 0 - errore : 1 : 0 + errore];
theta_ortogonale = [theta_ortogonale, 90 - errore : 1 : 89];
[H, theta, rho] = hough(img22, 'theta', theta_ortogonale);

%{
figure
imshow(imadjust(mat2gray(H)),[],...
    'XData', theta,...
    'YData', rho,...
    'InitialMagnification','fit');
    xlabel('\theta (degrees)')
    ylabel('\rho')
    axis on
    axis normal
    hold on
    colormap(hot)
%}
    P = houghpeaks(H, 20,'threshold', ceil(0.3 * max(H(:))));

%{
    x = theta(P(:, 2));
    y = rho(P(:, 1));
    plot(x,y,'s','color','black')
%}

    dimensione_min = min(sudoku_x, sudoku_y);
    lines = houghlines(img22, theta, rho, P, ...
        'FillGap', dimensione_min * 0.3,'MinLength', dimensione_min * 0.8);

    figure, imshow(copia), hold on
    %max_len = 0;
for k = 1 : length(lines)
    xy = [lines(k).point1; lines(k).point2];
    plot(xy(:, 1), xy(:, 2), 'LineWidth', 2, 'Color','green');

    % Plot of lines
    %   beginnings (red)
    %   and ends (blue)
    plot(xy(1, 1), xy(1, 2), 'x', 'LineWidth', 2, 'Color', 'red');
    plot(xy(2, 1), xy(2, 2), 'x', 'LineWidth', 2, 'Color', 'blue');

%{
    % Determine the endpoints of the longest line segment
    len = norm(lines(k).point1 - lines(k).point2);
    if ( len > max_len)
        max_len = len;
        xy_long = xy;
    end
%}
end

%plot(xy_long(:, 1), xy_long(:, 2), 'LineWidth', 2, 'Color', 'red');

%{

%sudoku_face = sauvola(sudoku_face, [15 15], otsuthresh(imhist(sudoku_face)));
%figure, imshow(img2);
%sudoku_face = imopen(sudoku_face, ones(9));   % WARNING
%figure, imshow(1 - sudoku_face);

[labels, labels_Cells] = bwlabel(img22);
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
%figure, imshow(1 - sudoku_face), title('sudoku_face');
[labels, labels_Cells] = bwlabel(1 - sudoku_face);
[Cells(:).labels] = labels;
[Cells(:).labels_Cells] = labels_Cells;
%figure, imagesc(Cells.labels), title('CELLE'), axis image;
[Cells(:).properties] = regionprops(Cells.labels, ...
    'Eccentricity', 'ConvexArea', 'BoundingBox', 'Centroid');


[Cells(:).indexes] = [];
for index = 1 : labels_Cells
    if abs(Area_Cell - Cells.properties(index).ConvexArea) < (Area_Cell * 0.4) ...
            &&  Cells.properties(index).Eccentricity < 0.7 % quadrato circa 0.2
       Cells.indexes = [Cells.indexes, index];
    end
end

%'Errore!! Non ha trovato tutte le celle' % CONTROLLO

Nlist = cell(1, size(Cells.indexes, 2));
%}

'Trovo le celle con le coordinate (rho)'


if length(lines) ~= 20
    disp(['Ha trovato ', num2str(length(lines)), '/20 linee']);
end

oriz_lines = [];
vert_lines = [];
for i = 1 to length(lines)
    if abs(lines.theta(i)) > 50
        oriz_lines = [oriz_lines, lines.theta(i)];
    else
        vert_lines = [vert_lines, lines.theta(i)];
    end
end

%%%%%%%%%%%%%% ordino i due array

%%%%%%%%%%%%%% doppio for 10 x 10
%%%%%%%%%%%%%% croppa la cella con i valori dei due array
%%%%%%%%%%%%%% creo l'array di celle / chiamo direttamente la NN nel for

%%%%%%%%%%%%%%%%%%%% Carico la rete neurale
load('tuned.mat');


for index = 1 : 81
%for index = 1 : 1
    BB = Cells.properties(Cells.indexes(index)).BoundingBox;
    centroide = Cells.properties(Cells.indexes(index)).Centroid;
    cut = ceil(0.1 * min([BB(3), BB(4)]));
    image = imcrop(sudoku_face, ...
        [BB(1) + cut BB(2) + cut BB(3) - 2 * cut BB(4) - 2 * cut]);
        %figure, imshow(image);
    booo = caricanumero(255 * image);
    Nactual = booo{1};
    e = booo{2};
        %figure, imshow(Nactual);
    somma = sum(Nactual(:));
    if somma > 1
        r = tunedNet(Nactual(:));
        Nactual = Nvalue(r, e);
    else
        Nactual = 0;
    end
    Nlist{index} = [Nactual; centroide(1); centroide(2)];
end
Nlist = cell2mat(Nlist);

%%%%%%%%%%%%%%%%%%%% ORDINO I VALORI (VISTO CHE IL LABELING FA SCHIFO)
% NON SO PENSARE

stringa_numeri = ordinaCentroidi(Nlist);

sudoku = reshape(stringa_numeri, [9 9]);

sudoku = sudoku'

disp(['The End', char(10)]);
end
