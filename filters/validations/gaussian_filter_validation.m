clc, clear, close all

addpath('..\images') %adiciona o diretório anterior no caminho para acessar a classe de funções e as imagens
addpath('..\')

gauss_img = imread("b5s.40.bmp"); %lê a imagem que será aplicada o filtro gaussiano

%Gaussian filtering -> smoothing
sigma = 1; %desvio padrão da máscara gaussiana
tam_gauss = [5 5]; %tamanho da máscara de convolução

gauss_IP_UTFPR = linear_filters_utils.generate_mask(tam_gauss, 'gaussian', sigma); %máscara de convolução para gaussiano na unha
gauss_filt_IP = linear_filters_utils.convolve2D(gauss_img, gauss_IP_UTFPR, 'padding'); %operação de convolução entre img e máscara na unha

gauss_matlab = fspecial('gaussian', tam_gauss, sigma); %máscara de convolução para gaussiano nativa
gauss_filt_matlab = imfilter(gauss_img, gauss_matlab); %operação de convolução entre img e máscara nativa

gauss_filt_igual = sum(gauss_filt_IP(:)-gauss_filt_matlab(:)); %verifica se efetivamente são iguais

%plot
figure(2)
subplot(1,3,1)
imshow(im2uint8(gauss_img))
title('Original Image')
subplot(1,3,2)
imshow(im2uint8(gauss_filt_matlab))
title('Gaussian filtering matlab')
subplot(1,3,3)
imshow(im2uint8(gauss_filt_IP))
title('Gaussian filtering IP\_UTFPR')
