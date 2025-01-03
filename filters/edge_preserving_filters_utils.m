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
                    error('[edge_preserving_filters_utils.mascara_conv] Valor de sigma deve ser passado como argumento!')
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
                error('[edge_preserving_filters_utils.generate_mask] Tipo de filtro ' + string(tipo) + ' não aceito para gerar a máscara')
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
            
            elseif strcmp(borda, 'valid')
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

                %filtra apenas os pixels que foram computados sem tratamento de borda
                Y_valid = 1+pad:size(conv_img,1)-pad; %linha
                X_valid = 1+pad:size(conv_img,2)-pad; %coluna
                conv_img = conv_img(Y_valid, X_valid); %retorna apenas os pixels sem tratamento de borda

            else
                error('[edge_preserving_filters_utils.convolve2D] Operações sem zero padding ainda não estão disponíveis')
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
            
            elseif strcmp(borda, 'valid')
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
                error('[edge_preserving_filters_utils.variance2D] Operações sem zero padding ainda não estão disponíveis')
            end
        end

        function mmse_img = MMSE(img, mask_size, noise_var, varargin)
            %%--- Argumentos da função----------------------------------------
            %img: a matriz da imagem que se deseja aplicar a convolução com a máscara
            %mask_size: o tamanho da máscara em cada dimensão (média e variância da vizinhança)
            %noise_var: a variância do ruído
            %varargin: variável opcional que define o tratamento das bordas
            %retorna: a imagem filtrada pelo MMSE
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
            
            elseif strcmp(borda, 'valid')
                img = double(img); %converte a imagem para double para operação de multiplicação
                
                %Média local
                avg_mask = edge_preserving_filters_utils.generate_mask(mask_size, 'box'); %máscara da média local
                avg_local = edge_preserving_filters_utils.convolve2D(img, avg_mask, borda, 'valid'); %média local de cada pixel da img
                
                %Variância local de cada pixel
                var_local = edge_preserving_filters_utils.variance2D(img, mask_size(1), 'valid'); 
                
                %Equação do MMSE
                %out = (1-(var_r/Vl)).*in + ((var_r/Vl).*ml);
                mmse_img = (1 - (noise_var./var_local)).*img + (noise_var./var_local).*avg_local;
            
            else
                error('[edge_preserving_filters_utils.MMSE] Operações sem zero padding ainda não estão disponíveis')
            end
        end
        
        function bilat_img = bilateral_filter(img, sigma_d, sigma_r, varargin)
            %%--- Argumentos da função----------------------------------------
            %img: a matriz da imagem que se deseja aplicar o bilateral filter
            %sigma_d: desvio padrão para o domain kernel
            %sigma_r: desvio padrão para o range kernel
            %varargin: variável opcional que define o tratamento das bordas
            %retorna: a imagem filtrada pelo bilateral filter
            %-----------------------------------------------------------------
            %Acessa o argumento opcional para definir o tratamento da borda
            if ~isempty(varargin)
                borda = varargin{1}; %define borda como o argumento passado na função
            else
                borda = 'padding'; %por defeito o tratamento é zero padding então
            end

            if strcmp(borda, 'padding')
                img = double(img); %converte a imagem para double para operação de multiplicação
                domain_size = 2*ceil(2*sigma_d)+1; %tamanho do domain kernel com base no desvio padrão
                %fonte: https://www.mathworks.com/help/images/ref/imgaussfilt.html
                domain_kernel = edge_preserving_filters_utils.generate_mask([domain_size domain_size], 'gaussian', sigma_d); %domain kernel gaussiano
                domain_kernel = fliplr(flipud(domain_kernel)); %"flip" na máscara pq é uma operação de convolução e não correlação
                [img_zp, pad] = edge_preserving_filters_utils.zero_padding(img, size(domain_kernel,1)); %nova matriz que contém as bordas tratadas com zero padding
                
                %bilateral filter
                bilat_img = zeros(size(img)); %a matriz da convulação deve ter o tamanho da original
                %pixels da imagem original que serão tratados
                pxl_i = size(img,1); %linha
                pxl_j = size(img,2); %coluna
                for i = 1:pxl_i
                    for j = 1:pxl_j
                        %pixels na matriz com zero padding que contemplam a operação atual
                        sub_idx_i = i:i+2*pad; %linha
                        sub_idx_j = j:j+2*pad; %coluna
                        sub_mtx = img_zp(sub_idx_i,sub_idx_j); %submatriz com tamanho da janela
                        center_pixel = ones(size(sub_mtx)).*img_zp(i+pad, j+pad); %vetor preenchido com o valor do pixel central
                        range_kernel = (1/(2*pi*sigma_r))*exp(-(center_pixel - sub_mtx).^2/(2*sigma_r)); %equação da gaussiana 1D do range kernel
                        kernel_mult = domain_kernel.*range_kernel; %multiplicação entre os dois kernels
                        bilat_prod = sub_mtx.*kernel_mult; %multiplicação por elemento entre a submatriz e os dois kernels multiplicados
                        bilat_mac = sum(bilat_prod(:)); %soma de produtos (MAC -> multiply and accumulate)
                        bilat_img(i,j) = bilat_mac/sum(kernel_mult(:)); %para [i,j] o pixel é a soma dos produtos ponderada pela soma dos pesos compostos
                    end
                end
            
            elseif strcmp(borda, 'valid')
                %INFO: totalmente não-otimizado!
                img = im2gray(im2double(img)); %converte a imagem para valores entre 0 e 1
                domain_size = 2*ceil(2*sigma_d)+1; %tamanho do domain kernel com base no desvio padrão
                %fonte: https://www.mathworks.com/help/images/ref/imgaussfilt.html
                domain_kernel = edge_preserving_filters_utils.generate_mask([domain_size domain_size], 'gaussian', sigma_d); %domain kernel gaussiano
                %domain_kernel = fliplr(flipud(domain_kernel)); %"flip" na máscara pq é uma operação de convolução e não correlação
                [img_zp, pad] = edge_preserving_filters_utils.zero_padding(img, size(domain_kernel,1)); %nova matriz que contém as bordas tratadas com zero padding
                
                %bilateral filter
                bilat_img = zeros(size(img)); %a matriz da convulação deve ter o tamanho da original
                %pixels da imagem original que serão tratados
                pxl_i = size(img,1); %linha
                pxl_j = size(img,2); %coluna
                for i = 1:pxl_i
                    for j = 1:pxl_j
                        %pixels na matriz com zero padding que contemplam a operação atual
                        sub_idx_i = i:i+2*pad; %linha
                        sub_idx_j = j:j+2*pad; %coluna
                        sub_mtx = img_zp(sub_idx_i,sub_idx_j); %submatriz com tamanho da janela
                        center_pixel = ones(size(sub_mtx)).*img_zp(i+pad, j+pad); %vetor preenchido com o valor do pixel central
                        range_kernel = (1/(2*pi*sigma_r))*exp(-(center_pixel - sub_mtx).^2/(2*sigma_r^2)); %equação da gaussiana 1D do range kernel
                        kernel_mult = domain_kernel.*range_kernel; %multiplicação entre os dois kernels
                        bilat_prod = sub_mtx.*kernel_mult; %multiplicação por elemento entre a submatriz e os dois kernels multiplicados
                        bilat_mac = sum(sum(bilat_prod)); %soma de produtos (MAC -> multiply and accumulate)
                        bilat_img(i,j) = bilat_mac/sum(kernel_mult(:)); %para [i,j] o pixel é a soma dos produtos ponderada pela soma dos pesos compostos
                    end
                end
                
                %filtra apenas os pixels que foram computados sem tratamento de borda 
                Y_valid = 1+pad:size(bilat_img,1)-pad; %linha
                X_valid = 1+pad:size(bilat_img,2)-pad; %coluna
                bilat_edge = zeros(size(bilat_img)); %cria uma matriz de zeros do tamanho da imagem processada
                bilat_edge(Y_valid, X_valid) = bilat_img(Y_valid, X_valid); %retorna apenas os pixels sem tratamento de borda
                bilat_img = bilat_edge; %comuta as variáveis para retornar a imagem com 0 nos pixels não tratados

            else
                error('[edge_preserving_filters_utils.convolve2D] Operações sem zero padding ainda não estão disponíveis')
            end
        end

        function range_img = range_filter(img, sigma_d, sigma_r, varargin)
            %%--- Argumentos da função----------------------------------------
            %img: a matriz da imagem que se deseja aplicar o bilateral filter
            %sigma_d: desvio padrão para o domain kernel
            %sigma_r: desvio padrão para o range kernel
            %varargin: variável opcional que define o tratamento das bordas
            %retorna: a imagem filtrada pelo bilateral filter
            %-----------------------------------------------------------------
            %Acessa o argumento opcional para definir o tratamento da borda
            if ~isempty(varargin)
                borda = varargin{1}; %define borda como o argumento passado na função
            else
                borda = 'padding'; %por defeito o tratamento é zero padding então
            end

            if strcmp(borda, 'padding')
                img = (im2double(img)); %converte a imagem para valores entre 0 e 1
                domain_size = 2*ceil(2*sigma_d)+1; %tamanho do domain kernel com base no desvio padrão
                %fonte: https://www.mathworks.com/help/images/ref/imgaussfilt.html
                domain_kernel = edge_preserving_filters_utils.generate_mask([domain_size domain_size], 'gaussian', sigma_d); %domain kernel gaussiano
                domain_kernel = fliplr(flipud(domain_kernel)); %"flip" na máscara pq é uma operação de convolução e não correlação
                [img_zp, pad] = edge_preserving_filters_utils.zero_padding(img, size(domain_kernel,1)); %nova matriz que contém as bordas tratadas com zero padding
                
                %bilateral filter
                range_img = zeros(size(img)); %a matriz da convulação deve ter o tamanho da original
                %pixels da imagem original que serão tratados
                pxl_i = size(img,1); %linha
                pxl_j = size(img,2); %coluna
                for i = 1:pxl_i
                    for j = 1:pxl_j
                        %pixels na matriz com zero padding que contemplam a operação atual
                        sub_idx_i = i:i+2*pad; %linha
                        sub_idx_j = j:j+2*pad; %coluna
                        sub_mtx = img_zp(sub_idx_i,sub_idx_j); %submatriz com tamanho da janela
                        center_pixel = ones(size(sub_mtx)).*img_zp(i+pad, j+pad); %vetor preenchido com o valor do pixel central
                        range_kernel = (1/(2*pi*sigma_r))*exp(-(center_pixel - sub_mtx).^2/(2*sigma_r)); %equação da gaussiana 1D do range kernel
                        range_kernel = range_kernel/sum(range_kernel(:)); %normaliza em relação a soma para garantir que a soma da matriz é igual a 1
                        %fonte: https://www.mathworks.com/help/images/ref/fspecial.html
                        range_prod = sub_mtx.*range_kernel; %multiplicação por elemento entre a submatriz e o kernel
                        range_img(i,j) = sum(range_prod(:)); %para [i,j] o pixel é a soma dos produtos
                    end
                end
            
            elseif strcmp(borda, 'valid')
                %INFO: totalmente não-otimizado!
                img = double(img); %converte a imagem para double para operação de multiplicação
                domain_size = 2*ceil(2*sigma_d)+1; %tamanho do domain kernel com base no desvio padrão
                %fonte: https://www.mathworks.com/help/images/ref/imgaussfilt.html
                domain_kernel = edge_preserving_filters_utils.generate_mask([domain_size domain_size], 'gaussian', sigma_d); %domain kernel gaussiano
                domain_kernel = fliplr(flipud(domain_kernel)); %"flip" na máscara pq é uma operação de convolução e não correlação
                [img_zp, pad] = edge_preserving_filters_utils.zero_padding(img, size(domain_kernel,1)); %nova matriz que contém as bordas tratadas com zero padding
                
                %bilateral filter
                range_img = zeros(size(img)); %a matriz da convulação deve ter o tamanho da original
                %pixels da imagem original que serão tratados
                pxl_i = size(img,1); %linha
                pxl_j = size(img,2); %coluna
                for i = 1:pxl_i
                    for j = 1:pxl_j
                        %pixels na matriz com zero padding que contemplam a operação atual
                        sub_idx_i = i:i+2*pad; %linha
                        sub_idx_j = j:j+2*pad; %coluna
                        sub_mtx = img_zp(sub_idx_i,sub_idx_j); %submatriz com tamanho da janela
                        center_pixel = ones(size(sub_mtx)).*img_zp(i+pad, j+pad); %vetor preenchido com o valor do pixel central
                        range_kernel = (1/(2*pi*sigma_r))*exp(-(center_pixel - sub_mtx).^2/(2*sigma_r)); %equação da gaussiana 1D do range kernel
                        range_kernel = range_kernel/sum(range_kernel(:)); %normaliza em relação a soma para garantir que a soma da matriz é igual a 1
                        %fonte: https://www.mathworks.com/help/images/ref/fspecial.html
                        range_prod = sub_mtx.*range_kernel; %multiplicação por elemento entre a submatriz e o kernel
                        range_img(i,j) = sum(range_prod(:)); %para [i,j] o pixel é a soma dos produtos
                    end
                end
                
                %filtra apenas os pixels que foram computados sem tratamento de borda 
                Y_valid = 1+pad:size(range_img,1)-pad; %linha
                X_valid = 1+pad:size(range_img,2)-pad; %coluna
                range_edge = zeros(size(range_img)); %cria uma matriz de zeros do tamanho da imagem processada
                range_edge(Y_valid, X_valid) = range_img(Y_valid, X_valid); %retorna apenas os pixels sem tratamento de borda
                range_img = range_edge; %comuta as variáveis para retornar a imagem com 0 nos pixels não tratados

            else
                error('[edge_preserving_filters_utils.convolve2D] Operações sem zero padding ainda não estão disponíveis')
            end
        end

        function pm_img = perona_malik_filter(img, alpha, kappa, varargin)
            %%--- Argumentos da função----------------------------------------
            %img: a matriz da imagem que se deseja aplicar o zero padding
            %alpha: taxa de atualização
            %kappa: parÂmetro de suavização
            %varargin: variável opcional que define o número de iterações
            %retorna: a imagem processada com base no filtro apresentado por perona e malik em [1]
            %-----------------------------------------------------------------
            %TODO: OTIMIZAR COM CONVOLVE2D!
            %[1] - P. Perona, J. Malik,
            %Scale-Space and Edge Detection Using Anisotropic Diffusion,
            %IEEE Transactions on Pattern Analysis and Machine Intelligence, Volume 12, Issue 7, 1990.
            %Acessa o argumento opcional para definir o número de iterações
            if ~isempty(varargin)
                n_iter = varargin{1}; %define borda como o argumento passado na função
            else
                n_iter = 10; %por defeito o código roda 5 iterações
                %fonte: https://www.mathworks.com/help/images/ref/imdiffusefilt.html
            end

            img = double(img); %converte a imagem para double
            [img_zp, pad] = edge_preserving_filters_utils.zero_padding(img, 3); %nova matriz que contém as bordas tratadas com zero padding
            %OBS: 3x3 para poder computar as diferenças das vizinhanças 4 para todos os pixels
            pm_img = img_zp; %condição inicial é a imagem original

            %Perona-Malik filter
            %I[n] = I[n-1] + alpha*sum{i = 0:3}(g(delta_i)*delta_i)
            for iter = 1:n_iter
                %pixels da condição inicial que serão tratados
                pxl_i = size(img,1); %linha
                pxl_j = size(img,2); %coluna
                for i = 1:pxl_i
                    for j = 1:pxl_j
                        %pixels na matriz com zero padding que contemplam a operação atual da vizinhança 4
                        sub_idx_i = i:i+2*pad; %linha
                        sub_idx_j = j:j+2*pad; %coluna
                        sub_mtx = pm_img(sub_idx_i,sub_idx_j); %submatriz com tamanho da janela que contempla a vizinhança 4
                        center_pixel = ones(size(sub_mtx)).*pm_img(i+pad, j+pad); %vetor preenchido com o valor do pixel central
                        n4_idx_i = [i, i+1, i+1, i+2]; %ìndices da vizinhança 4 em i
                        n4_idx_j = [j+1, j, j+2, j+1]; %índices da vizinhança 4 em j
                        n4_idx = sub2ind(size(pm_img), n4_idx_i, n4_idx_j); %índices da vizinhança 4
                        delta_i = pm_img(n4_idx) - center_pixel(1:4); %diferença entre pixel central e vizinhança 4
                        g = edge_preserving_filters_utils.conductivity_functions(delta_i, kappa); %calcula o coeficiente de condutividade
                        grad_mult = g.*delta_i; %multiplicação interna do somatório vizinhança 4
                        grad = sum(grad_mult(:)); %somatório da vizinhança 4
                        pm_img(i+pad,j+pad) = pm_img(i+pad,j+pad) + alpha*grad; %atualiza a estimativa
                    end
                end
            end
            
            %Retira o zero padding
            Y_valid = 1+pad:size(pm_img,1)-pad; %linha
            X_valid = 1+pad:size(pm_img,2)-pad; %coluna
            pm_img = pm_img(Y_valid, X_valid);
            
        end

        function g = conductivity_functions(nabla, kappa, varargin)
            %%--- Argumentos da função----------------------------------------
            %nabla: gradiente local
            %kappa: parÂmetro de suavização
            %varargin: argumento opcional que define qual equação será usada
            %retorna: o valor do coeficiente de condutividade em função de nabla e kappa com base nas equações de [1]
            %-----------------------------------------------------------------
            %[1] - P. Perona, J. Malik,
            %Scale-Space and Edge Detection Using Anisotropic Diffusion,
            %IEEE Transactions on Pattern Analysis and Machine Intelligence, Volume 12, Issue 7, 1990.
            %Acessa o argumento opcional para definir o número de iterações
            if ~isempty(varargin)
                eq_i = varargin{1}; %define borda como o argumento passado na função
            else
                eq_i = 1; %por defeito a equação exponencial é utilizada
            end

            if eq_i == 1
                g = exp(-(nabla/kappa).^2);
            elseif eq_i == 2
                g = 1./(1 + (nabla/kappa).^2);
            else
                error('[edge_preserving_fitlers_utils.conductivity_functions] Apenas 1 e 2 são argumentos válidos para a opção de equação!')
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
