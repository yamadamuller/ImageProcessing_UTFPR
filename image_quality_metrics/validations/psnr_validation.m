clc, clear, close all

addpath('..\images') %adiciona o diretório anterior no caminho para acessar a classe de funções e as imagens
addpath('..\')

ref_img = imread("boat.512.tiff"); %lê a imagem que será a referência
noise_img = imread("boatNoiseG05SP02.png"); %imagem com ruído para computar o MSE

%MSE nativo
psnr_matlab = psnr(ref_img, noise_img); 

%MSE IP_UTFPR
psnr_IP_UTFPR = IQM_utils.PSNR(ref_img, noise_img, 'uint8');

%verifica se são iguais
psnr_igual = sum(psnr_IP_UTFPR(:)-psnr_matlab(:));
