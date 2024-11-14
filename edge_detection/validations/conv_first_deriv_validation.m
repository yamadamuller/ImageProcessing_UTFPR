clc, clear, close all; 

addpath('..\') %adiciona o diretório anterior no caminho para acessar a classe de funções

%Definindo uma imagem sintética para exemplo
g1 = ones(1,10)*64;
g2 = ones(1,10)*192;
g3 = linspace(192,64,10);
g = [g1 g2 g3 g1,...
fliplr(g3) g2 g1];
g = repmat(g,9,1);
ncol = size(g,2);

%Definindo um perfil arbitrário
profile = g(1,:); %linha 1 com todas as colunas

%Derivada numérica IP_UTFPR
f_prime_IP_num = edge_detection_utils.num_derivative(profile); %calcula a derivada numérica vetorizada

%Derivada por convolução IP_UTFPR
f_prime_IP_conv = edge_detection_utils.derivative_convolve2D(profile, [1 0 -1])/2;
f_prime_IP_conv([1 size(f_prime_IP_conv)]) = 0;

%verifica se são iguais
f_prime_igual = sum(f_prime_IP_conv(:) - f_prime_IP_num(:));

%plot
figure(1)
subplot(3,1,1)
imshow(uint8(g))
title('Imagem')
subplot(3,1,2)
plot(1:ncol, profile, '-ks')
title('Perfil da imagem')
subplot(3,1,3)
plot(1:ncol, f_prime_IP_conv, '-bd')
ylim([-100 100])
title("f'(x)")
