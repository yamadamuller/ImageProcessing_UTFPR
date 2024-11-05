classdef IQM_utils
    methods (Static)
        function im_mse = MSE(ref_img, img)
            %%--- Argumentos da função----------------------------------------
            %ref_img: a imagem de referência
            %img: a imagem que se deseja computar a métrica em relação a referência
            %retorna: erro quadrático médio entre a imagem e a referência
            %-----------------------------------------------------------------
            ref_img = double(ref_img); %converte para double
            img = double(img); %converte para double
            sqr_err = (ref_img(:) - img(:)).^2; %erro quadrático entre cada pixel
            im_mse = sum(sqr_err)/numel(img); %MSE = (sum(y-y')^2)/N
        end

        function im_psnr = PSNR(ref_img, img, varargin)
            %%--- Argumentos da função----------------------------------------
            %ref_img: a imagem de referência
            %img: a imagem que se deseja computar a métrica em relação a referência
            %varargin: argumento opcional que define o valor máximo do pixel dado o formato da imagem
            %retorna: peak signal-to-noise ratio entre a imagem e a referência
            %-----------------------------------------------------------------
            %Acessa o argumento opcional para definir o tipo da imagem
            if ~isempty(varargin)
                pixel_type = varargin{1}; %define borda como o argumento passado na função
            else
                pixel_type = 'uint8'; %por defeito o tipoe é uint8
            end

            ref_img = double(ref_img); %converte para double
            img = double(img); %converte para double
            im_rmse = sqrt(IQM_utils.MSE(ref_img, img)); %raíz quadrada do erro quadrático médio 
            L = double(intmax(pixel_type)); %o valor máximo dado o tipo do pixel
            im_psnr = 20*log10(L/im_rmse); %Peak Signal-to-Noise ratio em dB
        end
        
        function im_ssim = SSIM_full(ref_img, img, varargin)
            %%--- Argumentos da função----------------------------------------
            %ref_img: a imagem de referência
            %img: a imagem que se deseja computar a métrica em relação a referência
            %varargin: argumento opcional que define o valor máximo do pixel dado o formato da imagem
            %retorna: Structural Similarity Index entre a imagem e a
            %referência com as contribuições individuais da luminância, contraste e estrutura
            %-----------------------------------------------------------------
            %[1] - Z. Wang, A. C. Bovik, H. R. Sheikh and E. P. Simoncelli, 
            %"Image quality assessment: From error visibility to structural similarity," 
            %IEEE Transactions on Image Processing, vol. 13, no. 4, pp. 600-612, Apr. 2004.
            %Acessa o argumento opcional para definir o tipo da imagem
            if ~isempty(varargin)
                pixel_type = varargin{1}; %define borda como o argumento passado na função
            else
                pixel_type = 'uint8'; %por defeito o tipoe é uint8
            end

            ref_img = double(ref_img); %converte para double
            img = double(img); %converte para double
            janela = linear_filters_utils.generate_mask([11 11], 'gaussian', 1.5); %máscara para as operações com sigma 1.5

            %Define constantes que evitam instabilidade
            L = double(intmax(pixel_type)); %valor máximo possível dado o tipo da imagem
            K = [0.01, 0.03]; %constantes padrão
            C1 = double((K(1)*L)^2); %evita instabilidade no cálculo da luminance
            C2 = double((K(2)*L)^2); %evita instabilidade no cálculo do contrast
            C3 = double(C2/2); %evita instabilidade no cálculo da structure

            %Calcula o SSIM com base na equação geral de [1]
            %A convolução com a máscara só leva em consideração pixels que
            %não necessitam tratamento de bordas
            
            %Luminância
            mean_x = linear_filters_utils.convolve2D(ref_img, janela, 'valid'); %média da referência
            mean_x_sqr = mean_x.*mean_x; %multiplicação ponto a ponto dos elementos
            mean_y = linear_filters_utils.convolve2D(img, janela, 'valid'); %média da imagem 
            mean_y_sqr = mean_y.*mean_y; %multiplicação ponto a ponto dos elementos
            l_num = 2*mean_x.*mean_y + C1;
            l_den = mean_x_sqr + mean_y_sqr + C1;
            l = l_num./l_den;

            %Contraste
            std_x = linear_filters_utils.convolve2D(ref_img.*ref_img, janela, 'valid') - mean_x; %desvio padrão da referência
            std_y = linear_filters_utils.convolve2D(img.*img, janela, 'valid') - mean_y; %desvio padrão da imagem
            std_x_sqr = linear_filters_utils.convolve2D(ref_img.*ref_img, janela, 'valid') - mean_x_sqr; %variância da referência
            std_y_sqr = linear_filters_utils.convolve2D(img.*img, janela, 'valid') - mean_y_sqr; %variância da imagem
            c_num = 2*std_x.*std_y + C2;
            c_den = std_x_sqr + std_y_sqr + C2;
            c = c_num./c_den;
            
            %Estutura
            std_xy = linear_filters_utils.convolve2D(ref_img.*img, janela, 'valid') - (mean_x.*mean_y); %covariância entre as imagens
            s_num = std_xy + C3;
            s_den = std_x.*std_y + C3;
            s = s_num./s_den;

            %SSIM = l(x,y) . c(x,y) . s(x,y)
            SSIM = l.*c.*s;
            im_ssim = mean(SSIM(:)); %Na prática, a métrica utilizada é o MSSIM (Mean Structural Similarity Index)
        end

        function im_ssim = SSIM(ref_img, img, varargin)
            %%--- Argumentos da função----------------------------------------
            %ref_img: a imagem de referência
            %img: a imagem que se deseja computar a métrica em relação a referência
            %varargin: argumento opcional que define o valor máximo do pixel dado o formato da imagem
            %retorna: Structural Similarity Index entre a imagem e a referência com a equação geral
            %-----------------------------------------------------------------
            %[1] - Z. Wang, A. C. Bovik, H. R. Sheikh and E. P. Simoncelli, 
            %"Image quality assessment: From error visibility to structural similarity," 
            %IEEE Transactions on Image Processing, vol. 13, no. 4, pp. 600-612, Apr. 2004.
            %Acessa o argumento opcional para definir o tipo da imagem
            if ~isempty(varargin)
                pixel_type = varargin{1}; %define borda como o argumento passado na função
            else
                pixel_type = 'uint8'; %por defeito o tipoe é uint8
            end

            ref_img = double(ref_img); %converte para double
            img = double(img); %converte para double
            janela = linear_filters_utils.generate_mask([11 11], 'gaussian', 1.5); %máscara para as operações com sigma 1.5

            %Define constantes que evitam instabilidade
            L = double(intmax(pixel_type)); %valor máximo possível dado o tipo da imagem
            K = [0.01, 0.03]; %constantes padrão
            C1 = double((K(1)*L)^2); %evita instabilidade no cálculo da luminance
            C2 = double((K(2)*L)^2); %evita instabilidade no cálculo do contrast
            C3 = double(C2/2); %evita instabilidade no cálculo da structure

            %Calcula o SSIM com base na equação geral de [1]
            %A convolução com a máscara só leva em consideração pixels que
            %não necessitam tratamento de bordas
            mean_x = linear_filters_utils.convolve2D(ref_img, janela, 'valid'); %média da referência
            mean_x_sqr = mean_x.*mean_x; %multiplicação ponto a ponto dos elementos
            mean_y = linear_filters_utils.convolve2D(img, janela, 'valid'); %média da imagem 
            mean_y_sqr = mean_y.*mean_y; %multiplicação ponto a ponto dos elementos
            std_x_sqr = linear_filters_utils.convolve2D(ref_img.*ref_img, janela, 'valid') - mean_x_sqr; %variância da referência
            std_y_sqr = linear_filters_utils.convolve2D(img.*img, janela, 'valid') - mean_y_sqr; %variância da imagem
            std_xy = linear_filters_utils.convolve2D(ref_img.*img, janela, 'valid') - (mean_x.*mean_y); %covariância entre as imagens
            
            %SSIM = [(2.mu_x.mu_y + C1).(2sigma_xy + C2)]/[(mu_x^2 + mu_y^2 + C1).(sigma_x^2 + sigma_y^2 + C2)]
            SSIM_num = (2*mean_x.*mean_y + C1).*(2*std_xy + C2);
            SSIM_den = (mean_x_sqr + mean_y_sqr + C1).*(std_x_sqr + std_y_sqr + C2);
            SSIM = SSIM_num./SSIM_den;
            im_ssim = mean(SSIM(:)); %Na prática, a métrica utilizada é o MSSIM (Mean Structural Similarity Index)
        end
    end
end