clc, clear, close all

addpath('..\images') %adiciona o diretório anterior no caminho para acessar a classe de funções e as imagens
addpath('..\')

epf_img = imread("Lenna256g.png"); %lê a imagem que será aplicada o filtro edge-preserving
epf_noise = imnoise(epf_img,'gaussian',(0/255),(10/255)^2); %insere ruido gaussiano

%selecionar região do ruido e calcular a variância
disp('Selecione uma região para estimar a variância do ruído e clique duas vezes!')
[reg, rect] = imcrop(epf_noise);
imin = ceil(rect(2)); %linha cse
jmin = ceil(rect(1)); %coluna cse
imax = floor(rect(2)+rect(4)); %linha cid
jmax = floor(rect(1)+rect(3)); %coluna cid
epf_noise = double(epf_noise); %converte para double
v_noise = var(double(reg(:)));

%MMSE IP_UTFPR
tam_janelas = [5 5]; %tamanho das janelas para média e variância locais
epf_IP_UTFPR = edge_preserving_filters_utils.MMSE(epf_noise, tam_janelas, v_noise, 'padding');
epf_IP_UTFPR = uint8(epf_IP_UTFPR); %converte para uint8

%MMSE Matlab
%variâncias locais
fun = @(x)var(x(:));
vlocal = nlfilter(epf_noise,tam_janelas,fun);

%médias locais
h = fspecial('average', tam_janelas);
mlocal = imfilter(epf_noise, h, 0);

%filtro
epf_matlab = (1 - (v_noise./vlocal)).*epf_noise + (v_noise./vlocal).*mlocal;
epf_matlab = uint8(epf_matlab); %converte para uint8

epf_igual = sum(epf_IP_UTFPR(:)-epf_matlab(:)); %verifica se são iguais

%Plots
figure(1)
subplot(1,4,1)
imshow(epf_img)
title('Original Image')
subplot(1,4,2)
imshow(uint8(epf_noise))
title('Original image w/ gaussian noise')
subplot(1,4,3)
imshow(epf_matlab)
title('MMSE filter matlab')
subplot(1,4,4)
imshow(epf_IP_UTFPR)
title('MMSE filter IP\_UTFPR')


