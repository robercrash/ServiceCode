function [ Mn ] = valorPromedio(y, n, m )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    Mn = zeros(1, n);
    
    for i=1: 1: n
    
        for j=1: 1: m  
            
            Mn(i) = Mn(i) + abs( y(j + ( (i-1) * m)) ); 

        end
        
    end 
    
end

