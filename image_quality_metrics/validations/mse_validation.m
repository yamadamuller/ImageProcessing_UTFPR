clc, clear, close all

addpath('..\images') %adiciona o diretório anterior no caminho para acessar a classe de funções e as imagens
addpath('..\')

ref_img = imread("boat.512.tiff"); %lê a imagem que será a referência
noise_img = imread("boatNoiseG05SP02.png"); %imagem com ruído para computar o MSE

%MSE nativo
mse_matlab = immse(ref_img, noise_img); 

%MSE IP_UTFPR
mse_IP_UTFPR = IQM_utils.MSE(ref_img, noise_img);

%verifica se são iguais
mse_igual = sum(mse_IP_UTFPR(:)-mse_matlab(:));
