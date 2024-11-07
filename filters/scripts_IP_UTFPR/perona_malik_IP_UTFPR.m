clc, clear, close all;

pm_img = imread("cameraman.tif"); %lê a imagem que será utilizada para o filtro anisotropic diffusion

%Perona-Malik IP_UTFPR
pm_filt_IP = edge_preserving_filters_utils.perona_malik_filter(pm_img, 0.05, 10, 20); 
pm_filt_IP = uint8(pm_filt_IP); %converte para uint8


%plot
figure(1)
subplot(1,2,1)
imshow(pm_img)
title('Original Image')
subplot(1,2,2)
imshow(im2uint8(pm_filt_IP))
title('Perona-Malik IP\_UTFPR')
