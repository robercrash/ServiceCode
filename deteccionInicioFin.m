
clear all;
clc;

[y, Fs] = audioread('noSonoro-2.wav'); %avanza-4 tiene sonido no sonoro al inicio
                                      %detente-9 tiene sonido no sonoro al
                                        %final                                        
                                        
tamanoDeVentana = 128;
noDeVentanas = length(y)/tamanoDeVentana;

%%%%%%%%%%%%%%%%%%%%%% DETECCION DE INICIO DE PALABRA %%%%%%%%%%%%%%%%%%%%%%

%1) Calculo de Valor Promedio
Mn = zeros(1, noDeVentanas);

for i=1: 1: noDeVentanas
    
    for j=1: 1: tamanoDeVentana        
        %fprintf('Valor Promedio\n\nVentana: %d\nMuestra: %d\n\n', i, j + ( (i-1) * tamanoDeVentana) );
        Mn(i) = Mn(i) + abs( y(j + ( (i-1) * tamanoDeVentana)) ); 
        
    end
    
end 

MnF = valorPromedio(y, noDeVentanas, tamanoDeVentana);

%1) Calculo de Cruce por Ceros
Zn = zeros(1, noDeVentanas);

for i=1: 1: noDeVentanas-1
    
    for j=1: 1: tamanoDeVentana        
        
        Zn(i) = Zn(i) + abs( sign( y((j + ( (i-1) * tamanoDeVentana)) + 1) ) - sign( y(j + ( (i-1) * tamanoDeVentana)) ) ); 
        
    end
        
end

Zn = Zn/(2 * noDeVentanas);

%2) Estadisticas para el ruido ambiental
Ms = Mn(1:10);
Zs = Zn(1:10);

%3) Calculando Umbrales
UmbSupEnrg = 0.5 * max(Mn);                 %TO DO funcion max(), median() y std()
UmbInfEnrg = median(Ms) + ( 2 * std(Ms) );
UmbCruCero = median(Zs) + ( 2 * std(Zs) );


%4.1) Recorriendo la funcion Mn para encontrar ln
ln = 0;
n = 11;
while Mn(n) < UmbSupEnrg
    n = n + 1;
end
ln = n;

%5.1) Recorriendo la funcion Mn para encontrar le 
while Mn(n) > UmbInfEnrg
   n = n - 1; 
end
le = n; %Inicio de Señal determinado por la Funcion de Magnitud

% NOTA: Antes de inciar esta condicion de bemos asegurar que n = le
%6.1) Condiciones para encontrar sonidos no sonoros

noDeValoresSuperioresAlUmbral = 0;
limiteDeValoresSuperioresAlUmbralTolerados = 3;
limiteDeVentanasPosterioresEnRevision = 25;
posiblesSonidosNoSonoros = [0, 0, 0];

while n > 11 && n ~= (le - limiteDeVentanasPosterioresEnRevision)
    
    if  Zn(n) < UmbCruCero      % El inicio sigue siendo le
        
    elseif Zn(n) > UmbCruCero   % Debemos contar cuantas veces supera el umbral antes del Inicio le
        
        noDeValoresSuperioresAlUmbral = noDeValoresSuperioresAlUmbral + 1;
        posiblesSonidosNoSonoros(noDeValoresSuperioresAlUmbral) = n;
        
        if noDeValoresSuperioresAlUmbral >= limiteDeValoresSuperioresAlUmbralTolerados; % Evaluamos si son consecutivos o no
            disp(posiblesSonidosNoSonoros);                 
            
            % Si la diferencia entre el indice del valor actual y el indice dos lugares antes es igual a 2 se trata de 3 valores consecutivos
            if( (posiblesSonidosNoSonoros(noDeValoresSuperioresAlUmbral - 2) - posiblesSonidosNoSonoros(noDeValoresSuperioresAlUmbral)) == 2)
                  fprintf('Existen valores consecutivos entre: %d y %d', posiblesSonidosNoSonoros(noDeValoresSuperioresAlUmbral - 2), posiblesSonidosNoSonoros(noDeValoresSuperioresAlUmbral));
                  le = posiblesSonidosNoSonoros(noDeValoresSuperioresAlUmbral);
                  fprintf(' Asignamos nuevo inicio de Palabra a lz = %f\n',le);
            end
        end
    end
    
    n = n - 1;
end

inicio = le;

%%%%%%%%%%%%%%%%%%%%%% DETECCION DE FIN DE PALABRA %%%%%%%%%%%%%%%%%%%%%%

%4.2) Recorriendo (en direccion opuesta) la funcion Mn para encontrar ln
ln = 0;
n = noDeVentanas;
while Mn(n) < UmbSupEnrg
    n = n - 1;
end
ln = n;

%5.2) Recorriendo (en direccion opuesta) la funcion Mn para encontrar le 
while Mn(n) > UmbInfEnrg && n < noDeVentanas
   n = n + 1; 
end
le = n; %Fin de Señal determinado por la Funcion de Magnitud

% NOTA: Antes de inciar esta condicion de bemos asegurar que n = le
%6.2) Condiciones para encontrar sonidos no sonoros

noDeValoresSuperioresAlUmbral = 0;
limiteDeValoresSuperioresAlUmbralTolerados = 3;
limiteDeVentanasPosterioresEnRevision = 25;
posiblesSonidosNoSonoros = [0, 0, 0];

while n < noDeVentanas && n ~= (le + limiteDeVentanasPosterioresEnRevision)
    
    if  Zn(n) < UmbCruCero      % El fin sigue siendo le
        
    elseif Zn(n) > UmbCruCero   % Debemos contar cuantas veces supera el umbral antes del Inicio le
        
        noDeValoresSuperioresAlUmbral = noDeValoresSuperioresAlUmbral + 1;
        posiblesSonidosNoSonoros(noDeValoresSuperioresAlUmbral) = n;
        
        if noDeValoresSuperioresAlUmbral >= limiteDeValoresSuperioresAlUmbralTolerados; % Evaluamos si son consecutivos o no
            disp(posiblesSonidosNoSonoros);                 
            
            % Si la diferencia entre el indice del valor actual y el indice dos lugares antes es igual a 2 se trata de 3 valores consecutivos
            if( (posiblesSonidosNoSonoros(noDeValoresSuperioresAlUmbral) - posiblesSonidosNoSonoros(noDeValoresSuperioresAlUmbral - 2)) == 2)
                  fprintf('Existen valores consecutivos entre: %d y %d', posiblesSonidosNoSonoros(noDeValoresSuperioresAlUmbral - 2), posiblesSonidosNoSonoros(noDeValoresSuperioresAlUmbral));
                  le = posiblesSonidosNoSonoros(noDeValoresSuperioresAlUmbral);
                  fprintf(' Asignamos nuevo fin de Palabra a lz = %f\n',le);
            end
        end
    end
    
    n = n + 1;
end

fin = le;

% Muestra de Resultados
clf
figure(1); 
subplot(3, 1, 1);
plot(y);
title('Señal Original');

line([(inicio * tamanoDeVentana) (inicio * tamanoDeVentana)],get(gca,'YLim'), 'Color', [1 0 0]); % Inicio de palabra
line([(fin * tamanoDeVentana) (fin * tamanoDeVentana)],get(gca,'YLim'), 'Color', [1 0 0]); % Fin de palabra
line(get(gca,'XLim'), [UmbInfEnrg UmbInfEnrg], 'Color', [0 1 0]);                           
line(get(gca,'XLim'), [-UmbInfEnrg -UmbInfEnrg], 'Color', [0 1 0]);

subplot(3, 1, 2);
plot(Mn);
title('Magnitud');
line([inicio inicio],get(gca,'YLim'), 'Color', [1 0 0]);
line([fin fin],get(gca,'YLim'), 'Color', [1 0 0]);
line(get(gca,'XLim'), [UmbInfEnrg UmbInfEnrg], 'Color', [0 1 0]);                           

subplot(3, 1, 3);
plot(Zn);
title('Señal Original');
line([inicio inicio],get(gca,'YLim'), 'Color', [1 0 0]);
line([fin fin],get(gca,'YLim'), 'Color', [1 0 0]);
line(get(gca,'XLim'), [UmbInfEnrg UmbInfEnrg], 'Color', [0 1 0]);                           

%{
yReducida = y( ((inicio - 1) * tamanoDeVentana) : ((fin - 1) * tamanoDeVentana) );
sound(y, Fs);
pause();
sound(yReducida, Fs);
%}



