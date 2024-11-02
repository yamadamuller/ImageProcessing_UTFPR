clc, clear, close all

addpath('..\images') %adiciona o diretório anterior no caminho para acessar a classe de funções e as imagens
addpath('..\')

box_img = imread("b5s.40.bmp"); %lê a imagem que será aplicada o filtro da média

%Box filtering -> smoothing
tam_box = [5 5]; %tamanho da máscara de convolução

box_IP_UTFPR = linear_filters_utils.generate_mask(tam_box, 'box'); %máscara de convolução para box na unha
box_filt_IP = linear_filters_utils.convolve2D(box_img, box_IP_UTFPR, 'padding'); %operação de convolução entre img e máscara na unha

box_matlab = fspecial('average', tam_box); %máscara de convolução para box-filter nativa
box_filt_matlab = imfilter(box_img, box_matlab); %operação de convolução entre img e máscara nativa

box_filt_igual = sum(box_filt_IP(:)-box_filt_matlab(:)); %verifica se efetivamente são iguais

%plot
figure(2)
subplot(1,3,1)
imshow(im2uint8(box_img))
title('Original Image')
subplot(1,3,2)
imshow(im2uint8(box_filt_matlab))
title('Box-filtering matlab')
subplot(1,3,3)
imshow(im2uint8(box_filt_IP))
title('Box-filtering IP\_UTFPR')
