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
%yV = ones(1, 16000);

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

k = zeros(1, noDeVentanas * p);                         %Vector de Coeficientes de Reflexion
alpha = zeros (noDeVentanas * p, noDeVentanas * p);
E = zeros(1, noDeVentanas * p); 
a = zeros(1, noDeVentanas * p);

for h=1: 1: 1
    
    E(1) = r(1);

    for i=2: 1: p 

        alphaSum = 0;

        for j=1: 1: p - 1

            if(i-j) <= 0
                alphaSum = alphaSum + ( alpha(i-1, j) * 0 );
            else
                alphaSum = alphaSum + ( alpha(i-1, j) * r(i-j) ); 
            end
%             fprintf('alpha( %d, %d) * ', i-1, j);             %Verificacion del recorrido de alpha(n)
%             fprintf('r(%d)\n', i - j);                    %Verificacion del recorrido de r(n)
        end
%         fprintf('\n\n', alphaSum);             %Needed for debuging para Verificacion de recorridos

        k(i-1) = (r(i-1) - alphaSum) / E(i-1);
        alpha(i-1, i-1) = k(i-1);
        
        for j=1: 1: i-1
            
            alpha(i, j) = alpha(i-1, j) - ( k(i) * alpha(i-1, i-j) );
            
        end
    %     
    %     E(i) = (1 - (k(i)^2)) * E( (i+1) - 1 );

    end

end



% a = zeros(1, noDeVentanas * p);
% an = zeros(1, noDeVentanas * p);
% 
% % R[i] - autocorrelation coefficients
% % R(i) --> r(i) 
% 
% % A[i] - filter coefficients
% % A(i) --> a(i)
% 
% % K - reflection coefficients
% % K --> k
% 
% % Alpha - prediction gain
% % Alpha --> alpha 
% 
% % initialization 
% 
% % A[0] = 1
% a(1) = 1;
% %K = -R[1]/R[0]
% k = -r(2) / r(1);
% %A[1] = K
% a(2) = k;
% %Alpha = R[0]* (1-K^2)
% alpha = r(1) * ( 1 - (k^2) );
% 
% % For i = 2 To M
% % S = SUM(R[j]*A[i-j];j=1,i-1) + R[i]
% % K = -S/Alpha
% % An[j] = A[j] + K*A[i-j] /*for j=1 to i-1 where An[i] = new A[i]*/
% % An[i] = K
% % Alpha = Alpha * (1-K^2)
% % End
% 
% s = 0;
% 
% for i=2: 1: 8
%     
%     for j=1: 1: i-1
%         s = s + ( r(j) * a(i-j));  
%         k =  -s / alpha;
%         an(j) = a(j) + k * a(i-j);
%         an(i) = k;
%         alpha = alpha * (1-k^2);
%     end
%     
% end
