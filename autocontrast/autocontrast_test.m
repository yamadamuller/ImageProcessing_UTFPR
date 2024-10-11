clc, clear, close all

img = imread("frajola.png"); %lê a imagem que será palicado o autocontraste
ac_test = autocontrast_utils.autocontrast(img); %autocontraste teste
ac_matlab = mat2gray(img); %autocontraste nativo matlab

figure(1)
subplot(1,3,1)
imshow(img)
title('Imagem original')
subplot(1,3,2)
imshow(ac_test)
title('Autocontrast test')
subplot(1,3,3)
imshow(ac_matlab)
title('Autocontrast matlab')