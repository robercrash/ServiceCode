%% Incialización de Variables necesarias
clear all;
close all;

[y, Fs] = audioread('noSonoro-2.wav');
figure(1);
plot(y);
title('Señal de Entrada');
figure(2);
plot(abs(fft(y)));
title('Señal de Entrada');

%Frecuencias de corte
Fpass = 300;     
Fstop = 3000;

%Frecuencias normalizadas
Fpassn = Fpass / (Fs / 2);          
Fstopn = Fstop / (Fs / 2);

%Calculando coeficientes de Filtro FIR usando fir1
n = 100;                                    %orden del filtro
a = 1;                                      %Denominador 
b = fir1(n,[Fpassn, Fstopn], 'bandpass');   %coeficientes del filtro, Numerador

%% Filtrando con la función filtroFir()

Y1 = filter(b, a, y);
figure(3);
plot(Y1);
title('Filtrado con fir1() de Matlab');
figure(4);
plot(abs(fft(Y1)));
title('Filtrado con fir1() de Matlab');

Y2 = filtroFir(b, y);
figure(5);
plot(Y2);
title('Filtrado con filtroFir() de robercrash');
figure(6);
plot(abs(fft(Y2)));
title('Filtrado con filtroFir() de robercrash');

%% Calculando coeficientes de Filtro IIR tipo butterworth
[b, a] = tf(butterTest);

%Filtrando con la funcion filtroIir1()
Y4 = filter(b, a, y);
Y5 = filtroIir1(b, a, y);
figure(7);
plot(Y4);
title('Filtro IIR tipo Butterworth');
figure(8);
plot(abs(fft(Y4)));
title('Filtro IIR tipo Butterworth');


figure(9);
plot(Y5);
title('Filtro IIR forma Directa 1 tipo Butterworth by Crash');
figure(10);
plot(abs(fft(Y5)));
title('Filtro IIR forma Directa 1 tipo Butterworth by Crash');

%% Calculando coeficientes de Filtro IIR tipo butterworth
[b, a] = tf(butterTest);

%Filtrando con la funcion filtroIir2()
Y6 = filter(b, a, y);
Y7 = filtroIir2(b, a, y);
figure(11);
plot(Y6);
title('Filtro IIR tipo Butterworth');
figure(12);
plot(abs(fft(Y6)));
title('Filtro IIR tipo Butterworth');


figure(13);
plot(Y7);
title('Filtro IIR forma Directa 2 tipo Butterworth by Crash');
figure(14);
plot(abs(fft(Y7)));
title('Filtro IIR forma Directa 2 tipo Butterworth by Crash');
