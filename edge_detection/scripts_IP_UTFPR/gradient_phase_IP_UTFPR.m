clc, clear, close all;

%Cria imagem sintética
a = triu(ones(8,8))*64;
b = tril(ones(8,8),-1)*192;
g8 = fliplr(uint8(a+b));
g = im2double(g8);

%Magnitude do gradiente
grad_mag = edge_detection_utils.gradient_phase(g, 'valid'); %magnitude do gradiente

figure(1)
subplot(1,2,1)
imshow(g)
title('Imagem de entrada')
subplot(1,2,2)
heatmap(grad_mag)
title('Fase do gradiente (rad)')
