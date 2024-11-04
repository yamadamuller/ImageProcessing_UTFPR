clear all, close all

addpath('..\images') %adiciona o diretório anterior no caminho para acessar a classe de funções e as imagens
addpath('..\')

g = imread('flowervaseg.png');
g = double(g); %converte para double

%Unsharp masking com ganho
gain = 1; %ganho aplicado na imagem sem componentes de baixa frequência

%Matlab
h = fspecial('gaussian', [5 5], 1);
gg = imfilter(g, h);
unshmask = g - gg;
gunsharp = g + unshmask.*gain;
gunsharp = uint8(gunsharp); %converte para uint8

%IP_UTFPR
usm_IP_UTFPR = linear_filters_utils.unsharp_masking(g, [5 5], 'gaussian', gain); %aplica unsharp masking com filtro gaussiano [5 5]
usm_IP_UTFPR = uint8(usm_IP_UTFPR); %converte para uint8

usm_igual = sum(usm_IP_UTFPR(:)-gunsharp(:)); %verifica se são iguais

%plot
figure(1)
subplot(1,3,1)
imshow(uint8(g))
title('Original Image')
subplot(1,3,2)
imshow(gunsharp)
title('Unsharp masking matlab')
subplot(1,3,3)
imshow(usm_IP_UTFPR)
title('Unsharp marsking IP\_UTFPR')

