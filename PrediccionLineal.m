%% Incialización de Variables necesarias
clear all;
%close all;

[y, Fs] = audioread('noSonoro-2.wav');

figure(1);
plot(y);
title('Señal de Entrada');
figure(2);
plot(abs(fft(y)));
title('Señal de Entrada');

tamanoDeVentana = 128;
noDeVentanas = length(y)/tamanoDeVentana;
p = 8;
win = hamming(128);                             
%% 1) Aplicando filtro de Pre-énfasis a la señal con a = 0.95

yP = preEnfasis(y, 0.95);

figure(3);
plot(yP);
title('Señal filtrada con preEnfasis()');
figure(4);
plot(abs(fft(yP)));
title('Señal filtrada con preEnfasis()');


%% 2) Aplicando ventana de Hamming a cada trama de la señal
yV = ventaneo('hamming', 128, yP) ;

%yVmatlab = win .* yP(1:128);

figure(5);
plot(yV);
title('Señal después de ventaneo()');
figure(6);
plot(abs(fft(yV)));
title('Señal después de ventaneo()');


%% 3) Calculo de Autocorrelación
r = zeros(1, noDeVentanas * p);                 % tendremos p coeficientes por cada ventana
yV = ones(1, 16000);

for i=1: 1: noDeVentanas
    
    for k=1: 1 :p
        
        for m=1: 1: tamanoDeVentana - (k - 1)
        
            % Nomenclatura de la práctica 5
            %      r(k)        =       r(k)         + (              s(m)                   *                  s(m + k) )
            r( k + (i-1) * p ) = r( k + (i-1) * p ) + ( yV( m + ( (i-1) * tamanoDeVentana) ) * yV( ( m + ( (i-1) * tamanoDeVentana) ) + (k-1) ) );
            
        end

    end
    
end

%% Calculando LPC's con algoritmo Levinson-Durbin

E(1) = r(1);
%Alpha = ones(10, 10);


for i=2: 1: p+1 % lo correcto es hasta p+1         
    
    alphaSum = 0;
    
    for j=1: 1: i-1
    
        %alphaSum = alphaSum  + ( Alpha(i-1, j) * r( (i-j) ) );
        fprintf('Alpha(%d, %d) * r(%d) -- AQUI!\n\n', (i-1), j, (i-j));    
    
    end
    
    %k(i) = ( r(i) - alphaSum ) / E(i - 1);
    fprintf('alphaSum = %f\n', alphaSum);
    fprintf('k(%d) = r(%d) - alphaSum / E(%d)\n\n', i, i, (i-1));

    %Alpha(i, i) = k(i);
    fprintf('Alpha(%d, %d) = k(%d)\n\n',i, i, i);
    
    
    for j=1: 1: i-1
    
        %Alpha(i, j) = Alpha(i-1, j) - ( k(i) * Alpha(i-1, i-j) ); 
        fprintf('Alpha(%d, %d) = Alpha(%d, %d) - ( k(%d) * Alpha(%d, %d) )\n',i , j, i-1, j, i, i-1, i-j);
    
    end
    
    %E(i) = (1 - (k(i)^2) ) * E(i-1);
    fprintf('\nE(%d) = (1 - (k(%d))^2 ) * E(%d)\n\n\n\n', i, i, i-1);
    
end