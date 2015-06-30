function [ Y ] = filtroIir2( b, a, x )

%filtroIir2() Regresa un vector con la señal filtrada a traves de un filtro
%IIR con la forma Directa 2

%Bibliografia: https://ccrma.stanford.edu/~jos/fp/Direct_Form_II.html

M = length(b);                                      %longitud del filtro
N = length(a);                                      %longitud del filtro
Y = zeros(length(x), 1);       

for n=1: 1: length(x)
    
    %bSum = 0;
    aSum = 0;
    
    for k=2: 1: N
        
        if (n - (k-1)) <= 0
            aSum = aSum + ( a(k) * 0 );
        else
            aSum = aSum + ( a(k) * w(n - (k-1)) );
        end
    end
    
    w(n) = x(n) - aSum;
    
    for k=1: 1: M
        
        if (n - (k-1)) <= 0
            Y(n) = Y(n) + ( b(k) * 0 );
        else
            Y(n) = Y(n) + ( b(k) * w(n - (k-1)) );
        end
        
    end

end

