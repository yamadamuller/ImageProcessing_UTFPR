clc, clear, close all

addpath('..\images') %adiciona o diretório anterior no caminho para acessar a classe de funções e as imagens
addpath('..\')

%Equalização de histograma
og_img_histeq = imread("gDSC04422m16.png"); %lê a imagem que será calculada a equalização
histeq_IP_UTFPR = imenhancement_utils.im_histogram_eq(og_img_histeq); %equalização do histograma na unha

figure(8)
subplot(2,2,1)
imshow(og_img_histeq)
title('Original Image')
subplot(2,2,3)
bar(0:1:255, imenhancement_utils.im_histogram(og_img_histeq))
title('Original Histogram')

subplot(2,2,2)
imshow(histeq_IP_UTFPR)
title('Histogram equalization IP\_UTFPR')
subplot(2,2,4)
bar(0:1:255, imenhancement_utils.im_histogram(histeq_IP_UTFPR))
title('Equalized histogram IP\_UTFPR')
