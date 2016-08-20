function [y] = mv_ji(A,x);
[m,n]= size(A);
for i=1:m 
    y(i) = 0;
end; 
for j = 1:n
    for i = 1:m
        y(i) = y(i) + A(i,j)*x(j);
    end
end