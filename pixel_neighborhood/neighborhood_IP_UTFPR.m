clc, clear, close all

a = zeros(501,501); %matriz 501,501 de zeros
a(250,250) = 1; %define apenas o centro como 1
bw = logical(a); %imagem binária

%Distância euclidiana
euclid_IP_UTFPR = pixel_neighborhood_utils.pixel_dist(a, [250. 250.], 'euclidean', true);

%Distância city-block
cb_IP_UTFPR = pixel_neighborhood_utils.pixel_dist(a, [250. 250.], 'cityblock', true);

%Distância city-block
chess_IP_UTFPR = pixel_neighborhood_utils.pixel_dist(a, [250. 250.], 'chessboard', true);

figure(1)
subplot(1,3,1)
imshow(cat(3, euclid_IP_UTFPR, euclid_IP_UTFPR, euclid_IP_UTFPR))
hold on
imcontour(euclid_IP_UTFPR)
hold off
title('Euclidean IP\_UTFPR')
subplot(1,3,2)
imshow(cat(3, cb_IP_UTFPR, cb_IP_UTFPR, cb_IP_UTFPR))
hold on
imcontour(cb_IP_UTFPR)
hold off
title('City-block IP\_UTFPR')
subplot(1,3,3)
imshow(cat(3, chess_IP_UTFPR, chess_IP_UTFPR, chess_IP_UTFPR))
hold on
imcontour(chess_IP_UTFPR)
hold off
title('Chessboard IP\_UTFPR')
