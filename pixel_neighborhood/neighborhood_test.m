clc, clear, close all

a = zeros(501,501); %matriz 501,501 de zeros
a(250,250) = 1; %define apenas o centro como 1
bw = logical(a); %imagem binária

%Distância euclidiana
euclid_test = neighborhood_utils.euclidean(a, 250, 250);
euclid_matlab = bwdist(bw);
euclid_matlab = mat2gray(euclid_matlab);

figure(1)
subplot(2,2,1)
imshow(cat(3, euclid_test, euclid_test, euclid_test))
hold on
imcontour(euclid_test)
hold off
title('Euclid test')
subplot(2,2,2)
imshow(cat(3, euclid_matlab, euclid_matlab, euclid_matlab))
hold on
imcontour(euclid_matlab)
hold off
title('Euclid matlab')

%Distância city-block
cb_test = neighborhood_utils.city_block(a, 250, 250);
cb_matlab = bwdist(bw, "cityblock");
cb_matlab = mat2gray(cb_matlab);

subplot(2,2,3)
imshow(cat(3, cb_test, cb_test, cb_test))
hold on
imcontour(cb_test)
hold off
title('City-block test')
subplot(2,2,4)
imshow(cat(3, cb_matlab, cb_matlab, cb_matlab))
hold on
imcontour(cb_matlab)
hold off
title('City-block matlab')
