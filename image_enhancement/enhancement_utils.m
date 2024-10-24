classdef enhancement_utils
    methods (Static)
        function neg = apply_negative(image)
            image = im2uint8(image); %converte para uint8 para garatir pixels entre 0 e 255
            idx = double(image) + 1; %converte para double e adiciona 1 para indexar 
            T = uint8(255:-1:0); %função de transformação para cada pixel
            neg = T(idx); %aplica a transformação para cada pixel via indexação
            neg = im2uint8(neg); %converte para uint8
        end

        function im_log = apply_log(image, c)
            image = im2uint8(image); %converte para uint8 para garatir pixels entre 0 e 255
            T_log = c*log(1:1000); %função do logarítmo neperiano mutiplicada por c
            im_log = T_log(image+1); %usa os valores da imagem como índices
            im_log = im2uint8(im_log); %converte para uint8
        end

        function im_gamma = apply_gamma(image, gamma, c)
            image = im2double(image); %converte para double para garatir ponto flutuante
            im_gamma = c*(image.^gamma); %s = c.r^(gamma)
            im_gamma = im2uint8(im_gamma); %converte para uint8 
        end
    end
end
