clc, clear, close all

addpath('..\images') %adiciona o diretório anterior no caminho para acessar a classe de funções e as imagens

img = imread("radio.tif"); %lê a imagem que será palicado o log
imlog = imenhancement_utils.transf_log(img, 1/log(255)); %aplica o log

figure(1)
subplot(1,2,1)
imshow(img)
title('Original Image')
subplot(1,2,2)
imshow(imlog)
title('Log transformation IP\_UTFPR')