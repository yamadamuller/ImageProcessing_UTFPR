clc, clear, close all;

%Cria imagem sintética
w = 256;
objt = 192; fundo = 64; rnd = 10;
g = makeImSynthHex(w,objt,fundo, rnd);
g = edge_detection_utils.autocontrast(g);

%Sobel IP UTFPR
Gv = edge_detection_utils.generate_mask([], 'sobel_y'); %máscara sobel vertical
Gh = edge_detection_utils.generate_mask([], 'sobel_x'); %máscara sobel horizontal
Sv = edge_detection_utils.convolve2D(g, Gv, 'padding'); %I*Gv
Sh = edge_detection_utils.convolve2D(g, Gh, 'padding'); %I*Gh

%Sobel matlab
Gh_m = fspecial('sobel'); %máscara sobel horizontal nativa
Gv_m = Gh_m'; %máscara sobel vertical nativa
Sv_m = imfilter(g, Gv_m, 'conv'); %I*Gv
Sh_m = imfilter(g, Gh_m, 'conv'); %I*Gh

%Verifica se são iguais
vert_igual = sum(Sv(:)-Sv_m(:));
horiz_igual = sum(Sh(:)-Sh_m(:));

figure(1)
subplot(1,3,1)
imshow(g)
title('Imagem de entrada')
subplot(1,3,2)
imshow(edge_detection_utils.autocontrast(Sv))
title('Sobel vertical')
subplot(1,3,3)
imshow(edge_detection_utils.autocontrast(Sh))
title('Sobel horizontal')