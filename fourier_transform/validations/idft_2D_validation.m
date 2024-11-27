clc, clear, close all;

addpath('..\'); %adiciona diretório anterior para ter acesso à classe de funções

dft_img = imread('cameraman.tif'); %lê a imagem que será aplicada a DFT 2D

%DFT IP_UTFPR
[dft_IP_r, dft_IP_i] = fourier_utils.im_dft2D(dft_img, false); %aplica a DFT 2D
dft_IP = sqrt(dft_IP_r.^2+dft_IP_i.^2); %magnitude da dft

%iDFT IP_UTFPR
[idft_IP_r, idft_IP_i] = fourier_utils.im_idft2D(dft_IP_r, dft_IP_i);
idft_IP = sqrt(idft_IP_r.^2+idft_IP_i.^2); %magnitude da dft
idft_IP = uint8(idft_IP/numel(idft_IP)); %normaliza e converte para uint8

%verifica se são iguais
idft_igual = sum(idft_IP(:)-dft_img(:));

%plot
figure(1)
subplot(1,3,1)
imshow(dft_img)
title('Imagem de entrada')
subplot(1,3,2)
imshow(fourier_utils.autocontrast(log(fftshift(dft_IP)+1e-4)))
title('DFT 2D IP\_UTFPR')
subplot(1,3,3)
imshow(idft_IP)
title('iDFT 2D IP\_UTFPR')