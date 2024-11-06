clc, clear, close all

addpath('..\') %adiciona o diretório anterior no caminho para acessar a classe de funções e as imagens

box_img = imread('cameraman.tif');
box_img = double(box_img); %converte para double

%Box-filter normal IP_UTFPR
tam_box = [5 5];
box_IP_UTFPR = linear_filters_utils.generate_mask(tam_box, 'box'); %máscara de convolução para box na unha
box_filt_IP = linear_filters_utils.convolve2D(box_img, box_IP_UTFPR, 'padding'); %operação de convolução entre img e máscara na unha
box_filt_IP = uint8(box_filt_IP); %converte para uint8

%Box-filter normal matlab
box_filt_matlab = imfilter(box_img, fspecial('average', tam_box));
box_filt_matlab = uint8(box_filt_matlab); %converte para uint8

%Box filter separável
box_mask_x = linear_filters_utils.generate_mask([5], 'box_x'); %máscara de convolução eixo x para box sep. na unha
box_mask_y = linear_filters_utils.generate_mask([5], 'box_y'); %máscara de convolução eixo y para box sep. na unha
sep_box_filt_IP = linear_filters_utils.separable_convolve2D(box_img, box_mask_x, box_mask_y, 'padding'); %(I*Hx)*Hy
sep_box_filt_IP = uint8(sep_box_filt_IP); %converte para uint8

%verifica se são iguais
sep_box_igual_IP = sum(sep_box_filt_IP(:)-box_filt_IP(:)); 
sep_box_igual_matlab = sum(sep_box_filt_IP(:)-box_filt_matlab(:)); 

%plot
figure(1)
subplot(1,3,1)
imshow(uint8(box_img))
title('Original Image')
subplot(1,3,2)
imshow(im2uint8(box_filt_IP))
title('"Regular" box filtering')
subplot(1,3,3)
imshow(im2uint8(sep_box_filt_IP))
title('Separable box filtering')
