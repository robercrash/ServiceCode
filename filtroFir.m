function [ Y ] = filtroFir( b, x )

%filtroFir() Regresa un vector con la señal filtrada a traves de un filtro FIR

M = length(b);                                      %longitud del filtro
Y = zeros(length(x), 1);

for i=1: 1: length(x)
    
    for k=1: 1: M - 1                                  

        if((i - k) <= 0)
            Y(i) = Y(i) + ( b(k) * 0 );             %valores anteriores al inicio de la señal son iguales a 0
        else
            Y(i) = Y(i) + ( b(k) * x(i - k) );      %definicion para el filtro FIR
        end
        
    end
    
end

end

