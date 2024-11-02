clc, clear, close all

addpath('..\images') %adiciona o diretório anterior no caminho para acessar a classe de funções e as imagens
addpath('..\')

img = imread("teturix.png"); %lê a imagem que será aplicada o filtro da mediana

%Median fitler -> reduxing salt and pepper noise
tam_janela = [9 9]; %tamanho da janela para o filtro da mediana
median_filt_IP = nlinear_filters_utils.median_filter2D(img, tam_janela, 'padding'); %operação de filtro da mediana entre img e máscara na unha

%Image sharpening -> composite laplacian mask
OM = linear_filters_utils.generate_mask([3 3], 'composite laplacian');
om_filt_IP = linear_filters_utils.convolve2D(median_filt_IP, OM, 'padding'); %operação de convolução entre img e máscara na unha

%Image sharpening -> unsharp masking
usm_filt_IP = linear_filters_utils.unsharp_masking(median_filt_IP, [5 5], 'gaussian', 5); %aplica unsharp masking com filtro gaussiano [5 5]

%plot
figure(1)
subplot(1,4,1)
imshow(im2uint8(img))
title('Original Image')
subplot(1,4,2)
imshow(im2uint8(median_filt_IP))
title('Median filter')
subplot(1,4,3)
imshow(om_filt_IP)
title('Composite laplacian filter')
subplot(1,4,4)
imshow(usm_filt_IP)
title('Unsharp masking filter')
