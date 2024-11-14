clc, clear, close all;

%máscara 31x31 LoG com sigma = 4
mask_size = [31 31]; %tamanho da máscara
sigma = 4; %desvio padrão

%Laplaciano do gaussiano IP_ITFPR
log_IP = edge_detection_utils.generate_mask(mask_size, 'log', sigma); 

%Laplaciano do gaussiano nativo
log_matlab = fspecial('log', mask_size, sigma);

%Verifica se são iguais
log_igual = sum(log_IP(:)-log_matlab(:));

%Display
figure
mesh(-log_IP, 'EdgeColor', 'black')
title('LoG sigma=4')
