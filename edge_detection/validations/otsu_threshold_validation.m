clc, clear, close all;

%Cria imagem sintética
w = 256;
objt = 192; fundo = 64; rnd = 10;
g = makeImSynthHex(w,objt,fundo, rnd);
g = edge_detection_utils.autocontrast(g);

%Magnitude do gradiente
grad_mag = edge_detection_utils.gradient_magnitude(g, 'padding'); %magnitude do gradiente
grad_mag = edge_detection_utils.autocontrast(grad_mag); %auto-correlação
grad_mag = im2uint8(grad_mag);

%Thresholding pelo método de (Otsu, 1979)
opt_q = edge_detection_utils.otsu_threshold(grad_mag); %obtém o valor na escala de cinza ótimo de limiar
grad_mag_bw = edge_detection_utils.bw_thresholding(grad_mag, opt_q);

%Thresholding pelo método greythresh nativo
opt_q_matlab = graythresh(grad_mag);
grad_mag_bw_matlab = im2uint8(im2bw(grad_mag, graythresh(grad_mag)));

%Verifica se são iguais
bw_igual = sum(grad_mag_bw(:)-grad_mag_bw_matlab(:));

figure(1)
subplot(1,3,1)
imshow(g)
title('Imagem de entrada')
subplot(1,3,2)
imshow(uint8(grad_mag))
title('Magnitude do gradiente')
subplot(1,3,3)
imshow(grad_mag_bw)
title('Magnitude do gradiente limiarizada')