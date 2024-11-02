clc, clear, close all

addpath('..\') %adiciona o diretório anterior no caminho para acessar a classe de funções e as imagens

img = imread("radio.tif"); %lê a imagem que será palicado o log

gamma = 0.4; %valor do gamma para a transformação
gamma_IP_UTFPR = imenhancement_utils.transf_gamma(img, gamma); %aplica a função gamma em cada pixel da imagem
gamma_matlab = imadjust(img, [], [], gamma); %aplica a função de transformação gamma nativa
gamma_igual = sum(gamma_IP_UTFPR(:)-gamma_matlab(:)); %verifica se são efetivamente iguais

figure(1)
subplot(1,3,1)
imshow(img)
title('Original Image')
subplot(1,3,2)
imshow(gamma_IP_UTFPR)
title('Gamma transformation IP\_UTFPR')
subplot(1,3,3)
imshow(gamma_matlab)
title('Gamma transformation matlab')


