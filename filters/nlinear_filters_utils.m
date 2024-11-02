classdef nlinear_filters_utils
    methods (Static)
        function fln_img = median_filter2D(img, mask_size, varargin)
            %%--- Argumentos da função----------------------------------------
            %img: a matriz da imagem que se deseja aplicar o filtro não linear
            %mask_size: tamanho da máscara de convolução 
            %varargin: variável opcional que define o tratamento das bordas
            %retorna: a imagem com filtro não linear para a máscara de tamanho "mask_size"
            %-----------------------------------------------------------------
            %Acessa o argumento opcional para definir o tratamento da borda
            if ~isempty(varargin)
                borda = varargin{1}; %define borda como o argumento passado na função
            else
                borda = 'padding'; %por defeito o tratamento é zero padding então
            end
            
            if strcmp(borda, 'padding')
                img = double(img); %converte a imagem para double para operação de filtragem
                [img_zp, pad] = nlinear_filters_utils.zero_padding(img, zeros(mask_size)); %nova matriz que contém as bordas tratadas com zero padding
    
                %operação do filtro mediana
                fln_img = zeros(size(img)); %a matriz final deve ter o tamanho da original
                %pixels (linha) da imagem original que serão tratados
                pxl_i = size(img,1); %linha
                pxl_j = size(img,2); %coluna
                for i = 1:pxl_i
                    for j = 1:pxl_j
                        %pixels na matriz com zero padding que contemplam a operação atual
                        sub_idx_i = i:i+2*pad; %linha
                        sub_idx_j = j:j+2*pad; %coluna
                        sub_mtx = img_zp(sub_idx_i,sub_idx_j); %sub-matriz com os elementos que contemplam a operação atual
                        fln_img(i,j) = median(sub_mtx(:)); %para [i,j] o pixel é a mediana da sub-matriz
                    end
                end
            
                fln_img = uint8(fln_img); %converte a matrix para uint8 para facilitar plot
            
            else
                error('[nlinear_filters_utils.median_filter2D] Operações sem zero padding ainda não estão disponíveis')
            end
        end

        function [img_zp, pad] = zero_padding(img, mask)
            %%--- Argumentos da função----------------------------------------
            %img: a matriz da imagem que se deseja aplicar o zero padding
            %mask: a máscara de convolução para definir como será o padding
            %retorna: a imagem original com zero padding dada a dimensão da máscara e a constante de padding
            %-----------------------------------------------------------------
            pad = (size(mask,1)-1)/2; %constante para aumentar o tamanho da matriz original 
            pad_size = size(img) + 2*pad; %novo tamanho para a matriz considerando o zero padding
            img_zp = zeros(pad_size); %matriz com o zero padding na imagem original
            Y_valid = 1+pad:size(img_zp,1)-pad; %índices válidos em Y (linha) que contém a imagem
            X_valid = 1+pad:size(img_zp,2)-pad; %índices válidos em X (coluna) que contém a imagem
            img_zp(Y_valid, X_valid) = img; %define os pixels validos como a imagem original
        end
    end
end