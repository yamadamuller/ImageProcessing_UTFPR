clc, clear, close all

addpath('..\') %adiciona o diretório anterior no caminho para acessar a classe de funções e as imagens

og_img_pwl = imread("vpfig.png"); %lê a imagem que será aplicada a pwl

%Definindo a função linear por partes (pwl)
y1 = uint8(zeros([1 256]));
%Equação da reta inferior y = (1/3)*x
y1(1:97) = (1/3)*(0:96);
%Equação da reta intermediária y = 3*x -256
y1(98:161) = 3*(97:160) - 256;
%Equação da reta superior y = (1/3)*x + 170
y1(162:256) = (1/3)*(161:255) + 170;

%Aplicando a transformação
img_pwl = imenhancement_utils.contrast_stretching(og_img_pwl, y1);

%plot
figure(1)
subplot(1,2,1)
imshow(og_img_pwl)
title('Imagem Original')
subplot(1,2,2)
imshow(img_pwl)
title('PWL transformation IP\_UTFPR')