clc, clear, close all;

addpath('..\'); %adiciona diretório anterior para ter acesso à classe de funções

%Definindo um senoide abirtrária para testar a DFT
f=60; %Hz
A=2; %volts
inicio=0; %inicio do intervalo de amostragem em segundos
fim=2; %fim intervalo de amostragem em segundos
n_samples=1000; %numero de amostras no tempo
Ts = (fim-inicio)/n_samples; %intervalo de amostragem em segundos
t = inicio : Ts : fim-Ts; %escala de tempo em segundos
fs=1/Ts; %freq de amostragem em Hz
delta_f=fs/n_samples; %resolução do espectro
esc_freq=-fs/2 : delta_f : (fs/2-delta_f); %escala de freq
fdet=1+A.*sin(2*pi*f*t)+A/2.*cos(2*pi*2*f*t); %funcao f(t)
f_i(1:size(fdet,2))=0; %vetor para a parte imaginaria do sinal
f_r=fdet; %parte real é igual ao sinal

%FFT matlab
F = fft(f_r, n_samples); %fft do sinal de corrente
F = fftshift(F); %simetria para -fs/2 a fs/2
f_fft = linspace((-1/Ts)/2, (1/Ts)/2, n_samples); %vetor de frequências
magnitude = abs(F)/n_samples; %magnitude normalizada em funçaõ do máximo

%DFT IP_UTFPR
[IP_r, IP_i] = fourier_utils.dft1D(f_r, f_i); %aplica a DFT
IP_dft = sqrt(IP_r.^2 + IP_i.^2)/n_samples; %módulo da DFT
freqs = -fs/2 : delta_f : (fs/2-delta_f); %frequências do espectro

%Verifica se são iguais
dft_igual = sum(magnitude(:)-IP_dft(:));

%plot
figure(1)
subplot(1,3,1)
plot(t, f_r)
title('Sinal no domínio do tempo')
grid on
subplot(1,3,2)
plot(freqs, magnitude)
ylim([0 1.2])
title('Sinal no domínio da frequência Matlab')
grid on
subplot(1,3,3)
plot(freqs, IP_dft)
ylim([0 1.2])
title('Sinal no domínio da frequência IP\_UTFPR')
grid on
