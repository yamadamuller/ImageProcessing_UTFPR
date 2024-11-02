clc, clear, close all

addpath('..\images') %adiciona o diretório anterior no caminho para acessar a classe de funções e as imagens
addpath('..\')

laplace_img = imread("flowervaseg.png"); %lê a imagem que será aplicada o filtro laplaciano

%Composite laplacian
hard_coded_OM = [0 -1  0;...
                -1  5 -1;...
                 0 -1  0];
OM = linear_filters_utils.generate_mask([3 3], 'composite laplacian');
mask_igual = sum(OM(:)-hard_coded_OM(:)); %verifica se a máscara da classe está correta
om_filt_IP = linear_filters_utils.convolve2D(laplace_img, OM, 'padding'); %operação de convolução entre img e máscara na unha
om_filt_matlab = imfilter(laplace_img, OM); %operação de convolução entre img e máscara nativa
om_igual = sum(om_filt_IP(:)-om_filt_matlab(:)); %verifica se são efetivamente iguais

%plot
figure(1)
subplot(1,3,1)
imshow(im2uint8(laplace_img))
title('Original Image')
subplot(1,3,2)
imshow(im2uint8(om_filt_matlab))
title('Composite laplacian filter matlab')
subplot(1,3,3)
imshow(im2uint8(om_filt_IP))
title('Composite laplacian filter IP\_UTFPR')
