clear all, close all

addpath('..\images') %adiciona o diretório anterior no caminho para acessar a classe de funções e as imagens
addpath('..\')

g = imread('flowervaseg.png');

%Unsharp masking com ganho
gain = 1; %ganho aplicado na imagem sem componentes de baixa frequência

%Matlab
h = fspecial('gaussian', [5 5], 1);
gg = imfilter(double(g), h);
unshmask = double(g) - gg;
gunsharp = double(g) + unshmask.*gain;
gunsharp = uint8(gunsharp);

%IP_UTFPR
usm_IP_UTFPR = linear_filters_utils.unsharp_masking(g, [5 5], 'gaussian', gain); %aplica unsharp masking com filtro gaussiano [5 5]
usm_igual = sum(usm_IP_UTFPR(:)-gunsharp(:)); %verifica se são iguais

%plot
figure(1)
subplot(1,3,1)
imshow(im2uint8(g))
title('Original Image')
subplot(1,3,2)
imshow(gunsharp)
title('Unsharp masking matlab')
subplot(1,3,3)
imshow(usm_IP_UTFPR)
title('Unsharp marsking IP\_UTFPR')

