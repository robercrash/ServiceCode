
clear all;
close all;

fs= 8e3;
f1 = 1.8e1;
f2 = 3.5e3;
fc = 2.5e3;
Wc = fc/(fs/2);



t = 0:1/fs:1;
x = sin(2* pi * f1 *  t) + sin(2* pi * 0 *  t);
tam = size(x);
n = 0.5 * randn(tam);
x = x + n;
figure(1),plot(x);

X = fft(x);
figure(2),plot(abs(X));

%%
% Calculando los coeficientes de filtro fir
% usando FIR1.
N    = 100;      % Order
flag = 'scale';  % Sampling Flag

win = hamming(N+1);

Num  = fir1(N, Wc, 'low', win, flag);
y = filter(Num,1,x);
figure(3),plot(y)

Y = fft(y);
figure(4),plot(abs(Y));

%%
%%Filtro IIR

Fpass = 0.00625;     % Passband Frequency
Fstop = 0.00825;     % Stopband Frequency
Apass = 1;           % Passband Ripple (dB)
Astop = 10;          % Stopband Attenuation (dB)
match = 'stopband';  % Band to match exactly

% Construct an FDESIGN object and call its BUTTER method.
h  = fdesign.lowpass(Fpass, Fstop, Apass, Astop);
Hd = design(h, 'butter', 'MatchExactly', match);

% Get the transfer function values.
[b, a] = tf(Hd);

y=filter(b,a,x);
figure(5),plot(y)

Y = fft(y);
figure(6),plot(abs(Y));