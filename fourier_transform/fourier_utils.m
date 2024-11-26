classdef fourier_utils
    methods (Static)
        function [dft_r, dft_i] = dft1D(signal_r, signal_i)
            %%--- Argumentos da função----------------------------------------
            %signal_r: parte real do sinal
            %signal_i: parte imaginária do sinal
            %t: amostras do tempo discreto
            %fs: frequência de amostragem
            %retorna: parte real e imaginária do espectro do sinal
            %-----------------------------------------------------------------
            %Transpõe os sinais se necessário dado o shape
            if size(signal_r,1) > 1
                signal_r = signal_r';
                signal_i = signal_i';
            end

            N = length(signal_r); %número total de amostras
            dft_r = zeros(N,1); %vetor para armazenar os valores reais do espectro
            dft_i = zeros(N,1); %vetor para armazenar os valores imaginários do espectro
            n = 0:length(signal_r)-1; %componentes da frequência para shift
            signal_r = signal_r.*(-1).^n; %fftshift na parte real
            signal_i = signal_i.*(-1).^n; %fftshift na parte imaginária
            for u = 1:N %índice das frequências
                n = 1:N; %vetor com índices das amostras
                theta = 2*pi*(u-1).*(n-1)/N; %theta = (2*pi*u/N)*(n-1)
                sum_r = signal_r.*cos(theta) + signal_i.*sin(theta); %parte real = fr[n]*cos(theta) + fi[n]*sen(theta)
                sum_i = -signal_r.*sin(theta) + signal_i.*cos(theta); %parte imaginária = j{-fr[n]*sen(theta) + fi[n]*cos(theta)}
                dft_r(u) = sum(sum_r(:)); %componente real da frequência u é a soma real
                dft_i(u) = sum(sum_i(:)); %componente imaginária da frequência u é a soma imaginária
            end
        end

        function [dft_r, dft_i] = im_dft1D(img_r, img_i, axis)
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
            dft_r = zeros(i,j); %vetor para armazenar os valores reais do espectro
            dft_i = zeros(i,j); %vetor para armazenar os valores imaginários do espectro
            for idx = 1:N %índice das frequências
                %Define o perfil para aplicar a dft
                if axis == 1
                    profile_r = img_r(idx,:); %processa a linha atual na parte real
                    profile_i = img_i(idx,:); %parte imaginária é zero
                    [dft_r(idx,:), dft_i(idx,:)] = fourier_utils.dft1D(profile_r, profile_i); %DFT do perfil [idx] atual
                elseif axis == 2
                    profile_r = img_r(:,idx); %processa a coluna atual na parte real
                    profile_i = img_i(:,idx); %parte imaginária é zero
                    [dft_r(:,idx), dft_i(:,idx)] = fourier_utils.dft1D(profile_r, profile_i); %DFT do perfil [idx] atual
                end
            end
        end
        
        function [dft_r, dft_i] = im_dft2D(img)
            %%--- Argumentos da função----------------------------------------
            %img: imagem que se deseja aplicar a dft
            %retorna: parte real e imaginária do espectro 2D do sinal
            %----------------------------------------------------------------- 
            img = double(img); %converte imagem para double
            [dft_ri, dft_ii] = fourier_utils.im_dft1D(img, zeros(size(img)),1); %DFT das linhas
            [dft_r, dft_i] = fourier_utils.im_dft1D(dft_ri, dft_ii,2); %DFT das colunas
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