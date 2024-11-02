clc, clear, close all

addpath('..\') %adiciona o diretório anterior no caminho para acessar a classe de funções e as imagens

img = imread("radio.tif"); %lê a imagem que será palicado o log

gamma = 0.4; %valor do gamma para a transformação
gamma_IP_UTFPR = imenhancement_utils.transf_gamma(img, gamma); %aplica a função gamma em cada pixel da imagem

figure(1)
subplot(1,2,1)
imshow(img)
title('Original Image')
subplot(1,2,2)
imshow(gamma_IP_UTFPR)
title('Gamma transformation IP\_UTFPR')
