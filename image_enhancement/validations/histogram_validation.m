clc, clear, close all

addpath('..\') %adiciona o diretório anterior no caminho para acessar a classe de funções e as imagens

clc, clear, close all

og_img_hist = imread("42049_20-200.png"); %lê a imagem que será calculado o histograma

%Histograma
hist_IP_UTFPR = imenhancement_utils.im_histogram(og_img_hist); %histograma na unha 
hist_matlab = imhist(og_img_hist); %histograma nativo
hist_igual = sum(hist_IP_UTFPR(:)-hist_matlab(:)); %verifica se são efetivamente iguais

%Plots
figure(4)
imshow(og_img_hist)
title('Original Image')

figure(5)
subplot(1,2,1)
bar(0:1:255, hist_IP_UTFPR)
title('Histogram IP\_UTFPR')
subplot(1,2,2)
bar(0:1:255, hist_matlab)
title('Histogram matlab')