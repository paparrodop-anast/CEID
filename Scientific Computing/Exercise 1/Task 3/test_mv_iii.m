m = 2.^[4:2:10];
n = m;
time_ij = zeros(4,4);
time_ji = zeros(4,4);
time_c = zeros(4,4);
total_flops = zeros(4,4);
mflops_ij = zeros(4,4);
mflops_ji = zeros(4,4);
mflops_c = zeros(4,4);
for x=1:4
    for y=1:4
        A = rand(m(x),n(y));
        b = rand(n(y),1);
        h_ij = @() mv_ij(A,b); 
        h_ji = @() mv_ji(A,b);
        h_c = @() mtimes(A,b);
        time_ij(x,y) = timeit(h_ij);
        time_ji(x,y) = timeit(h_ji);
        time_c(x,y) = timeit(h_c);
        total_flops(x,y) = 2*m(x)*n(y);
        mflops_ij(x,y) = (total_flops(x,y)/time_ij(x,y))*10e-6;
        mflops_ji(x,y) = (total_flops(x,y)/time_ji(x,y))*10e-6;
        mflops_c(x,y) = (total_flops(x,y)/time_c(x,y))*10e-6;
        disp(sprintf('Computing Matrix Vector Multiplication c = A*b'))
        disp(sprintf(' Number of Matrix rows m = %i',m(x)))
        disp(sprintf(' Number of Matrix columns n = %i',n(y)))
        disp(sprintf(' Number of floating point operations = %i\n',total_flops(x,y)))
        disp(sprintf(' Method\t\tCpu Seconds\t\tMegaFlops')) 
        disp(sprintf(' --------\t--------------\t--------------'))
        disp(sprintf(' IJ\t\t\t%d\t%i',time_ij(x,y),round(mflops_ij(x,y))))
        disp(sprintf(' JI\t\t\t%d\t%i',time_ji(x,y),round(mflops_ji(x,y))))
        disp(sprintf(' Ac\t\t\t%d\t%i',time_c(x,y),round(mflops_c(x,y))))
    end
end
%
figure;
subplot(2,2,1);
plot(n,time_ij(1,:),'*-',n,time_ji(1,:),'+-',n,time_c(1,:),'d-','LineWidth',2);
title('m=2^4'); xlabel('n'); ylabel('sec');
legend('ij','ji','c','Location','Best');
grid on;
subplot(2,2,2);
plot(n,time_ij(2,:),'*-',n,time_ji(2,:),'+-',n,time_c(2,:),'d-','LineWidth',2);
title('m=2^6'); xlabel('n'); ylabel('sec');
legend('ij','ji','c','Location','Best');
grid on;
subplot(2,2,3);
plot(n,time_ij(3,:),'*-',n,time_ji(3,:),'+-',n,time_c(3,:),'d-','LineWidth',2);
title('m=2^8'); xlabel('n'); ylabel('sec');
legend('ij','ji','c','Location','Best');
grid on;
subplot(2,2,4);
plot(n,time_ij(4,:),'*-',n,time_ji(4,:),'+-',n,time_c(4,:),'d-','LineWidth',2);
title('m=2^{10}'); xlabel('n'); ylabel('sec');
legend('ij','ji','c','Location','Best');
grid on;
%
figure;
subplot(2,2,1);
plot(n,mflops_ij(1,:),'*-',n,mflops_ji(1,:),'+-',n,mflops_c(1,:),'d-','LineWidth',2);
title('m=2^4'); xlabel('n'); ylabel('Mflop/s');
legend('ij','ji','c','Location','Best');
grid on;
subplot(2,2,2);
plot(n,mflops_ij(2,:),'*-',n,mflops_ji(2,:),'+-',n,mflops_c(2,:),'d-','LineWidth',2);
title('m=2^6'); xlabel('n'); ylabel('Mflop/s');
legend('ij','ji','c','Location','Best');
grid on;
subplot(2,2,3);
plot(n,mflops_ij(3,:),'*-',n,mflops_ji(3,:),'+-',n,mflops_c(3,:),'d-','LineWidth',2);
title('m=2^8'); xlabel('n'); ylabel('Mflop/s');
legend('ij','ji','c','Location','Best');
grid on;
subplot(2,2,4);
plot(n,mflops_ij(4,:),'*-',n,mflops_ji(4,:),'+-',n,mflops_c(4,:),'d-','LineWidth',2);
title('m=2^{10}'); xlabel('n'); ylabel('Mflop/s');
legend('ij','ji','c','Location','Best');
grid on;
