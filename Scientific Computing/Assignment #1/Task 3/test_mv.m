A = rand(m,n);
b = rand(n,1);
h_ij = @() mv_ij(A,b);
h_ji = @() mv_ji(A,b);
h_c = @() mtimes(A,b);
time_ij = timeit(h_ij);
time_ji = timeit(h_ji);
time_c = timeit(h_c);
total_flops = 2*m*n;
mflops_ij = (total_flops/time_ij)*10e-6;
mflops_ji = (total_flops/time_ji)*10e-6;
mflops_c = (total_flops/time_c)*10e-6;
disp(sprintf('Computing Matrix Vector Multiplication c = A*b'))
disp(sprintf(' Number of Matrix rows m = %i',m))
disp(sprintf(' Number of Matrix columns n = %i',n))
disp(sprintf(' Number of floating point operations = %i\n',total_flops))
disp(sprintf(' Method\t\tCpu Seconds\t\tMegaFlops')) 
disp(sprintf(' --------\t--------------\t--------------'))
disp(sprintf(' IJ\t\t\t%d\t%i',time_ij,round(mflops_ij)))
disp(sprintf(' JI\t\t\t%d\t%i',time_ji,round(mflops_ji)))
disp(sprintf(' Ac\t\t\t%d\t%i',time_c,round(mflops_c)))
