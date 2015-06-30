function [ Y ] = ventaneo(tipo, tamanoDeVentana ,x )

% Regresa una señal Y despues de aplicarle una ventana del 
% 'tipo' y tamaño indicados a la señal x de entrada 

Y = zeros(1, length(x));
win = zeros(1, tamanoDeVentana);
noDeVentanas = length(x)/tamanoDeVentana;

switch tipo
    case 'hamming'
        win = hamming(tamanoDeVentana);
    case 'hanning'
        win = hann(tamanoDeVentana);
    case 'blackman'
        win = blackman(tamanoDeVentana);
    otherwise
        disp('Tipo de ventana INCORRECTO');
end

for i=1: 1: noDeVentanas
    
    for j=1: 1: tamanoDeVentana
        
        Y( j + ((i - 1) * tamanoDeVentana) ) = x( j + ((i - 1) * tamanoDeVentana) ) * win( j ); 

    end
    
end

end

