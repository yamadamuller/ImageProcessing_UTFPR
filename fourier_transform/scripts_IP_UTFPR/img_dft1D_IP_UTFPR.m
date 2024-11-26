clc, clear, close all;

addpath('..\'); %adiciona diretório anterior para ter acesso à classe de funções

dft_img_r = imread('cameraman.tif'); %lê a imagem que será aplicada a DFT 1D
dft_img_i = zeros(size(dft_img_r)); %componente complexa é composta por zeros

%Linhas
[dft_r_i, dft_i_i] = fourier_utils.im_dft1D(dft_img_r, dft_img_i, 1); %aplica a DFT 1D nas linhas
dft_IP_i = sqrt(dft_r_i.^2 + dft_i_i.^2)/numel(dft_r_i); %magnitude

%plot
figure(1)
subplot(1,2,1)
imshow(dft_img_r)
title('Imagem de entrada')
subplot(1,2,2)
imshow(fourier_utils.autocontrast(log(dft_IP_i+1e-4)))
title('DFT Linhas IP\_UTFPR')

%Colunas
[dft_r_j, dft_i_j] = fourier_utils.im_dft1D(dft_img_r, dft_img_i, 2); %aplica a DFT 1D nas colunas
dft_IP_j = sqrt(dft_r_j.^2 + dft_i_j.^2)/numel(dft_r_j); %magnitude

%plot
figure(2)
subplot(1,2,1)
imshow(dft_img_r)
title('Imagem de entrada')
subplot(1,2,2)
imshow(fourier_utils.autocontrast(log(dft_IP_j+1e-4)))
title('DFT Colunas IP\_UTFPR')
