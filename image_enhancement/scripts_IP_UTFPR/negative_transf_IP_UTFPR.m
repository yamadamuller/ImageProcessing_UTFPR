clc, clear, close all

addpath('..\') %adiciona o diretório anterior no caminho para acessar a classe de funções e as imagens

img = imread("xray01.png"); %lê a imagem que será palicado o negativo
imcomp_IP_UTFPR = imenhancement_utils.transf_negative(img); %aplica o negativo da biblioteca IP_UTFPR

figure(1)
subplot(1,2,1)
imshow(img)
title('Original Image')
subplot(1,2,2)
imshow(imcomp_IP_UTFPR)
title('Image Complement IP\_UTFPR')
