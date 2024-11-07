clc, clear, close all

addpath('..\images') %adiciona o diretório anterior no caminho para acessar a classe de funções e as imagens
addpath('..\')

bilat_img = imread('chicomm.jpg');
bilat_img = im2gray(im2double(bilat_img)); %converte para gray scale

%Borba
dk_sigma = 3; % domain (Gaussian) kernel sigma. Kernel size is a function of sigma
rk_sigma = 0.2; % range kernel sigma
[nr, nc] = size(bilat_img); % Image number of rows and cols
wk_s = 2*ceil(2*dk_sigma)+1; % kernel square size
tl = -floor(wk_s/2); % row==col of the top left limit of rk
br = floor(wk_s/2); % row==col of the bottom right limit of rk
dk = fspecial("gaussian", wk_s, dk_sigma);

bilat_borba = zeros(nr,nc);
for i = br+1:nr-br
    for j = br+1:nc-br
        img_p = ones(wk_s)*bilat_img(i,j); % patch filled with value of THE PIXEL p
        img_patch = bilat_img(i+tl:i+br,j+tl:j+br);
        rk = exp(-((img_p - img_patch).^2)/(2*(rk_sigma^2)));
        wk = dk.*rk;
        wk = wk/sum(wk(:)); % make sum(wk(:)) = 1
        bilat_borba(i,j) = sum(sum(img_patch.*wk)); % MAC (multiply–accumulate)
    end
end

%IP_UTFPR
bilat_IP_UTFPR = edge_preserving_filters_utils.bilateral_filter(bilat_img, dk_sigma, rk_sigma, 'valid');
%bilat_IP_UTFPR = uint8(bilat_IP_UTFPR); %converte para uint8

%verifica se são iguais
bilat_igual = sum(bilat_IP_UTFPR(:)-bilat_borba(:)); 

%Plots
figure(1)
subplot(1,3,1)
imshow(bilat_img)
title('Original Image')
subplot(1,3,2)
imshow(bilat_borba)
title('Bilateral filter borba')
subplot(1,3,3)
imshow(bilat_IP_UTFPR)
title('Bilateral filter IP\_UTFPR')
