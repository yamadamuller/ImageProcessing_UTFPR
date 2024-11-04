clc, clear, close all

addpath('..\images') %adiciona o diretório anterior no caminho para acessar a classe de funções e as imagens
addpath('..\')

box_img = imread("b5s.40.bmp"); %lê a imagem que será aplicada o filtro da média
box_img = double(box_img); %converte para double

%Box filtering -> smoothing
tam_box = [5 5]; %tamanho da máscara de convolução

box_IP_UTFPR = linear_filters_utils.generate_mask(tam_box, 'box'); %máscara de convolução para box na unha
box_filt_IP = linear_filters_utils.convolve2D(box_img, box_IP_UTFPR, 'padding'); %operação de convolução entre img e máscara na unha
box_filt_IP = uint8(box_filt_IP); %converte para uint8

%plot
figure(2)
subplot(1,2,1)
imshow(uint8(box_img))
title('Original Image')
subplot(1,2,2)
imshow(im2uint8(box_filt_IP))
title('Box-filtering IP\_UTFPR')