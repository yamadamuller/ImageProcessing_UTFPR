classdef edge_detection_utils
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
                    error('[edge_detection_utils.generate_mas] Valor de sigma deve ser passado como argumento!')
                end
                
                %Gaussiana
                [X,Y] = meshgrid(-floor(mask_size(1)/2):floor(mask_size(1)/2), -floor(mask_size(2)/2):floor(mask_size(2)/2)); %define todos os pontos X e Y que compõem a matriz do kernel gaussiano 
                sigma_sqr = double(sigma^2); %eleva o sigma ao quadrado para facilitar o cálculo do valor da gaussiana
                mask = (1/(2*pi*sigma_sqr))*exp(-(X.^2+Y.^2)/(2*sigma_sqr)); %equação da gaussiana
                mask = mask/sum(mask(:)); %normaliza em relação a soma para garantir que a soma da matriz é igual a 1
                %fonte: https://www.mathworks.com/help/images/ref/fspecial.html
            
            elseif strcmp(type, 'gaussian_x')
                %Acessa o argumento opcional para definir o valor de sigma
                if ~isempty(varargin)
                    sigma = varargin{1}; %define sigma como o argumento passado na função
                else
                    error('[edge_detection_utils.generate_mas] Valor de sigma deve ser passado como argumento!')
                end
                
                %Gaussiana
                X = -floor(mask_size(1)/2):floor(mask_size(1)/2); %define todos os pontos X compõem o vetor do kernel gaussiano 
                sigma_sqr = double(sigma^2); %eleva o sigma ao quadrado para facilitar o cálculo do valor da gaussiana
                mask = (1/(2*pi*sigma_sqr))*exp(-X.^2/(2*sigma_sqr)); %equação da gaussiana 1D
                mask = mask/sum(mask(:)); %normaliza em relação a soma para garantir que a soma do vetor é igual a 1
                %fonte: https://www.mathworks.com/help/images/ref/fspecial.html

            elseif strcmp(type, 'gaussian_y')
                %Acessa o argumento opcional para definir o valor de sigma
                if ~isempty(varargin)
                    sigma = varargin{1}; %define sigma como o argumento passado na função
                else
                    error('[edge_detection_utils.generate_mas] Valor de sigma deve ser passado como argumento!')
                end
                
                %Gaussiana
                Y = -floor(mask_size(1)/2):floor(mask_size(1)/2); %define todos os pontos Y compõem o vetor do kernel gaussiano 
                sigma_sqr = double(sigma^2); %eleva o sigma ao quadrado para facilitar o cálculo do valor da gaussiana
                mask = (1/(2*pi*sigma_sqr))*exp(-Y.^2/(2*sigma_sqr)); %equação da gaussiana 1D
                mask = mask/sum(mask(:)); %normaliza em relação a soma para garantir que a soma do vetor é igual a 1
                mask = mask'; %retorna transpoto para a operação g_x*g_y' ser válida
                %fonte: https://www.mathworks.com/help/images/ref/fspecial.html

            elseif strcmp(type, 'log')
                %Acessa o argumento opcional para definir o valor de sigma
                if ~isempty(varargin)
                    sigma = varargin{1}; %define sigma como o argumento passado na função
                else
                    error('[edge_detection_utils.generate_mas] Valor de sigma deve ser passado como argumento!')
                end
                
                %Laplaciano do Gaussiano
                [X,Y] = meshgrid(-floor(mask_size(1)/2):floor(mask_size(1)/2), -floor(mask_size(2)/2):floor(mask_size(2)/2)); %define todos os pontos X e Y que compõem a matriz do kernel gaussiano 
                sigma_sqr = double(sigma^2); %eleva o sigma ao quadrado para facilitar o cálculo do valor da gaussiana
                mask = (-1/(pi*sigma^4))*(1-((X.^2+Y.^2)/(2*sigma_sqr))).*exp(-(X.^2+Y.^2)/(2*sigma_sqr)); %equação do laplaciano do gaussiano
                mask = mask - sum(mask(:))/numel(mask); %normaliza em relação a soma para garantir que a soma da matriz é igual a 1
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
            elseif strcmp(type, 'sobel_x')
                mask = [ 1  2  1;
                         0  0  0;
                        -1 -2 -1];
            elseif strcmp(type, 'sobel_y')
                mask = [1  0  -1;
                        2  0  -2;
                        1  0  -1];
            else
                error('[edge_detection_utils.generate_mask] Tipo de filtro ' + string(tipo) + ' não aceito para gerar a máscara')
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
                [img_zp, pad] = edge_detection_utils.zero_padding(img, size(mask,1)); %nova matriz que contém as bordas tratadas com zero padding
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
            
            elseif strcmp(borda, 'valid')
                img = double(img); %converte a imagem para double para operação de multiplicação
                [img_zp, pad] = edge_detection_utils.zero_padding(img, size(mask,1)); %nova matriz que contém as bordas tratadas com zero padding
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
                
                %filtra apenas os pixels que foram computados sem tratamento de borda
                Y_valid = 1+pad:size(conv_img,1)-pad; %linha
                X_valid = 1+pad:size(conv_img,2)-pad; %coluna
                conv_img = conv_img(Y_valid, X_valid); %retorna apenas os pixels sem tratamento de borda
            
            else
                error('[linear_filters_utils.convolve2D] Operações sem zero padding ainda não estão disponíveis')
            end
        end
        
        function conv_img = derivative_convolve2D(img, mask, varargin)
            %%--- Argumentos da função----------------------------------------
            %img: a matriz da imagem que se deseja aplicar a convolução com a máscara
            %mask: a máscara de convolução para o eixo x (vetor 1,N)
            %varargin: variável opcional que define o tratamento das bordas
            %retorna: a matriz de convolução entre a imagem e a máscara vetor
            %-----------------------------------------------------------------
            %Acessa o argumento opcional para definir o tratamento da borda
            if ~isempty(varargin)
                borda = varargin{1}; %define borda como o argumento passado na função
            else
                borda = 'padding'; %por defeito o tratamento é "valid" -> apenas pixels sem tratamento de borda
            end
            
            if strcmp(borda, 'padding')
                img = double(img); %converte a imagem para double para operação de multiplicação
                [img_zp, pad] = edge_detection_utils.zero_padding(img, length(mask)); %nova matriz que contém as bordas tratadas com zero padding
                mask = fliplr(flipud(mask)); %"flip" na máscara eixo x pq é uma operação de convolução e não correlação
                %operação da convolução
                conv_img = zeros(size(img)); %a matriz da convolação deve ter o tamanho da original
                %pixels da imagem original que serão tratados
                pxl_i = 1+pad:size(img_zp,1)-pad; %linha
                pxl_j = 1+pad:size(img_zp,2)-pad; %coluna

                %se máscara for vertical
                if size(mask,2) > 1 
                    for i = pxl_i
                        for j = pxl_j
                            %pixels na matriz com zero padding que contemplam a operação atual
                            sub_idx_i_x = i; %linha
                            sub_idx_j_x = j-pad:j+pad; %coluna
                            sub_mtx_x = img_zp(sub_idx_i_x,sub_idx_j_x).*mask; %produtos por elemento entre a submatriz e a máscara
                            conv_img(i-pad,j-pad) = sum(sub_mtx_x(:)); %para [i,j] de saída o pixel é a soma dos produtos
                        end
                    end
                
                %se máscara for horizontal
                elseif size(mask,2) == 1
                    for i = pxl_i
                        for j = pxl_j
                            %pixels na matriz com zero padding que contemplam a operação atual
                            sub_idx_i_y = i-pad:i+pad; %linha
                            sub_idx_j_y = j; %coluna
                            sub_mtx_y = img_zp(sub_idx_i_y,sub_idx_j_y).*mask; %produtos por elemento entre a submatriz de (I*Hx) e a máscara
                            conv_img(i-pad,j-pad) = sum(sub_mtx_y(:)); %para [i,j] de saída o pixel é a soma dos produtos
                        end
                    end
                else
                    error('[edge_detection_utils.separable_convolve2D] Máscara possui formato não aceito!')
                end

            else
                error('[edge_detection_utils.separable_convolve2D] Operações sem zero padding ainda não estão disponíveis')
            end
        end

        function [img_zp, pad] = zero_padding(img, mask_size)
            %%--- Argumentos da função----------------------------------------
            %img: a matriz da imagem que se deseja aplicar o zero padding
            %mask: a máscara de convolução para definir como será o padding
            %retorna: a imagem original com zero padding dada a dimensão da máscara e a constante de padding
            %-----------------------------------------------------------------
            pad = (mask_size-1)/2; %constante para aumentar o tamanho da matriz original 
            pad_size = size(img) + 2*pad; %novo tamanho para a matriz considerando o zero padding
            img_zp = zeros(pad_size); %matriz com o zero padding na imagem original
            Y_valid = 1+pad:size(img_zp,1)-pad; %índices válidos em Y (linha) que contém a imagem
            X_valid = 1+pad:size(img_zp,2)-pad; %índices válidos em X (coluna) que contém a imagem
            img_zp(Y_valid, X_valid) = img; %define os pixels validos como a imagem original
        end

        function f_prime = num_derivative(profile, varargin)
            %%--- Argumentos da função----------------------------------------
            %profile: perfil da imagem que se deseja computar a derivada (uma linha com todas as colunas)
            %varargin: epsilon de máquina para computar a derivada, 1 por padrão (intervalo entre pixels)
            %retorna: a derivada númerica por diferença central calculada para cada pixel do perfil 
            %-----------------------------------------------------------------
             %Acessa o argumento opcional para definir o epsilon de máquina
            if ~isempty(varargin)
                eps = varargin{1}; %define eps como o argumento passado na função
            else
                eps = 1; %por defeito o epsilon é 1
            end

            forward = circshift(profile, -eps); %desloca o vetor em -eps amostras (f[i+eps])
            backward = circshift(profile, eps); %desloca o vetor em eps amostras (f[i-eps])
            f_prime = forward - backward; %f'[i] = f[i+eps] - f[i-eps]
            f_prime = f_prime./2; %diferença central -> (f[i+eps] - f[i-eps])/2
            f_prime([1 size(f_prime)]) = 0; %primeiro e último elementos para zero
        end

        function f_sec_prime = num_sec_derivative(profile, varargin)
            %%--- Argumentos da função----------------------------------------
            %profile: perfil da imagem que se deseja computar a derivada (uma linha com todas as colunas)
            %varargin: epsilon de máquina para computar a derivada segunda, 1 por padrão (intervalo entre pixels)
            %retorna: a derivada segunda númerica por diferença central calculada para cada pixel do perfil 
            %-----------------------------------------------------------------
             %Acessa o argumento opcional para definir o epsilon de máquina
            if ~isempty(varargin)
                eps = varargin{1}; %define eps como o argumento passado na função
            else
                eps = 1; %por defeito o epsilon é 1
            end

            forward = circshift(profile, -eps); %desloca o vetor em -eps amostras (f[i+eps])
            backward = circshift(profile, eps); %desloca o vetor em eps amostras (f[i-eps])
            current = 2*profile; %multiplica o pixel atual por 2
            f_sec_prime = forward - current + backward; %f'[i] = f[i+eps] - 2f[i] + f[i-eps]
            f_sec_prime = f_sec_prime./2; %diferença central -> (f[i+eps] - 2f[i] + f[i-eps])/2
            f_sec_prime([1 size(f_sec_prime)]) = 0; %primeiro e último elementos para zero
        end

        function grad_mag = gradient_magnitude(img, varargin)
            %%--- Argumentos da função----------------------------------------
            %img: a matriz da imagem que se deseja calcular a magnitude do gradiente
            %varargin: variável opcional que define o tratamento das bordas
            %retorna: a magnitude do gradiente
            %-----------------------------------------------------------------
            %Acessa o argumento opcional para definir o tratamento da borda
            if ~isempty(varargin)
                borda = varargin{1}; %define borda como o argumento passado na função
            else
                borda = 'padding'; %por defeito o tratamento é "valid" -> apenas pixels sem tratamento de borda
            end
            sobel_mask_h = edge_detection_utils.generate_mask([], 'sobel_x'); %máscara sobel horizontal
            sobel_mask_v = edge_detection_utils.generate_mask([], 'sobel_y'); %máscara sobel vertical
            sobel_h = edge_detection_utils.convolve2D(img, sobel_mask_h, borda); %I*H_sobel_h
            sobel_v = edge_detection_utils.convolve2D(img, sobel_mask_v, borda); %I*H_sobel_v
            grad_mag = sqrt(sobel_v.^2 + sobel_h.^2); %M[i,j] = sqrt(Sv[i,j]^2 + Sh[i,j]^2)
        end

        function grad_orient = gradient_phase(img, varargin)
            %%--- Argumentos da função----------------------------------------
            %img: a matriz da imagem que se deseja calcular a fase do gradiente
            %varargin: variável opcional que define o tratamento das bordas
            %retorna: a fase do gradiente
            %-----------------------------------------------------------------
            %Acessa o argumento opcional para definir o tratamento da borda
            if ~isempty(varargin)
                borda = varargin{1}; %define borda como o argumento passado na função
            else
                borda = 'padding'; %por defeito o tratamento é "valid" -> apenas pixels sem tratamento de borda
            end
            sobel_mask_h = edge_detection_utils.generate_mask([], 'sobel_x'); %máscara sobel horizontal
            sobel_mask_v = edge_detection_utils.generate_mask([], 'sobel_y'); %máscara sobel vertical
            sobel_h = edge_detection_utils.convolve2D(img, sobel_mask_h, borda, 'valid'); %I*H_sobel_h
            sobel_v = edge_detection_utils.convolve2D(img, sobel_mask_v, borda, 'valid'); %I*H_sobel_v
            grad_orient = atan(sobel_h./sobel_v); %arco tangente(I*H_sobel_h/I*H_sobel_v)
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

        function q_opt = otsu_threshold(img)
            %%--- Argumentos da função----------------------------------------
            %img: a matriz da imagem que se deseja obter o limiar ótimo
            %retorna: o valor na escala de cinza que maximiza a variância entre-classes (between-class variance)
            %-----------------------------------------------------------------
            %Baseado em: 
            %[1] - Otsu, N., "A Threshold Selection Method from Gray-Level Histograms." 
            %IEEE Transactions on Systems, Man, and Cybernetics. Vol. 9, No. 1, 1979, pp. 62–66.
            %TODO: testar maximização por Newton ao invés do gs
            img = im2uint8(img); %converte para uint8
            MN = numel(img); %número de pixels total da imagem
            K = 255; %dynamic range para uint8
            h = edge_detection_utils.im_histogram(img); %histograma da imagem
            var_bc = zeros(K,1); %vetor que irá armazernar a variância entre classse computada para cada q candidato
            for q_cand = 1:K-1 %testa candidatos de 1 até 254 para separa entre back e foreground
                [curr_mu0, curr_mu1, curr_n0, curr_n1] = edge_detection_utils.assign_pixels(h, q_cand); %médias e número de pixels para 
                var_bc(q_cand) = (1/MN^2) * curr_n0 * curr_n1 * (curr_mu0 - curr_mu1)^2; %variÂncia entre classes
            end

            %Calcula qual valor de q maximiza a var_bc
            [~, q_opt] = max(var_bc(:));
            
        end

        function [mu_c0, mu_c1, n_c0, n_c1] = assign_pixels(h, q)
            %%--- Argumentos da função----------------------------------------
            %h: histograma da matriz da imagem que se deseja obter o número de pixels por classe
            %q: valor atual da limiar 
            %retorna: a média dos pixels atribuídos para cada classe e o número de pixels atribuídos À cada classe
            %-----------------------------------------------------------------
            gs = 0:255; %vetor com todos valores possíveis para uma imagem uint8
            c0 = h(1:q); %pixels atribuídos à classe 0
            n_c0 = sum(c0(:)); %somatório dos pixels atribuídos à classe 0
            pond_n_c0 = gs(1:q)*c0; %sum{g=0->q}(g.h[g])
            mu_c0 = sum(pond_n_c0(:))/n_c0; %média para os pixels da classe 0
            c1 = h(q+1:end); %pixels atribuídos à classe 1
            n_c1 = sum(c1(:)); %somatório dos pixels atribuídos à classe 1
            pond_n_c1 = gs(q+1:end)*c1; %sum{g=q+1->K}(g.h[g])
            mu_c1 = sum(pond_n_c1(:))/n_c1; %média para os pixels da classe 1

        end

        function img = bw_thresholding(img, q)
            %%--- Argumentos da função----------------------------------------
            %img: a matriz da imagem que se deseja separar em níveis binários
            %q: valor da limiar 
            %retorna: imagem convertida para binária dado o valor da limiar
            %-----------------------------------------------------------------
            img = im2uint8(img); %converte para uint8
            img(img>q) = 255; %1 binário
            img(img<q) = 0; %0 binário
        end

        function hist_hash = im_histogram(img)
            %%--- Argumentos da função----------------------------------------
            %img: a matriz da imagem que se deseja calcular o histograma
            %retorna: contagem para cada pixel da imagem por iteração
            %-----------------------------------------------------------------
            img = im2uint8(img); %converte a imagem para uint8 para termos valores de 0 a 255
            img = img(:); %empilha a matriz em um vetor de tamanho  i*j
            hist_hash = zeros(size(0:1:255)); %hash que registra para cada pixel (índice) a contagem
            
            %adiciona 1 na hash que registra a contagem a cada vez que
            %registrar a ocorrência do respectivo pixel
            for i = 1:length(img)
                hist_hash(double(img(i))+1) = hist_hash(double(img(i))+1) + 1; %matlab é one-based e pixel pode ter valor 0
            end

            hist_hash = hist_hash'; %aplica transposta para output ter as msm dimensões de imhist()
        end
    end
end