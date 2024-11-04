classdef edge_preserving_filters_utils
    methods (Static)
        function mask = generate_mask(mask_size, type, varargin)
            %%--- Argumentos da função----------------------------------------
            %mask_size: o tamanho da máscara de convolução em cada dimensão
            %type: qual é o tipo do filtro espacial
            %varargin: argumento opcional que recebe o sigma para o filtro espacial gaussiano
            %retorna: a máscara de convolução para o filtro de tamanho igual a "mask_size" do tipo igual ao "tipo"
            %-----------------------------------------------------------------
            if strcmp(type, 'box')
                mask = ones(mask_size); %matrix com size igual ao tamanho completo de 1s
                mask = mask./(numel(mask)); %o valor de cada elemento da máscara da média é 1/(tam(1)*tam(2))
            elseif strcmp(type, 'box_x')
                mask = ones(1, mask_size(1)); %vetor com size igual ao tamanho de colunas
                mask = mask./mask_size(1); %o valor de cada elemento da máscara é 1/size_x
            elseif strcmp(type, 'box_y')
                mask = ones(mask_size(1), 1); %vetor com size igual ao tamanho de colunas
                mask = mask./mask_size(1); %o valor de cada elemento da máscara é 1/size_x
            elseif strcmp(type, 'gaussian')
                %Acessa o argumento opcional para definir o valor de sigma
                if ~isempty(varargin)
                    sigma = varargin{1}; %define sigma como o argumento passado na função
                else
                    error('[atv04_utils.mascara_conv] Valor de sigma deve ser passado como argumento!')
                end
                
                %Gaussiana
                [X,Y] = meshgrid(-floor(mask_size(1)/2):floor(mask_size(1)/2), -floor(mask_size(2)/2):floor(mask_size(2)/2)); %define todos os pontos X e Y que compõem a matriz do kernel gaussiano 
                sigma_sqr = double(sigma^2); %eleva o sigma ao quadrado para facilitar o cálculo do valor da gaussiana
                mask = (1/(2*pi*sigma_sqr))*exp(-(X.^2+Y.^2)/(2*sigma_sqr)); %equação da gaussiana
                mask = mask/sum(mask(:)); %normaliza em relação a soma para garantir que a soma da matriz é igual a 1
                %fonte: https://www.mathworks.com/help/images/ref/fspecial.html
            
            elseif strcmp(type, 'laplacian')
                mask = [0 -1  0;
                       -1  4 -1;
                        0 -1  0];
            elseif strcmp(type, 'composite laplacian')
                mask = [0 -1  0;
                       -1  5 -1;
                        0 -1  0];
            elseif strcmp(type, 'composite laplacian variant')
                mask = [-1 -1 -1;
                        -1  9 -1;
                        -1 -1 -1];
            else
                error('[linear_filters_utils.generate_mask] Tipo de filtro ' + string(tipo) + ' não aceito para gerar a máscara')
            end
        end

        function conv_img = convolve2D(img, mask, varargin)
            %%--- Argumentos da função----------------------------------------
            %img: a matriz da imagem que se deseja aplicar a convolução com a máscara
            %mask: a máscara de convolução (matriz quadrada)
            %varargin: variável opcional que define o tratamento das bordas
            %retorna: a matriz de convolução entre a imagem e a máscara
            %-----------------------------------------------------------------
            %Acessa o argumento opcional para definir o tratamento da borda
            if ~isempty(varargin)
                borda = varargin{1}; %define borda como o argumento passado na função
            else
                borda = 'padding'; %por defeito o tratamento é zero padding então
            end

            if strcmp(borda, 'padding')
                img = double(img); %converte a imagem para double para operação de multiplicação
                [img_zp, pad] = linear_filters_utils.zero_padding(img, size(mask,1)); %nova matriz que contém as bordas tratadas com zero padding
                mask = fliplr(flipud(mask)); %"flip" na máscara pq é uma operação de convolução e não correlação
                %operação da convolução
                conv_img = zeros(size(img)); %a matriz da convulação deve ter o tamanho da original
                %pixels da imagem original que serão tratados
                pxl_i = size(img,1); %linha
                pxl_j = size(img,2); %coluna
                for i = 1:pxl_i
                    for j = 1:pxl_j
                        %pixels na matriz com zero padding que contemplam a operação atual
                        sub_idx_i = i:i+2*pad; %linha
                        sub_idx_j = j:j+2*pad; %coluna
                        sub_mtx = img_zp(sub_idx_i,sub_idx_j).*mask; %produtos por elemento entre a submatriz e a máscara
                        conv_img(i,j) = sum(sub_mtx(:)); %para [i,j] o pixel é a soma dos produtos
                    end
                end

            else
                error('[linear_filters_utils.convolve2D] Operações sem zero padding ainda não estão disponíveis')
            end
         end

         function var_img = variance2D(img, mask_size, varargin)
            %%--- Argumentos da função----------------------------------------
            %img: a matriz da imagem que se deseja aplicar a variância
            %mask_size: tamanho da máscara da variância (matriz quadrada)
            %varargin: variável opcional que define o tratamento das bordas
            %retorna: a matriz de variância entre a imagem e a máscara
            %-----------------------------------------------------------------
            %Acessa o argumento opcional para definir o tratamento da borda
            if ~isempty(varargin)
                borda = varargin{1}; %define borda como o argumento passado na função
            else
                borda = 'padding'; %por defeito o tratamento é zero padding então
            end

            if strcmp(borda, 'padding')
                img = double(img); %converte a imagem para double para operação de multiplicação
                [img_zp, pad] = linear_filters_utils.zero_padding(img, mask_size(1)); %nova matriz que contém as bordas tratadas com zero padding

                %operação da variância
                var_img = zeros(size(img)); %a matriz da convulação deve ter o tamanho da original
                %pixels da imagem original que serão tratados
                pxl_i = size(img,1); %linha
                pxl_j = size(img,2); %coluna
                for i = 1:pxl_i
                    for j = 1:pxl_j
                        %pixels na matriz com zero padding que contemplam a operação atual
                        sub_idx_i = i:i+2*pad; %linha
                        sub_idx_j = j:j+2*pad; %coluna
                        sub_mtx = img_zp(sub_idx_i,sub_idx_j); %sub-matriz com os elementos que contemplam a operação atual
                        var_img(i,j) = var(sub_mtx(:)); %para [i,j] o pixel é a variância da sub-matriz
                    end
                end

            else
                error('[linear_filters_utils.variance2D] Operações sem zero padding ainda não estão disponíveis')
            end
        end

        function mmse_img = MMSE(img, mask_size, noise_var, varargin)
            %%--- Argumentos da função----------------------------------------
            %img: a matriz da imagem que se deseja aplicar a convolução com a máscara
            %mask_size: o tamanho da máscara em cada dimensão (média e variância da vizinhança)
            %noise_var: a variância do ruído
            %varargin: variável opcional que define o tratamento das bordas
            %retorna: a matriz de convolução entre a imagem e a máscara
            %-----------------------------------------------------------------
            %Acessa o argumento opcional para definir o tratamento da borda
            if ~isempty(varargin)
                borda = varargin{1}; %define borda como o argumento passado na função
            else
                borda = 'padding'; %por defeito o tratamento é zero padding então
            end

            if strcmp(borda, 'padding')
                img = double(img); %converte a imagem para double para operação de multiplicação
                
                %Média local
                avg_mask = edge_preserving_filters_utils.generate_mask(mask_size, 'box'); %máscara da média local
                avg_local = edge_preserving_filters_utils.convolve2D(img, avg_mask, borda); %média local de cada pixel da img
                
                %Variância local de cada pixel
                var_local = edge_preserving_filters_utils.variance2D(img, mask_size(1), 'padding'); 
                
                %Equação do MMSE
                %out = (1-(var_r/Vl)).*in + ((var_r/Vl).*ml);
                mmse_img = (1 - (noise_var./var_local)).*img + (noise_var./var_local).*avg_local;
                
            else
                error('[linear_filters_utils.MMSE] Operações sem zero padding ainda não estão disponíveis')
            end
        end

        function [img_zp, pad] = zero_padding(img, mask_size)
            %%--- Argumentos da função----------------------------------------
            %img: a matriz da imagem que se deseja aplicar o zero padding
            %mask_size: tamanho da máscara de convolução para definir como será o padding
            %retorna: a imagem original com zero padding dada a dimensão da máscara e a constante de padding
            %-----------------------------------------------------------------
            pad = (mask_size-1)/2; %constante para aumentar o tamanho da matriz original 
            pad_size = size(img) + 2*pad; %novo tamanho para a matriz considerando o zero padding
            img_zp = zeros(pad_size); %matriz com o zero padding na imagem original
            Y_valid = 1+pad:size(img_zp,1)-pad; %índices válidos em Y (linha) que contém a imagem
            X_valid = 1+pad:size(img_zp,2)-pad; %índices válidos em X (coluna) que contém a imagem
            img_zp(Y_valid, X_valid) = img; %define os pixels validos como a imagem original
        end
    end
end
