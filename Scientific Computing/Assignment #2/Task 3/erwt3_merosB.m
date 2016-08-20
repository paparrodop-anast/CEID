x = [(1+eps) (1+10^(-8)) 1.5 5.5 (9+10^(-8)) (9+eps(9))];
z = (1:10);
p = poly(z);
results_dynamic = zeros(1,6);
results_product = zeros(1,6);
relative_error = zeros(1,6);
prod_sum = zeros(1,6);
condition_number = zeros(1,6);
error_g = (2*10*eps)/(1-2*10*eps);
condition_and_back = zeros(1,6);
for i=1:6
    results_dynamic(i) = polyval(p,x(i));
    results_product(i) = prod(x(i)-(1:10));
    relative_error(i) = abs(results_dynamic(i)-results_product(i))/abs(results_product(i));
    for n=1:11
        prod_sum(i) = prod_sum(i)+abs(p(n))*abs(x(i)^(11-n));
    end
    condition_number(i) = prod_sum(i)/abs(results_product(i));
    condition_and_back(i) = condition_number(i)*error_g;
end
disp('x'); disp(x)
disp('dynamic'); disp(results_dynamic)
disp('product'); disp(results_product)
disp('relative_error'); disp(relative_error)
disp('condition number'); disp(condition_number)
disp('condition * back error'); disp(condition_and_back)