function [y] = mv_ij(A,x);
[m,n]= size(A);
for i=1:m 
    y(i) = 0;
end;
for i = 1:m
    for j = 1:n
        y(i) = y(i) + A(i,j)*x(j);
    end
end
    