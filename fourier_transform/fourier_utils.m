classdef fourier_utils
    methods (Static)
        function [dft_r, dft_i] = dft1D(signal_r, signal_i, varargin)
            %%--- Argumentos da função----------------------------------------
            %signal_r: parte real do sinal
            %signal_i: parte imaginária do sinal
            %varargin: flag para realizar fft shift ou não (variável opcional, true por defeito)
            %retorna: parte real e imaginária do espectro do sinal
            %-----------------------------------------------------------------
            %Acessa o argumento opcional para definir o valor de sigma
            if ~isempty(varargin)
                shift = varargin{1}; %define shift como o argumento passado na função
            else
                shift = true;
            end

            %Transpõe os sinais se necessário dado o shape
            if size(signal_r,1) > 1
                signal_r = signal_r';
                signal_i = signal_i';
            end

            N = length(signal_r); %número total de amostras
            dft_r = zeros(N,1); %vetor para armazenar os valores reais do espectro
            dft_i = zeros(N,1); %vetor para armazenar os valores imaginários do espectro
            
            %Realiza fftshift ou não
            if shift
                n = 0:length(signal_r)-1; %componentes da frequência para shift
                signal_r = signal_r.*(-1).^n; %fftshift na parte real
                signal_i = signal_i.*(-1).^n; %fftshift na parte imaginária
            end

            for u = 1:N %índice das frequências
                n = 1:N; %vetor com índices das amostras
                theta = 2*pi*(u-1).*(n-1)/N; %theta = (2*pi*u/N)*(n-1)
                sum_r = signal_r.*cos(theta) + signal_i.*sin(theta); %parte real = fr[n]*cos(theta) + fi[n]*sen(theta)
                sum_i = -signal_r.*sin(theta) + signal_i.*cos(theta); %parte imaginária = j{-fr[n]*sen(theta) + fi[n]*cos(theta)}
                dft_r(u) = sum(sum_r(:)); %componente real da frequência u é a soma real
                dft_i(u) = sum(sum_i(:)); %componente imaginária da frequência u é a soma imaginária
            end
        end

        function [idft_r, idft_i] = idft1D(signal_r, signal_i)
            %%--- Argumentos da função----------------------------------------
            %signal_r: parte real do sinal
            %signal_i: parte imaginária do sinal
            %retorna: parte real e imaginária da inversa do espectro do sinal
            %-----------------------------------------------------------------
            %Transpõe os sinais se necessário dado o shape
            if size(signal_r,1) > 1
                signal_r = signal_r';
                signal_i = signal_i';
            end

            N = length(signal_r); %número total de amostras
            idft_r = zeros(N,1); %vetor para armazenar os valores reais do espectro
            idft_i = zeros(N,1); %vetor para armazenar os valores imaginários do espectro
            for u = 1:N %índice das frequências
                n = 1:N; %vetor com índices das amostras
                theta = 2*pi*(u-1).*(n-1)/N; %theta = (2*pi*u/N)*(n-1)
                sum_r = signal_r.*cos(theta) - signal_i.*sin(theta); %parte real = fr[n]*cos(theta) - fi[n]*sen(theta)
                sum_i = signal_r.*sin(theta) + signal_i.*cos(theta); %parte imaginária = j{fr[n]*sen(theta) + fi[n]*cos(theta)}
                idft_r(u) = sum(sum_r(:)); %componente real da frequência u é a soma real
                idft_i(u) = sum(sum_i(:)); %componente imaginária da frequência u é a soma imaginária
            end
        end

        function [dft_r, dft_i] = im_dft1D(img_r, img_i, axis, varargin)
            %%--- Argumentos da função----------------------------------------
            %img_r: parte real da imagem que se deseja aplicar a dft
            %img_i: parte imaginária da imagem que se deseja aplicar a dft
            %axis: define se serão tratadas linhas ou colunas
            %varargin: flag para realizar fft shift ou não (variável opcional, true por defeito)
            %retorna: parte real e imaginária da inversa do espectro do sinal
            %-----------------------------------------------------------------
            %Verifica o argumento axis
            if (axis > 2) || (axis < 1)
                error('[fourier_utils.im_idft1D] Axis deve ter valor 1 ou 2!')
            end
            
            %Acessa o argumento opcional para definir o valor de sigma
            if ~isempty(varargin)
                shift = varargin{1}; %define shift como o argumento passado na função
            else
                shift = true;
            end

            img_r = double(img_r); %converte a imagem real para double
            img_i = double(img_i); %converte a imagem imaginária para double
            N = size(img_r,axis); %número total de amostras do eixo processado
            [i,j] = size(img_r); %tamanho da imagem
            dft_r = zeros(i,j); %vetor para armazenar os valores reais do espectro
            dft_i = zeros(i,j); %vetor para armazenar os valores imaginários do espectro
            for idx = 1:N %índice das frequências
                %Define o perfil para aplicar a dft
                if axis == 1
                    profile_r = img_r(idx,:); %processa a linha atual na parte real
                    profile_i = img_i(idx,:); %parte imaginária é zero
                    [dft_r(idx,:), dft_i(idx,:)] = fourier_utils.dft1D(profile_r, profile_i, shift); %DFT do perfil [idx] atual
                elseif axis == 2
                    profile_r = img_r(:,idx); %processa a coluna atual na parte real
                    profile_i = img_i(:,idx); %parte imaginária é zero
                    [dft_r(:,idx), dft_i(:,idx)] = fourier_utils.dft1D(profile_r, profile_i, shift); %DFT do perfil [idx] atual
                end
            end
        end

        function [idft_r, idft_i] = im_idft1D(img_r, img_i, axis)
            %%--- Argumentos da função----------------------------------------
            %img_r: parte real da imagem que se deseja aplicar a dft
            %img_i: parte imaginária da imagem que se deseja aplicar a dft
            %axis: define se serão tratadas linhas ou colunas
            %retorna: parte real e imaginária do espectro do sinal
            %-----------------------------------------------------------------
            %Verifica o argumento axis
            if (axis > 2) || (axis < 1)
                error('[fourier_utils.im_dft1D] Axis deve ter valor 1 ou 2!')
            end

            img_r = double(img_r); %converte a imagem real para double
            img_i = double(img_i); %converte a imagem imaginária para double
            N = size(img_r,axis); %número total de amostras do eixo processado
            [i,j] = size(img_r); %tamanho da imagem
            idft_r = zeros(i,j); %vetor para armazenar os valores reais do espectro
            idft_i = zeros(i,j); %vetor para armazenar os valores imaginários do espectro
            for idx = 1:N %índice das frequências
                %Define o perfil para aplicar a dft
                if axis == 1
                    profile_r = img_r(idx,:); %processa a linha atual na parte real
                    profile_i = img_i(idx,:); %parte imaginária é zero
                    [idft_r(idx,:), idft_i(idx,:)] = fourier_utils.idft1D(profile_r, profile_i); %DFT do perfil [idx] atual
                elseif axis == 2
                    profile_r = img_r(:,idx); %processa a coluna atual na parte real
                    profile_i = img_i(:,idx); %parte imaginária é zero
                    [idft_r(:,idx), idft_i(:,idx)] = fourier_utils.idft1D(profile_r, profile_i); %DFT do perfil [idx] atual
                end
            end
        end
        
        function [dft_r, dft_i] = im_dft2D(img, varargin)
            %%--- Argumentos da função----------------------------------------
            %img: imagem que se deseja aplicar a dft
            %varargin: flag para realizar fft shift ou não (variável opcional, true por defeito)
            %retorna: parte real e imaginária do espectro 2D do sinal
            %----------------------------------------------------------------- 
            %Acessa o argumento opcional para definir o valor de sigma
            if ~isempty(varargin)
                shift = varargin{1}; %define shift como o argumento passado na função
            else
                shift = true;
            end

            img = double(img); %converte imagem para double
            [dft_ri, dft_ii] = fourier_utils.im_dft1D(img, zeros(size(img)), 1, shift); %DFT das linhas
            [dft_r, dft_i] = fourier_utils.im_dft1D(dft_ri, dft_ii, 2, shift); %DFT das colunas
        end

        function [idft_r, idft_i] = im_idft2D(img_r, img_i)
            %%--- Argumentos da função----------------------------------------
            %img_r: parte real da imagem que se deseja aplicar a dft
            %img_i: parte imaginária da imagem que se deseja aplicar a dft
            %retorna: parte real e imaginária do espectro 2D do sinal
            %----------------------------------------------------------------- 
            img_r = double(img_r); %converte imagem real para double
            img_i = double(img_i); %converte imagem imaginária para double
            [idft_ri, idft_ii] = fourier_utils.im_idft1D(img_r, img_i, 1); %DFT das linhas
            [idft_r, idft_i] = fourier_utils.im_idft1D(idft_ri, idft_ii, 2); %DFT das colunas
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

        function [delta_i, delta_j, cps] = phase_correlation(img_ref, img_disp)
            %%--- Argumentos da função----------------------------------------
            %img_disp: imagem deslocada em relação a referência
            %img_ref: imagem de referÊncia não deslocada
            %retorna:deslocamento em pixel no eixo y e x + idft do cross power spectrum
            %-----------------------------------------------------------------
            %suaviza as duas imagens com uma gaussiana
            [dft_disp_r, dft_disp_i] = fourier_utils.im_dft2D(img_disp, false); %dft sem shift imagem deslocada
            dft_disp = dft_disp_r + 1i*(dft_disp_i); %composição real e imaginária
            [dft_ref_r, dft_ref_i] = fourier_utils.im_dft2D(img_ref, false); %dft sem shift imagem referência
            dft_ref = dft_ref_r + 1i*(dft_ref_i); %composição real e imaginária
            cps = fourier_utils.cross_power_spectrum(dft_ref, dft_disp); %cross power spectrum
            [icps_r, icps_i] = fourier_utils.im_idft2D(cps, zeros(size(cps))); %dft inversa do cps
            icps = sqrt(icps_r.^2+icps_i.^2); %magnitude
            [maxs_icps,idx_max] = max(icps); 
            [~,delta_j] = max(maxs_icps); %deslocamento no eixo x
            delta_i = idx_max(delta_j); %deslocamento no eixo y 
            delta_j = delta_j - 1; %compensa pelo one-based
            delta_i = delta_i - 1; %compensa pelo one-based
        end

        function cross_power = cross_power_spectrum(img_ref, img_disp)
            %%--- Argumentos da função----------------------------------------
            %img_ref: parte real e imaginária da imagem de referência
            %img_disp: parte real e imaginária da imagem deslocada
            %retorna: retorna o valor do cross power spectrum
            %-----------------------------------------------------------------
            cross_power = img_ref.*conj(img_disp); %multiplicação ponto-a-ponto (Hadamard)
            norm = abs(img_ref.*conj(img_disp)); %normalização ponto-a-ponto
            cross_power = cross_power./norm; %cross power spectrum 
        end

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
            
            elseif strcmp(type, 'gaussian_x')
                %Acessa o argumento opcional para definir o valor de sigma
                if ~isempty(varargin)
                    sigma = varargin{1}; %define sigma como o argumento passado na função
                else
                    error('[fourier_utils.mascara_conv] Valor de sigma deve ser passado como argumento!')
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
                    error('[atv04_utils.mascara_conv] Valor de sigma deve ser passado como argumento!')
                end
                
                %Gaussiana
                Y = -floor(mask_size(1)/2):floor(mask_size(1)/2); %define todos os pontos Y compõem o vetor do kernel gaussiano 
                sigma_sqr = double(sigma^2); %eleva o sigma ao quadrado para facilitar o cálculo do valor da gaussiana
                mask = (1/(2*pi*sigma_sqr))*exp(-Y.^2/(2*sigma_sqr)); %equação da gaussiana 1D
                mask = mask/sum(mask(:)); %normaliza em relação a soma para garantir que a soma do vetor é igual a 1
                mask = mask'; %retorna transpoto para a operação g_x*g_y' ser válida
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
                error('[fourier_utils.generate_mask] Tipo de filtro ' + string(tipo) + ' não aceito para gerar a máscara')
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
                [img_zp, pad] = fourier_utils.zero_padding(img, size(mask,1)); %nova matriz que contém as bordas tratadas com zero padding
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
                [img_zp, pad] = fourier_utils.zero_padding(img, size(mask,1)); %nova matriz que contém as bordas tratadas com zero padding
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

    end
end