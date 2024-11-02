classdef linear_filters_utils
    methods (Static)
        function mask = generate_mask(mask_size, type, varargin)
            %%--- Argumentos da função----------------------------------------
            %mask_size: o tamanho da máscara de convolução em cada dimensão
            %type: qual é o tipo do filtro espacial
            %varargin: argumento opcional que recebe o sigma para o filtro espacial gaussiano
            %retorna: a máscara de convolução para o filtro de tamanho igual a "mask_size" do tipo igual ao "tipo"
            %-----------------------------------------------------------------
            if strcmp(type, 'box')
                mask = ones(mask_size); %vetor com size igual ao tamanho completo de 1s
                mask = mask./(numel(mask)); %o valor de cada elemento da máscara da média é 1/(tam(1)*tam(2))

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
                [img_zp, pad] = linear_filters_utils.zero_padding(img, mask); %nova matriz que contém as bordas tratadas com zero padding
                mask = fliplr(flipud(mask)); %"flip" na máscara pq é uma operação de convolução e não correlação
                
                %operação da convolução
                conv_img = zeros(size(img)); %a matriz da convulação deve ter o tamanho da original
                %pixels (linha) da imagem original que serão tratados
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
                
                conv_img = uint8(conv_img); %converte a matrix para uint8 para facilitar plot

            else
                error('[linear_filters_utils.convolve2D] Operações sem zero padding ainda não estão disponíveis')
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

        function usm_img = unsharp_masking(img, mask_size, mask_type,  varargin)
            %%--- Argumentos da função----------------------------------------
            %img: a matriz da imagem que se deseja aplicar a convolução com a máscara
            %mask_size: o tamanho da máscara de convolução em cada dimensão
            %mask_type: qual é o tipo do filtro espacial
            %varargin: variável opcional que define o "ganho" do unsharp masking
            %retorna: a matriz de convolução entre a imagem e a máscara
            %-----------------------------------------------------------------
             %Acessa o argumento opcional para definir o tratamento da borda
            if ~isempty(varargin)
                ganho = varargin{1}; %define ganho do filtro como o argumento passado na função
            else
                ganho = 1; %por defeito o ganho do filtro é 1
            end

            img = double(img); %converte a imagem para double para operação de multiplicação
            
            %gera a máscara do filtro passa baixas
            lpf_mask = linear_filters_utils.generate_mask(mask_size, mask_type, 1); %máscara do filtro passa baixas
            lpf_filt = linear_filters_utils.convolve2D(img, lpf_mask, 'padding'); %convolução entre imagem e máscara para obter informação de baixa frequência
            
            %unsharp masking
            no_low_freq = img - double(lpf_filt); %imagem original sem a informação de baixa frequência
            usm_img = img + (no_low_freq.*ganho); %imagem original adicionada da imagem sem baixas frequências com ganho
            usm_img = uint8(usm_img); %converte para uint8
        end
    end
end
