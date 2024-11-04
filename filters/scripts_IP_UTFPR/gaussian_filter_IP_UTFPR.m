clc, clear, close all

addpath('..\images') %adiciona o diretório anterior no caminho para acessar a classe de funções e as imagens
addpath('..\')

gauss_img = imread("b5s.40.bmp"); %lê a imagem que será aplicada o filtro gaussiano
gauss_img = double(gauss_img); %converte para double

%Gaussian filtering -> smoothing
sigma = 1; %desvio padrão da máscara gaussiana
tam_gauss = [5 5]; %tamanho da máscara de convolução

gauss_IP_UTFPR = linear_filters_utils.generate_mask(tam_gauss, 'gaussian', sigma); %máscara de convolução para gaussiano na unha
gauss_filt_IP = linear_filters_utils.convolve2D(gauss_img, gauss_IP_UTFPR, 'padding'); %operação de convolução entre img e máscara na unha
gauss_filt_IP = uint8(gauss_filt_IP); %converte para uint8

%plot
figure(2)
subplot(1,2,1)
imshow(uint8(gauss_img))
title('Original Image')
subplot(1,2,2)
imshow(im2uint8(gauss_filt_IP))
title('Gaussian filtering IP\_UTFPR')
