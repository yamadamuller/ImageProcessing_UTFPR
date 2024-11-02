clc, clear, close all

addpath('..\images') %adiciona o diretório anterior no caminho para acessar a classe de funções e as imagens

img = imread("xray01.png"); %lê a imagem que será palicado o negativo
imcomp_IP_UTFPR = imenhancement_utils.transf_negative(img); %aplica o negativo da biblioteca IP_UTFPR
imcomp_matlab = imcomplement(img); %aplica o negativo do matlab
imcomp_igual = sum(imcomp_IP_UTFPR(:)-imcomp_matlab(:)); %verifica se são efetivamente iguais

figure(1)
subplot(1,3,1)
imshow(img)
title('Original Image')
subplot(1,3,2)
imshow(imcomp_IP_UTFPR)
title('Image Complement IP\_UTFPR')
subplot(1,3,3)
imshow(imcomp_matlab)
title('Image Complement matlab')