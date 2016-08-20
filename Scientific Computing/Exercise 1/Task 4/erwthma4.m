n = [50 100 200 400 800];
time_c = zeros(1,5);
for i=1:5
    A = rand(n(i));
    b = rand(n(i),1);
    h_c = @() mtimes(A,b);
    time_c(i) = timeit(h_c,1);
end
%
A1 = polyfit(n,time_c,1);
A2 = polyfit(n,time_c,2);
A3 = polyfit(n,time_c,3);
A4 = polyfit(n,time_c,4);
%
B1 = polyval(A1,n);
B2 = polyval(A2,n);
B3 = polyval(A3,n);
B4 = polyval(A4,n);
%
time_c1 = time_c./n;
time_c2 = time_c./(n.^2);
time_c3 = time_c./(n.^3);
time_c4 = time_c./(n.^4);
%
figure
subplot(2,2,1);
semilogy(n,time_c1,'*-','LineWidth',2);
title('t/n'); xlabel('n'); ylabel('sec');
subplot(2,2,2);
semilogy(n,time_c2,'*-','LineWidth',2);
title('t/n^2'); xlabel('n'); ylabel('sec');
subplot(2,2,3);
semilogy(n,time_c3,'*-','LineWidth',2);
title('t/n^3'); xlabel('n'); ylabel('sec');
subplot(2,2,4);
semilogy(n,time_c4,'*-','LineWidth',2);
title('t/n^4'); xlabel('n'); ylabel('sec');
