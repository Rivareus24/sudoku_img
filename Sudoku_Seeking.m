function [Struct, sudoku_index] = Sudoku_Seekin(Struct, img)


    [labels, labels_number] = bwlabel(img);
    [Struct(:).labels] = labels;
    [Struct(:).labels_number] = labels_number;
    %figure, imagesc(Struct.labels), title('Labelling'), axis image;
    [Struct(:).properties] = regionprops(Struct.labels, ...
        'EulerNumber', 'Area', 'ConvexImage', 'BoundingBox');


    listOf_index = [];
    listOf_Euler = [];
    listOf_Area  = [];


    for i = 1 : Struct.labels_number
        if Struct.properties(i).EulerNumber < -50 && ...
            Struct.properties(i).EulerNumber > -150
            listOf_index = [listOf_index, i];
            %listOf_Euler = [listOf_Euler, Struct.properties(i).EulerNumber];
            %listOf_Area  = [listOf_Area, Struct.properties(i).Area];
        end
    end

    area_max = -1;
    for i = 1 : size(listOf_index, 2)
        if Struct.properties(listOf_index(i)).Area > area_max
            area_max = Struct.properties(listOf_index(i)).Area;
            sudoku_index = listOf_index(i);
        end
    end

    %max_euler_number = max(abs(listOf_Euler));
    %max_area = max(listOf_Area);


    %index_max_euler = find(abs(listOf_Euler) == max_euler_number);
    %index_max_area = find(listOf_Area == max_area);


    %if index_max_area == index_max_euler
    %    sudoku_index = listOf_index(index_max_euler);
    %else

        %disp(['Indici di area massima e di eulero'...
        %    'massimo DIVERSI', char(10)]);
        %% Chiamare l'altro metodo

    %end


end
