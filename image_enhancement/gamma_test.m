clc, clear, close all

img = imread("radio.tif"); %lê a imagem que será palicado o log

figure(30)
subplot(1,5,1)
imshow(img)
title('Original Image')

gamma_array = [0.1, 0.4, 2, 10];
for i = 1:1:length(gamma_array)
    subplot(1,5,i+1)
    imgamma = enhancement_utils.apply_gamma(img, gamma_array(i), 1); %aplica o log
    imshow(imgamma)
    title('Gamma = ' + string(gamma_array(i)))
end

