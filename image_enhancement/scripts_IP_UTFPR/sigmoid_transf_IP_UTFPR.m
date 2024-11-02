clc, clear, close all

addpath('..\') %adiciona o diretório anterior no caminho para acessar a classe de funções e as imagens

og_img_sgd = imread("vpfig.png"); %lê a imagem que será aplicada a sigmóide

%Define a sigmoide
slope = 1; %slope da sigmoide
sig = imenhancement_utils.uint8_sigmoide(slope, 127);

%Aplica a transformação
img_sig = imenhancement_utils.contrast_stretching(og_img_sgd, sig);

%plot
figure(2)
subplot(1,2,1)
imshow(og_img_sgd)
title('Imagem Original')
subplot(1,2,2)
imshow(img_sig)
title('Sigmoid transformation IP\_UTFPR')