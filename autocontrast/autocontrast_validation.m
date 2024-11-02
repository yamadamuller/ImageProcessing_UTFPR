clc, clear, close all

img = imread("frajola.png"); %lê a imagem que será palicado o autocontraste
ac_IP_UTFPR = autocontrast_utils.autocontrast(img); %autocontraste teste
ac_matlab = mat2gray(img); %autocontraste nativo matlab
ac_igual = sum(ac_IP_UTFPR(:)-ac_matlab(:)); %verifica se são iguais

figure(1)
subplot(1,3,1)
imshow(img)
title('Imagem original')
subplot(1,3,2)
imshow(im2uint8(ac_IP_UTFPR))
title('Autocontrast IP\_UTFPR')
subplot(1,3,3)
imshow(im2uint8(ac_matlab))
title('Autocontrast matlab')