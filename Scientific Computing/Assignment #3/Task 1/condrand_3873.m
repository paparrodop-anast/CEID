function [A] = condrand_3873(n,kappa)

% Creating two random matrices.
M1 = rand(n);
M2 = rand(n);
% Calculating QR for matrices M1 and M2.
[Q1,R1] = qr(M1);
[Q2,R2] = qr(M2);
% Creating the diagonal of matrix D using a vector T.
T = zeros(n,1);
for i=1:n
    T(i) = kappa^(-(i-1)/(n-1));
end
D = diag(T);
% Calculating final matrix A.
A = Q1*D*Q2;
% Printing the given condition number and the generated one of matrix A.
fprintf('Given condition number: %d\n',kappa);
g_c_n = cond(A);
fprintf('Generated condition number: %d\n',g_c_n);

end