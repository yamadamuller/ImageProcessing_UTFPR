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

%dilatação nativa
dilat_matlab = imdilate(I, SE);

%dilatação IP_UTFPR
dilat_IP = morphological_utils.morph_dilation(I, SE.Neighborhood, false);

%verifica se são iguais
dilat_igual = isequal(dilat_IP(:), dilat_matlab(:));

%plot
figure(1)
subplot(1,3,1)
imshow(I)
title('Imagem binária')
subplot(1,3,2)
imshow(dilat_matlab)
title('Dilatação nativa')
subplot(1,3,3)
imshow(dilat_IP)
title('Dilatação IP\_UTFPR')
