classdef neighborhood_utils
    methods (Static)
        function dist_map = euclidean(image, px, py)
            image = double(image);
            rows = 1:size(image,1); %índices das linhas
            cols = 1:size(image,2); %índices das colunas
            [s,t] = meshgrid(rows, cols); %todas as combinações de coordenadas
            dist_map = sqrt((px-s).^2 + (py-t).^2); %distancia euclidiana entre (px, py) e cada ponto
            dist_map = mat2gray(dist_map); %autocontraste para visualizar 
        end
        
        function dist_map = city_block(image, px, py)
            image = double(image);
            rows = 1:size(image,1); %índices das linhas
            cols = 1:size(image,2); %índices das colunas
            [s,t] = meshgrid(rows, cols); %todas as combinações de coordenadas
            dist_map = abs(px-s) + abs(py-t);  %distancia city-block entre (px, py) e cada ponto
            dist_map = mat2gray(dist_map); %autocontraste para visualizar 
        end
    end
end