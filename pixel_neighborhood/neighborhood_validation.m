clc, clear, close all

a = zeros(501,501); %matriz 501,501 de zeros
a(250,250) = 1; %define apenas o centro como 1
bw = logical(a); %imagem binária
%%
%Distância euclidiana
euclid_IP_UTFPR = pixel_neighborhood_utils.pixel_dist(a, [250. 250.], 'euclidean', true);
euclid_matlab = bwdist(bw);
euclid_matlab = mat2gray(euclid_matlab);
euclid_igual = sum(euclid_IP_UTFPR(:)-euclid_matlab(:)); %verifica se são efetivamente iguais

figure(1)
subplot(3,2,1)
imshow(cat(3, euclid_IP_UTFPR, euclid_IP_UTFPR, euclid_IP_UTFPR))
hold on
imcontour(euclid_IP_UTFPR)
hold off
title('Euclidean IP\_UTFPR')
subplot(3,2,2)
imshow(cat(3, euclid_matlab, euclid_matlab, euclid_matlab))
hold on
imcontour(euclid_matlab)
hold off
title('Euclid matlab')
%%
%Distância city-block
cb_IP_UTFPR = pixel_neighborhood_utils.pixel_dist(a, [250. 250.], 'cityblock', true);
cb_matlab = bwdist(bw, "cityblock");
cb_matlab = mat2gray(cb_matlab);
cb_igual = sum(cb_IP_UTFPR(:)-cb_matlab(:)); %verifica se são efetivamente iguais

subplot(3,2,3)
imshow(cat(3, cb_IP_UTFPR, cb_IP_UTFPR, cb_IP_UTFPR))
hold on
imcontour(cb_IP_UTFPR)
hold off
title('City-block IP\_UTFPR')
subplot(3,2,4)
imshow(cat(3, cb_matlab, cb_matlab, cb_matlab))
hold on
imcontour(cb_matlab)
hold off
title('City-block matlab')

%%
%Distância chessboard
chess_IP_UTFPR = pixel_neighborhood_utils.pixel_dist(a, [250. 250.], 'chessboard', true);
chess_matlab = bwdist(bw, "chessboard");
chess_matlab = mat2gray(chess_matlab);
chess_igual = sum(chess_IP_UTFPR(:)-chess_matlab(:)); %verifica se são efetivamente iguais

subplot(3,2,5)
imshow(cat(3, chess_IP_UTFPR, chess_IP_UTFPR, chess_IP_UTFPR))
hold on
imcontour(chess_IP_UTFPR)
hold off
title('Chessboard IP\_UTFPR')
subplot(3,2,6)
imshow(cat(3, chess_matlab, chess_matlab, chess_matlab))
hold on
imcontour(chess_matlab)
hold off
title('Chessboard matlab')
