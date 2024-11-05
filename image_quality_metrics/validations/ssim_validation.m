clc, clear, close all

addpath('..\images') %adiciona o diretório anterior no caminho para acessar a classe de funções e as imagens
addpath('..\')

ref_img = imread("einstein.gif"); %lê a imagem que será a referência
noise_img = imread("impulse.gif"); %imagem com ruído para computar o MSE

%SSIM matlab
ssim_matlab = ssim(noise_img, ref_img);

%MATLAB IP UTFPR
%Usando a eq.(12) de [1] - completa
tic
ssim_IP_UTFPR_full = IQM_utils.SSIM_full(ref_img, noise_img);
disp('Tempo para computar o SSIM com (12) = ' + string(toc) + 's');
%Usando a eq.(13) de [1] - simplificada
tic
ssim_IP_UTFPR = IQM_utils.SSIM(ref_img, noise_img);
disp('Tempo para computar o SSIM com (13) = ' + string(toc) + 's');

%verifica se são iguais
eq_igual = sum(ssim_IP_UTFPR_full(:)-ssim_IP_UTFPR(:));
ssim_igual = sum(ssim_IP_UTFPR(:)-ssim_matlab);

%[1] - Z. Wang, A. C. Bovik, H. R. Sheikh and E. P. Simoncelli, 
%"Image quality assessment: From error visibility to structural similarity," 
%IEEE Transactions on Image Processing, vol. 13, no. 4, pp. 600-612, Apr. 2004.
