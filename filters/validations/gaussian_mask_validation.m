clc, clear, close all

addpath('..\')

%Gaussian filter
tam_gauss = [5 5]; %tamanho da máscara de convolução
sigma = 1; %desvio padrão
gauss_matlab = fspecial('gaussian', tam_gauss, sigma); %máscara de convolução para gaussiano nativo
gauss_IP_UTFPR = linear_filters_utils.generate_mask(tam_gauss, 'gaussian', sigma); %máscara de convolução para gaussiano na unha
gauss_igual = sum(gauss_IP_UTFPR(:)-gauss_matlab(:)); %verifica se são iguais

%Plot
figure(2)
subplot(1,2,1)
bar3(gauss_matlab)
title('Gaussian mask matlab')
subplot(1,2,2)
bar3(gauss_IP_UTFPR)
title('Gaussian mask IP\_UTFPR')