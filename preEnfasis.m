function [ Y ] = preEnfasis( x, a )

% preEnfasis() aplica un filtro de pre-énfasis a la señal x con el
% coeficiente con la a indicada. Comunmente 0.9 < a < 1.0
Y = zeros(1, length(x));

for i=2: 1: length(x)
    
    Y(i) = x(i) - (a * x(i-1));
  
end

end

