n = [200 400 600 800 1000 1200];
t1 = zeros(6,1);
t2 = zeros(6,1);
t3 = zeros(6,1);
t4 = zeros(6,1);
for i=1:1:6
    R = rand(n(i));
    flu = @() lu(R);
    t1(i) = timeit(flu,2);    
end
for i=1:1:6
    R = rand(n(i));
    fqr = @() qr(R);
    t2(i) = timeit(fqr,2);  
end
for i=1:1:6
    R = rand(n(i));
    fsvd = @() svd(R);
    t3(i) = timeit(fsvd,3);   
end
for i=1:1:6
    R = rand(n(i));
    feig = @() eig(R);
    t4(i) = timeit(feig,2);   
end
figure
plot(n,t1,'*-',n,t2,'^-',n,t3,'+-',n,t4,'x-');
legend('lu','qr','svd','eig','Location','Best');
xlabel('n');
ylabel('time(sec)');
title('2.ii.a');
grid on;