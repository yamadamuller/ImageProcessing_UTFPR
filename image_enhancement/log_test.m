clc, clear, close all

img = imread("radio.tif"); %lê a imagem que será palicado o log
imlog = enhancement_utils.apply_log(img, 1/log(255)); %aplica o log

figure(1)
subplot(1,2,1)
imshow(img)
title('Original Image')
subplot(1,2,2)
imshow(imlog)
title('Image Complement')