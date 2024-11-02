clc, clear, close all

addpath('..\')

%Box-filter
tam_bf = [3 3]; %tamanho da máscara de convolução
avg_matlab = fspecial('average', tam_bf); %máscara de convolução para box-filter nativo 
avg_IP_UTFPR = linear_filters_utils.generate_mask(tam_bf, 'box'); %máscara de convolução para box-filter na unha
avg_igual = sum(avg_IP_UTFPR(:)-avg_matlab(:)); %verifica se são iguais

%Plot
figure(1)
subplot(1,2,1)
bar3(avg_matlab)
title('Box-filter mask matlab')
subplot(1,2,2)
bar3(avg_IP_UTFPR)
title('Box-filter mask IP\_UTFPR')