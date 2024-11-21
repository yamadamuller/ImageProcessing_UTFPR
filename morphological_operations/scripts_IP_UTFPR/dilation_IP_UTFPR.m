clc, clear, close all;

addpath('..\'); %adiciona o diretório anterior no caminho para acessar a classe de funções

%definindo uma imagem binária para a operação
I = logical([ 1 0 0 0 0 1
              0 0 1 1 0 0
              0 0 1 0 0 0
              0 1 1 1 1 0
              0 1 1 1 0 0
              0 0 0 0 0 0 ]);

%definindo o elemento estruturante
se_mask = [1 0
           1 1];
SE = strel('arbitrary', se_mask); %elemento estruturante arbitrário

%dilatação IP_UTFPR
dilat_IP = morphological_utils.morph_dilation(I, SE.Neighborhood, true);

%plot
figure(1)
subplot(1,2,1)
imshow(I)
title('Imagem binária')
subplot(1,2,2)
imshow(dilat_IP)
title('Dilatação IP\_UTFPR')