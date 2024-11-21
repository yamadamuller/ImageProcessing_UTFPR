clc, clear, close all;

addpath('..\'); %adiciona o diretório anterior no caminho para acessar a classe de funções
addpath('..\images'); %adiciona diretório das imagens

I = logical(imread('exMorph4.bmp'));
SE = strel('square', 3); %elemento estrutural quadrado 3x3

%fechamento nativo
close_matlab = imclose(I, SE);

%fechamento IP_UTFPR
close_IP = morphological_utils.morph_closing(I, SE.Neighborhood);

%verifica se são iguais
close_igual = isequal(close_IP, close_matlab);

%plot
figure(1)
subplot(1,3,1)
imshow(I)
title('Imagem binária')
subplot(1,3,2)
imshow(close_matlab)
title('Fechamento nativo')
subplot(1,3,3)
imshow(close_IP)
title('Fechamento IP\_UTFPR')