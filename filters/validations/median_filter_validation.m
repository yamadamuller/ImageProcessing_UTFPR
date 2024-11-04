clc, clear, close all

addpath('..\images') %adiciona o diretório anterior no caminho para acessar a classe de funções e as imagens
addpath('..\')

snp_img = imread("bambam_sp.png"); %lê a imagem que será aplicada o filtro da mediana
snp_img = double(snp_img); %converte para double

%Median fitler -> salt and pepper noise
tam_janela = [5 5]; %tamanho da janela para o filtro da mediana
median_filt_IP = nlinear_filters_utils.median_filter2D(snp_img, tam_janela, 'padding'); %operação de filtro da mediana entre img e máscara na unha
median_filt_IP = uint8(median_filt_IP); %converte para uint8
median_filt_matlab = medfilt2(snp_img, tam_janela); %operação de filtro da mediana entre img e máscara nativa
median_filt_matlab = uint8(median_filt_matlab); %converte para uint8
median_filt_igual = sum(median_filt_IP(:)-median_filt_matlab(:)); %verifica se efetivamente são iguais

%plot
figure(1)
subplot(1,3,1)
imshow(uint8(snp_img))
title('Original Image')
subplot(1,3,2)
imshow(im2uint8(median_filt_matlab))
title('Median filter matlab')
subplot(1,3,3)
imshow(im2uint8(median_filt_IP))
title('Median filter IP\_UTFPR')