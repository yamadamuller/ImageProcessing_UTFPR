clc, clear, close all

addpath('..\images') %adiciona o diretório anterior no caminho para acessar a classe de funções e as imagens
addpath('..\')

bilat_img = imread('chicomm.jpg');
bilat_img = im2gray(im2double(bilat_img)); %converte para gray scale entre 0 e 1

dk_sigma = 3; %sigma do domain kernel
rk_sigma = 0.2; %sigma do range kernel
wk_s = 2*ceil(2*dk_sigma)+1; %tamanho do kernel

%IP_UTFPR
bilat_IP_UTFPR = edge_preserving_filters_utils.bilateral_filter(bilat_img, dk_sigma, rk_sigma, 'padding'); %c/ zero padding
domain_IP_UTFPR = linear_filters_utils.convolve2D(bilat_img, linear_filters_utils.generate_mask([wk_s wk_s], 'gaussian', dk_sigma), 'padding'); %apenas domain filtering
range_IP_UTFPR = edge_preserving_filters_utils.range_filter(bilat_img, dk_sigma, rk_sigma, 'padding'); %apenas range filtering

%Plots
figure(1)
subplot(2,2,1)
imshow(bilat_img)
title('Original Image')
subplot(2,2,2)
imshow(bilat_IP_UTFPR)
title('Bilateral IP\_UTFPR')
subplot(2,2,3)
imshow(domain_IP_UTFPR)
title('Gaussian filter IP\_UTFPR')
subplot(2,2,4)
imshow(range_IP_UTFPR)
title('Range filter IP\_UTFPR')
