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
    elapsed = 0;
    for k=1:1:30
        tic;
        [L,U] = lu(R);
        elapsed = elapsed + toc;
    end    
    t1(i) = elapsed/30;    
end
for i=1:1:6
    R = rand(n(i));
    tic;
    toc;
    [Q,R] = qr(R);
    elapsed = 0;
    for k=1:1:25
        tic;
        [Q,R] = qr(R);
        elapsed = elapsed + toc;
    end    
    t2(i) = elapsed/25;   
end
for i=1:1:6
    R = rand(n(i));
    tic;
    toc;
    [U,S,V] = svd(R);
    elapsed = 0;
    for k=1:1:20
        tic;
        [U,S,V] = svd(R);
        elapsed = elapsed + toc;
    end    
    t3(i) = elapsed/20;   
end
for i=1:1:6
    R = rand(n(i));
    tic;
    toc;
    [V,D] = eig(R);
    elapsed = 0;
    for k=1:1:15
        tic;
        [V,D] = eig(R);
        elapsed = elapsed + toc;
    end    
    t4(i) = elapsed/15;    
end
figure
plot(n,t1,'*-',n,t2,'^-',n,t3,'+-',n,t4,'x-');
legend('lu','qr','svd','eig','Location','Best');
xlabel('n');
ylabel('time(sec)');
title('2.ii.a');
grid on;