function [W] = st_condrand_3873(n,kappa)

% Calling condrand_3873 to create an appropriate matrix.
[A] = sym_condrand_3873(n,kappa);
% Calculating tridiagonal Hessenberg form of matrix A.
F = hess(A);
% Creating a zero matrix W and saving the values of the 3 main diagonal of matrix F. 
W = zeros(n);
W = diag(diag(F)) + diag(diag(F,-1),-1) + diag(diag(F,1),1);
% Printing the final condition number.
c_n_w = cond(W);
fprintf('Final condition number: %d\n',c_n_w);

end