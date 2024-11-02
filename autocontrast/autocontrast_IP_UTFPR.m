clc, clear, close all

img = imread("frajola.png"); %lê a imagem que será palicado o autocontraste
ac_IP_UTFPR = autocontrast_utils.autocontrast(img); %autocontraste teste

figure(1)
subplot(1,2,1)
imshow(img)
title('Imagem original')
subplot(1,2,2)
imshow(im2uint8(ac_IP_UTFPR))
title('Autocontrast IP\_UTFPR')
