classdef imenhancement_utils
    methods (Static)
        function im_neg = transf_negative(image)
            %%--- Argumentos da função----------------------------------------
            %image: a imagem que se deseja obter o negativo
            %retorna: a imagem com a função de transformação que obtém o negativo
            %-----------------------------------------------------------------
            image = im2uint8(image); %converte para uint8 para garatir pixels entre 0 e 255
            idx = double(image) + 1; %converte para double e adiciona 1 para indexar 
            T = uint8(255:-1:0); %função de transformação para cada pixel
            im_neg = T(idx); %aplica a transformação para cada pixel via indexação
            im_neg = im2uint8(im_neg); %converte para uint8
        end

        function im_log = transf_log(image, varargin)
            %%--- Argumentos da função----------------------------------------
            %image: a imagem que se deseja aplicar a função de transformação log
            %varargin: argumento opcional do "ganho" (c) -> s = c.log(1+r)
            %retorna: a imagem com a função de transformação log
            %-----------------------------------------------------------------
            %Acessa o argumento opcional para definir o valor de c
            if ~isempty(varargin)
                c = varargin{1}; %define sigma como o argumento passado na função
            else
                c = 1; %valor por padrão é 1
            end

            image = im2uint8(image); %converte para uint8 para garatir pixels entre 0 e 255
            T_log = c*log(1:1000); %função do logarítmo neperiano mutiplicada por c
            im_log = T_log(image+1); %usa os valores da imagem como índices
            im_log = im2uint8(im_log); %converte para uint8
        end

        function im_gamma = transf_gamma(image, gamma, varargin)
            %%--- Argumentos da função----------------------------------------
            %image: a imagem que se deseja aplicar a função de transformação gamma
            %varargin: argumento opcional do "ganho" (c) -> s = c.r^gamma
            %retorna: a imagem com a função de transformação gamma
            %-----------------------------------------------------------------
            %Acessa o argumento opcional para definir o valor de c
            if ~isempty(varargin)
                c = varargin{1}; %define sigma como o argumento passado na função
            else
                c = 1; %valor por padrão é 1
            end

            image = im2double(image); %converte para double para garatir ponto flutuante
            im_gamma = c*(image.^gamma); %s = c.r^(gamma)
            im_gamma = im2uint8(im_gamma); %converte para uint8 
        end

        function cs_idx = contrast_stretching(img, cs_func)
            %%--- Argumentos da função----------------------------------------
            %img: a matriz da imagem a ser processada
            %cs_func: vetor da função de transformação para o contrast stretching
            %retorna: a imagem com contrast stretching pela função "cs_func"
            %-----------------------------------------------------------------
            img = im2uint8(img); %converte a imagem para uint8
            img_idx = double(img) + 1; %converte para double para que cada pixel sirva de índice (matlab é one-based indexing)
            cs_idx = cs_func(img_idx); %mapeia cada pixel da imagem original com o valor respectivo da função 
            cs_idx = im2uint8(cs_idx); %converte a imagem processada para uint8
        end
        
        function y1n = uint8_sigmoide(slp, m)
            %%--- Argumentos da função----------------------------------------
            %slope: inclinação da sigmoide (derivada)
            %m: ponto de inflexão da sigmoide 
            %retorna: vetor com os valores para a sigmoide uint8
            %-----------------------------------------------------------------
            x = 0:1:255; %define os valores de x sendo de 0 a 255
            y1 = 1./(1 + exp(-slp*(x - m))); %calcula a sigmoid para os parâmetros slp e m
            y1n = imenhancement_utils.autocontrast(y1); %autocontraste: normaliza para ter valores em toda a escala de cinza 
            y1n = uint8(y1n.*255); %converte para uint8 os valores de 0 a 1 da sigmoide (mesma coisa que "tim2uin8()")
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

        function eq_img = im_histogram_eq(img)
            %%--- Argumentos da função----------------------------------------
            %img: a matriz da imagem que se deseja equalizar o histograma
            %retorna: imagem com o histograma equalizado
            %-----------------------------------------------------------------
            hist_img = atv03_utils.img_histograma_iter(img); %histograma da imagem
            hist_img_n = double(hist_img)./(numel(img)); %histograma normalizado
            cdf = cumsum(hist_img_n); %soma cumulativa do histograma normalizado
            cdf = im2uint8(cdf); %converter para uint8
            eq_img = atv03_utils.aplica_cs_lut(img, cdf); %contrast stretching pela cdf
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
