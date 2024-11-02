classdef pixel_neighborhood_utils
    methods (Static)
        function dist_map = pixel_dist(image, hotspot, metric, normalize)
            %%--- Argumentos da função----------------------------------------
            %image: a imagem que se deseja aplicar o mapa de distâncias
            %hotspot: de qual pixel serão computadas as distâncias
            %metric: qual métrica será usada para calcular as distâncias
            %normalize: flag para aplicar ou não autocontraste no mapa de distâncias
            %retorna: o mapa das distâncias euclidianas entre hotspot e todos os pixels da imagem
            %-----------------------------------------------------------------
            image = double(image);
            rows = 1:size(image,1); %índices das linhas
            cols = 1:size(image,2); %índices das colunas
            [s,t] = meshgrid(rows, cols); %todas as combinações de coordenadas

            if strcmp(metric, 'euclidean')
                dist_map = sqrt((hotspot(1)-s).^2 + (hotspot(2)-t).^2); %distancia euclidiana entre (hx, hy) e cada ponto
            elseif strcmp(metric, 'cityblock')
                dist_map = abs(hotspot(1)-s) + abs(hotspot(2)-t);  %distancia city-block entre (hx, hy) e cada ponto
            elseif strcmp(metric, 'chessboard')
                dist_map = max(abs(hotspot(1)-s), abs(hotspot(2)-t));  %distancia chessboard entre (hx, hy) e cada ponto
            else
                error('[neighborhood_utils.pixel_dist] Métrica ' + string(metric) + ' não disponível!')
            end

            if normalize
                dist_map = pixel_neighborhood_utils.autocontrast(dist_map); %autocontraste para visualizar 
            end
        end

        function norm = autocontrast(image)
            %%--- Argumentos da função----------------------------------------
            %image: a imagem que se deseja aplicar o autocontraste
            %retorna: a imagem de entrada "normalizada"
            %-----------------------------------------------------------------
            image = double(image); 
            num = image - min(image(:)); %subtrai pelo mínimo para o menor pixel ser igual a zero
            den = abs(max(image(:))-min(image(:))); %divide pela diferença de maneira que o máximo seja igual a 1
            norm = num./den; %aplica o autocontraste I' = [I-min(I)]/[abs(max(I)-min(I))]
        end

    end
end