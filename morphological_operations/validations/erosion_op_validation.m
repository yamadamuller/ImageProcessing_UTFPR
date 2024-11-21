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
ero_matlab = imerode(I, SE);

%dilatação IP_UTFPR
ero_IP = morphological_utils.morph_erosion(I, SE.Neighborhood, false);

%verifica se são iguais
ero_igual = isequal(ero_IP(:), ero_matlab(:));

%plot
figure(1)
subplot(1,3,1)
imshow(I)
title('Imagem binária')
subplot(1,3,2)
imshow(ero_matlab)
title('Erosão nativa')
subplot(1,3,3)
imshow(ero_IP)
title('Erosão IP\_UTFPR')