clc, clear, close all;

addpath('..\'); %adiciona diretório anterior para ter acesso à classe de funções

dft_img = imread('cameraman.tif'); %lê a imagem que será aplicada a DFT 2D

%FFT 2D Matlab
dft_matlab = fft2(dft_img); %aplica a fft2D
dft_matlab = fftshift(dft_matlab); %shift nas frequências
dft_matlab = abs(dft_matlab); %magnitude da fft

%DFT IP_UTFPR
[dft_IP_r, dft_IP_i] = fourier_utils.im_dft2D(dft_img); %aplica a DFT 2D
dft_IP = sqrt(dft_IP_r.^2+dft_IP_i.^2); %magnitude da fft

%Verifica se são iguais
dft_igual = sum(dft_IP(:)-(dft_matlab(:)));

%plot
figure(1)
subplot(1,3,1)
imshow(dft_img)
title('Imagem de entrada')
subplot(1,3,2)
imshow(fourier_utils.autocontrast(log(dft_matlab+1e-4)))
title('FFT 2D Matlab')
subplot(1,3,3)
imshow(fourier_utils.autocontrast(log(dft_IP+1e-4)))
title('FFT 2D IP\_UTFPR')
