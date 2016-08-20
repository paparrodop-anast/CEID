n = [200 400 600 800 1000 1200];
t1 = zeros(6,1);
t2 = zeros(6,1);
t3 = zeros(6,1);
t4 = zeros(6,1);
for i=1:1:6
    R = rand(n(i));
    tic;
    toc;
    [L,U] = lu(R);
    tic;
    [L,U] = lu(R);
    t1(i) = toc;    
end
for i=1:1:6
    R = rand(n(i));
    tic;
    toc;
    [Q,R] = qr(R);
    tic;
    [Q,R] = qr(R);
    t2(i) = toc;    
end
for i=1:1:6
    R = rand(n(i));
    tic;
    toc;
    [U,S,V] = svd(R);
    tic;
    [U,S,V] = svd(R);
    t3(i) = toc;    
end
for i=1:1:6
    R = rand(n(i));
    tic;
    toc;
    [V,D] = eig(R);
    tic;
    [V,D] = eig(R);
    t4(i) = toc;    
end
figure
plot(n,t1,'*-',n,t2,'^-',n,t3,'+-',n,t4,'x-');
legend('lu','qr','svd','eig','Location','Best');
xlabel('n');
ylabel('time(sec)');
title('2.ii.a');
grid on;