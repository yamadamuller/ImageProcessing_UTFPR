classdef morphological_utils
    methods (Static)
        function dilat_img = morph_dilation(bw_img, se, op_plot, varargin)
            %%--- Argumentos da função----------------------------------------
            %bw_img: a matriz da imagem binária que se deseja aplicar a dilatação
            %se: a matriz do elemento estruturante
            %op_plot: plot de qual pixel está sendo operado no instante
            %varargin: variável opcional que define o tratamento das bordas
            %retorna: a matriz da dilatação entre a imagem e elemento estruturante
            %-----------------------------------------------------------------
            %Acessa o argumento opcional para definir o tratamento da borda
            if ~isempty(varargin)
                borda = varargin{1}; %define borda como o argumento passado na função
            else
                borda = 'padding'; %por defeito o tratamento é zero padding então
            end

            if strcmp(borda, 'padding')
                even_flag = false; %flag para minitorar se o se tem tamanho par ou impar
                if rem(size(se,1),2) > 0
                    [img_zp, pad] = morphological_utils.zero_padding(bw_img, size(se,1)); %nova matriz que contém as bordas tratadas com zero padding
                    pad = [pad pad/2]; %vetor para armazenar pad original e potencialmente manipulado
                else
                    [img_zp, pad] = morphological_utils.zero_padding(bw_img, size(se,1)+1); %nova matriz que contém as bordas tratadas com zero padding
                    pad = [pad-0.5 pad-0.5]; %compensa por uma matriz de tamanho par no segundo elemento
                    even_flag = true;
                end
                %operação de dilatação
                dilat_img = zeros(size(img_zp)); %a matriz da dilatação deve ter o tamanho da original
                plot_zp = img_zp;
                %pixels da imagem original que serão tratados
                pxl_i = size(bw_img,1); %linha
                pxl_j = size(bw_img,2); %coluna
                for i = 1:pxl_i
                    for j = 1:pxl_j
                        %pixels na matriz com zero padding que contemplam a operação atual
                        sub_idx_i = i:i+2*pad(1); %linha
                        sub_idx_j = j:j+2*pad(1); %coluna
                        sub_mtx = img_zp(sub_idx_i,sub_idx_j).*se; %produtos por elemento entre a submatriz e o elemento estruturante
                        if sub_mtx(1+2*pad(2),1+2*pad(2)) == 1
                            if even_flag
                                past_dilat = dilat_img(sub_idx_i+2*pad(2),sub_idx_j+2*pad(2)); %registra a parte q sofrerá dilatação antes da operação
                                check_sub = se + past_dilat; %verifica se algum pixel anteriormente sofreu subsituição por zero
                                dilat_img(sub_idx_i+2*pad(2),sub_idx_j+2*pad(2)) = logical(check_sub); %se SE encontra 1 -> adição do SE na imagem de saída
                            else
                                past_dilat = dilat_img(sub_idx_i,sub_idx_j); %registra a parte q sofrerá dilatação antes da operação 
                                check_sub = se + past_dilat; %verifica se algum pixel anteriormente sofreu subsituição por zero
                                dilat_img(sub_idx_i,sub_idx_j) = logical(check_sub); %se SE encontra 1 -> adição do SE na imagem de saída
                            end
                        end
                        
                        if op_plot
                            subplot(1,3,1)
                            imshow(img_zp, InitialMagnification='fit')
                            title('Imagem original')
                            subplot(1,3,2)
                            plot_zp(i+2*pad(2),j+2*pad(2)) = 0.5;
                            imshow(plot_zp, InitialMagnification='fit')
                            title('Pixel atual')
                            subplot(1,3,3)
                            imshow(dilat_img, InitialMagnification='fit')
                            title('Dilatação atual')
                            pause(0.1)
                        end

                    end
                end

                %filtra os pixels de dentro da borda tratada
                Y_valid = 1+2*pad(2):size(dilat_img,1)-2*pad(2); %linha
                X_valid = 1+2*pad(2):size(dilat_img,2)-2*pad(2); %coluna
                dilat_img = dilat_img(Y_valid, X_valid); %retorna apenas os pixels sem tratamento de borda
                dilat_img = logical(dilat_img); %converte para logical
            else
                error('[morphological_utils.morph_dilation] Operações sem zero padding ainda não estão disponíveis')
            end
        end

        function dilat_img = morph_erosion(bw_img, se, op_plot, varargin)
            %%--- Argumentos da função----------------------------------------
            %bw_img: a matriz da imagem binária que se deseja aplicar a erosão
            %se: a matriz do elemento estruturante
            %op_plot: plot de qual pixel está sendo operado no instante
            %varargin: variável opcional que define o tratamento das bordas
            %retorna: a matriz da erosão entre a imagem e elemento estruturante
            %-----------------------------------------------------------------
            %Acessa o argumento opcional para definir o tratamento da borda
            if ~isempty(varargin)
                borda = varargin{1}; %define borda como o argumento passado na função
            else
                borda = 'padding'; %por defeito o tratamento é zero padding então
            end

            if strcmp(borda, 'padding')
                even_flag = false; %flag para minitorar se o se tem tamanho par ou impar
                if rem(size(se,1),2) > 0
                    [img_zp, pad] = morphological_utils.zero_padding(bw_img, size(se,1)); %nova matriz que contém as bordas tratadas com zero padding
                    pad = [pad pad/2]; %vetor para armazenar pad original e potencialmente manipulado
                else
                    [img_zp, pad] = morphological_utils.zero_padding(bw_img, size(se,1)+1); %nova matriz que contém as bordas tratadas com zero padding
                    pad = [pad-0.5 pad-0.5]; %compensa por uma matriz de tamanho par no segundo elemento
                    even_flag = true; %comuta a flag de tamanho par
                end
                %operação de dilatação
                dilat_img = img_zp; %a matriz da dilatação deve inicializar iguala original
                plot_zp = img_zp;
                %pixels da imagem original que serão tratados
                pxl_i = size(bw_img,1); %linha
                pxl_j = size(bw_img,2); %coluna
                for i = 1:pxl_i
                    for j = 1:pxl_j
                        %pixels na matriz com zero padding que contemplam a operação atual
                        sub_idx_i = i:i+2*pad(1); %linha
                        sub_idx_j = j:j+2*pad(1); %coluna
                        sub_mtx = img_zp(sub_idx_i,sub_idx_j).*se; %produtos por elemento entre a submatriz e o elemento estruturante
                        if sub_mtx(1+2*pad(2),1+2*pad(2)) == 1
                            %verifica quais elementos se encontram dentro do objeto
                            if even_flag
                                check_mtx = img_zp(sub_idx_i+2*pad(2),sub_idx_j+2*pad(2));
                            else
                                check_mtx = sub_mtx;
                            end

                            idx_se = sub2ind(size(se), find(se == 1)); %índices válidos do se
                            if ~all(check_mtx(idx_se) == 1)
                                dilat_img(i+2*pad(2),j+2*pad(2)) = 0; %se SE encontra 1 mas não estiver completamente dentro do objeto -> elimina o hotspot
                            end
                        end
                        
                        if op_plot
                            subplot(1,3,1)
                            imshow(img_zp, InitialMagnification='fit')
                            title('Imagem original')
                            subplot(1,3,2)
                            plot_zp(i+2*pad(2),j+2*pad(2)) = 0.5;
                            imshow(plot_zp, InitialMagnification='fit')
                            title('Pixel atual')
                            subplot(1,3,3)
                            imshow(dilat_img, InitialMagnification='fit')
                            title('Erosão atual')
                            pause(0.1)
                        end

                    end
                end

                %filtra os pixels de dentro da borda tratada
                Y_valid = 1+2*pad(2):size(dilat_img,1)-2*pad(2); %linha
                X_valid = 1+2*pad(2):size(dilat_img,2)-2*pad(2); %coluna
                dilat_img = dilat_img(Y_valid, X_valid); %retorna apenas os pixels sem tratamento de borda
                dilat_img = logical(dilat_img); %converte para logical
            else
                error('[morphological_utils.morph_dilation] Operações sem zero padding ainda não estão disponíveis')
            end
        end
        
        function close_img = morph_closing(bw_img, se, varargin)
            %%--- Argumentos da função----------------------------------------
            %bw_img: a matriz da imagem binária que se deseja aplicar o fechamento
            %se: a matriz do elemento estruturante
            %varargin: variável opcional que define o tratamento das bordas
            %retorna: a matriz do fechamento entre a imagem e elemento estruturante
            %-----------------------------------------------------------------
            %Acessa o argumento opcional para definir o tratamento da borda
            if ~isempty(varargin)
                borda = varargin{1}; %define borda como o argumento passado na função
            else
                borda = 'padding'; %por defeito o tratamento é zero padding então
            end

            if strcmp(borda, 'padding')
                dilat_img = morphological_utils.morph_dilation(bw_img, se, false); %operação de dilatação
                close_img = morphological_utils.morph_erosion(dilat_img, se, false); %erosão na imagem dilatada
            else
                error('[morphological_utils.morph_dilation] Operações sem zero padding ainda não estão disponíveis')
            end
        end

        function close_img = morph_opening(bw_img, se, varargin)
            %%--- Argumentos da função----------------------------------------
            %bw_img: a matriz da imagem binária que se deseja aplicar a abertura
            %se: a matriz do elemento estruturante
            %varargin: variável opcional que define o tratamento das bordas
            %retorna: a matriz da abertura entre a imagem e elemento estruturante
            %-----------------------------------------------------------------
            %Acessa o argumento opcional para definir o tratamento da borda
            if ~isempty(varargin)
                borda = varargin{1}; %define borda como o argumento passado na função
            else
                borda = 'padding'; %por defeito o tratamento é zero padding então
            end

            if strcmp(borda, 'padding')
                dilat_img = morphological_utils.morph_erosion(bw_img, se, false); %operação de erosão
                close_img = morphological_utils.morph_dilation(dilat_img, se, false); %dilatação na imagem erodida
            else
                error('[morphological_utils.morph_dilation] Operações sem zero padding ainda não estão disponíveis')
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