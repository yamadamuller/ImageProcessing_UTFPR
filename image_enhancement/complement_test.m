clc, clear, close all

img = imread("xray01.png"); %lê a imagem que será palicado o negativo
imcomp = enhancement_utils.apply_negative(img); %aplica o negativo

figure(1)
subplot(1,2,1)
imshow(img)
title('Original Image')
subplot(1,2,2)
imshow(imcomp)
title('Image Complement')