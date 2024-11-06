%Exemplo baseado na seção "Demonstration" de https://ece.uwaterloo.ca/~z70wang/research/ssim/#usage
clc, clear, close all;

addpath('..\'); %adiciona o diretório anterior no caminho para acessar a classe de funções e as imagens
mssim_imgs = ls('../ssim_images'); %lista com todos os arquivos contidos do diretório de imagens

%Define a imagem de referência
ref_file = mssim_imgs(3,:); %nome do arquivo da imagem de referência
ref_path = '../ssim_images/' + string(ref_file(find(~isspace(mssim_imgs(3,:))))); %caminho completo para a imagem
ref_img = imread(ref_path); %imagem de referência

%Calculando o MSE e o SSIM para as imagens
figure(1)
subplot(2,3,1)
imshow(im2uint8(ref_img))
title('Original, MSE=' + string(IQM_utils.MSE(ref_img, ref_img))+'; SSIM=' + string(IQM_utils.SSIM(ref_img, ref_img, 'uint8')))
for i = 2:size(mssim_imgs(3:end,:))
    curr_file = mssim_imgs(i+2,:); %nome do arquivo da imagem 
    curr_path = '../ssim_images/' + string(curr_file(find(~isspace(mssim_imgs(i+2,:))))); %caminho completo para a imagem
    curr_img = imread(curr_path); %imagem atual q se deseja computar o MSE e o MSSIM
    if ~strcmp(curr_path, ref_path)
        subplot(2,3,i)
        imshow(im2uint8(curr_img))
        title('Original, MSE=' + string(IQM_utils.MSE(ref_img, curr_img))+'; SSIM=' + string(IQM_utils.SSIM(ref_img, curr_img, 'uint8')))
    end
end
