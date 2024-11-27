clc, clear, close all;

%Cria uma imagem sintética para deslocar
gauss_mask = fourier_utils.generate_mask([5 5], 'gaussian', 1); %máscara gaussiana para suavizar
square_init = 64;
square_end = 192;
img_ref = zeros(256,256);
img_ref(square_init:square_end, square_init:square_end)=255; %quadrado no centro
img_ref = imnoise(img_ref,'gaussian',(0/255),(10/255)^2); %adiciona ruído gaussiano
img_ref = fourier_utils.convolve2D(img_ref, gauss_mask, 'padding');
img_disp = zeros(size(img_ref));
img_disp(square_init+30:square_end+30, square_init+50:square_end+50)=255; %quadrado deslocado em 20 pixels
img_disp = imnoise(img_disp,'gaussian',(0/255),(10/255)^2); %adiciona ruído gaussiano
img_disp = fourier_utils.convolve2D(img_disp, gauss_mask, 'padding');
[delta_i, delta_j, icps] = fourier_utils.phase_correlation(img_ref, img_disp);

%Posições encontradas
if square_init+delta_j > size(img_ref,1)
    x_axis_pos = square_init + (size(img_ref,2)-delta_j);
else
    x_axis_pos = square_init+delta_j;
end

if square_init+delta_i > size(img_ref,1)
    y_axis_pos = square_init + (size(img_ref,2)-delta_i);
else
    y_axis_pos = square_init+delta_i;
end

%plot
figure(1)
subplot(1,3,1)
imshow(img_ref)
title('Imagem referência')
subplot(1,3,2)
imshow(img_disp)
hold on
scatter(square_init, square_init,'o','g')
scatter(x_axis_pos, y_axis_pos,'o','r')
title('Imagem deslocada')
subplot(1,3,3)
surf(abs(icps))
title('Phase Correlation')
