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

%Derivada numérica iterativa
f_prime_it = zeros(1, ncol); %vetor de zeros para armazenar os valores da derivada
for k = 2:ncol-1
    f_prime_it(k) = profile(k+1) - profile(k-1); %f'[i] = f[i+eps] - f[i-eps]
end
f_prime_it = f_prime_it./2; %diferença central -> (f[i+eps] - f[i-eps])/2

%Derivada segunda numérica iterativa
f_sec_prime_it = zeros(size(f_prime_it)); %vetor de zeros para armazenar os valores da derivada segunda
for k = 2:ncol-1
    f_sec_prime_it(k) = f_prime_it(k+1) - f_prime_it(k-1); %f'[i] = f[i+eps] - f[i-eps]
end
f_sec_prime_it = f_sec_prime_it./2; %diferença central -> (f[i+eps] - f[i-eps])/2

%Derivada numérica IP_UTFPR
f_prime_IP = edge_detection_utils.num_derivative(profile); %calcula a derivada numérica vetorizada

%Derivada segunda numérica IP_UTFPR
f_sec_prime_IP = edge_detection_utils.num_sec_derivative(profile); %calcula a derivada segunda numérica vetorizada

%verifica se são iguais
f_sec_prime_igual = sum(f_sec_prime_it(:) - f_sec_prime_IP(:));

%plot
figure(1)
subplot(4,1,1)
imshow(uint8(g))
title('Imagem')
axis off
axis image
subplot(4,1,2)
plot(1:ncol, profile, '-ks')
title('Perfil da imagem')
subplot(4,1,3)
plot(1:ncol, f_prime_IP, '-bd')
ylim([-100 100])
title("f'(x)")
subplot(4,1,4)
plot(1:ncol, f_sec_prime_IP, '-ro')
ylim([-100 100])
title("f''(x)")
