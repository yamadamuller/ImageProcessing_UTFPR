clc, clear, close all;

addpath('..\'); %adiciona o diretório anterior no caminho para acessar a classe de funções
addpath('..\images'); %adiciona diretório das imagens

I = logical(imread('exMorph4.bmp'));
SE = strel('square', 3); %elemento estrutural quadrado 3x3

%abertura IP_UTFPR
open_IP = morphological_utils.morph_opening(I, SE.Neighborhood);

%plot
figure(1)
subplot(1,2,1)
imshow(I)
title('Imagem binária')
subplot(1,2,2)
imshow(open_IP)
title('Abertura IP\_UTFPR')