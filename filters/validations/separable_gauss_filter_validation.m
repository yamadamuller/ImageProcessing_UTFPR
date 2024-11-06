clc, clear, close all

addpath('..\') %adiciona o diretório anterior no caminho para acessar a classe de funções e as imagens

gauss_img = imread('cameraman.tif');
gauss_img = double(gauss_img); %converte para double

%Filtro gaussiano normal IP_UTFPR
tam_gauss = [5 5];
gauss_IP_UTFPR = linear_filters_utils.generate_mask(tam_gauss, 'gaussian', 1); %máscara de convolução para gaussiano na unha
gauss_filt_IP = linear_filters_utils.convolve2D(gauss_img, gauss_IP_UTFPR, 'padding'); %operação de convolução entre img e máscara na unha
gauss_filt_IP = uint8(gauss_filt_IP); %converte para uint8

%Filtro gaussiano normal matlab
gauss_filt_matlab = imfilter(gauss_img, fspecial('gaussian', tam_gauss, 1));
gauss_filt_matlab = uint8(gauss_filt_matlab); %converte para uint8

%Filtro gaussiano separável
gauss_mask_x = linear_filters_utils.generate_mask([5], 'gaussian_x', 1); %máscara de convolução eixo x para gauss. sep. na unha
gauss_mask_y = linear_filters_utils.generate_mask([5], 'gaussian_y', 1); %máscara de convolução eixo y para gauss. sep. na unha
sep_gauss_filt_IP = linear_filters_utils.separable_convolve2D(gauss_img, gauss_mask_x, gauss_mask_y, 'padding'); %(I*Hx)*Hy
sep_gauss_filt_IP = uint8(sep_gauss_filt_IP); %converte para uint8

%verifica se são iguais
sep_gauss_igual_IP = sum(sep_gauss_filt_IP(:)-gauss_filt_IP(:)); 
sep_gauss_igual_matlab = sum(sep_gauss_filt_IP(:)-gauss_filt_matlab(:)); 

%plot
figure(1)
subplot(1,3,1)
imshow(uint8(gauss_img))
title('Original Image')
subplot(1,3,2)
imshow(im2uint8(gauss_filt_IP))
title('"Regular" box filtering')
subplot(1,3,3)
imshow(im2uint8(sep_gauss_filt_IP))
title('Separable box filtering')
