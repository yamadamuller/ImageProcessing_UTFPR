clc, clear, close all;

addpath('..\'); %adiciona diretório anterior para ter acesso à classe de funções

dft_img = imread('cameraman.tif'); %lê a imagem que será aplicada a DFT 2D

%DFT IP_UTFPR
[dft_IP_r, dft_IP_i] = fourier_utils.im_dft2D(dft_img); %aplica a DFT 2D
dft_IP = sqrt(dft_IP_r.^2+dft_IP_i.^2); %magnitude da dft

%plot
figure(1)
subplot(1,2,1)
imshow(dft_img)
title('Imagem de entrada')
subplot(1,2,2)
imshow(fourier_utils.autocontrast(log(dft_IP+1e-4)))
title('DFT 2D IP\_UTFPR')
