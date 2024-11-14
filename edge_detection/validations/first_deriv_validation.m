clc, clear, close all;

%Cria imagem sintética
w = 256;
objt = 192; fundo = 64; rnd = 10;
g = makeImSynthHex(w,objt,fundo, rnd);
g = edge_detection_utils.autocontrast(g);

%Derivada com máscara nativa
f_prime_vert_matlab = imfilter(g, [1 0 -1])/2;
f_prime_horiz_matlab = imfilter(g, [1 0 -1]')/2;

%Derivada com a máscara vertical
f_prime_vert_IP = edge_detection_utils.derivative_convolve2D(g, [-1 0 1])/2;
f_prime_horiz_IP = edge_detection_utils.derivative_convolve2D(g, [-1 0 1]')/2;

%Verifica se são iguais
vert_igual = sum(f_prime_vert_IP(:)-f_prime_vert_matlab(:));
horiz_igual = sum(f_prime_horiz_IP(:)-f_prime_horiz_matlab(:));

figure(1)
subplot(1,3,1)
imshow(g)
title('Imagem de entrada')
subplot(1,3,2)
imshow(edge_detection_utils.autocontrast(f_prime_vert_matlab))
title('Máscara vertical')
subplot(1,3,3)
imshow(edge_detection_utils.autocontrast(f_prime_horiz_matlab))
title('Máscara horizontal')