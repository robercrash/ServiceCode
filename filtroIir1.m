function [ Y ] = filtroIir1( b, a, x )

%filtroIir1() Regresa un vector con la señal filtrada a traves de un filtro
%IIR con la forma Directa 1

%Bibliografia: https://ccrma.stanford.edu/~jos/fp/Direct_Form_I.html

M = length(b);                                      %longitud del filtro
N = length(a);                                      %longitud del filtro
Y = zeros(length(x), 1);     

for n=1: 1: length(x) 
    
    bSum = 0;
    aSum = 0;
    
    for i=1: 1: M
        
        if (n - (i-1)) <= 0
            bSum = bSum + ( b(i) * 0 );
        else
            bSum = bSum + ( b(i) * x(n - (i-1)) );
        end
        
    end
    
    for j=2: 1: N
        
        if (n - (j-1)) <= 0
            aSum = aSum + ( a(j) * 0 );
        else
            aSum = aSum + ( a(j) * Y(n - (j-1)) );
            %fprintf('Y(%d) = %f\n',n - (j-1), Y(n - (j-1)) );
        end
        %fprintf('El aSum acumulado  con j=%d es %f\n', j, aSum);
    end
    
    Y(n) = bSum - aSum;
    
end 

end

