x = wavread('speech.wav');
max_value = max(x);
min_value = min(x);
 
N=2;
[xq,centers,D,iter] = Lloyd_Max(x,N,max_value,min_value);
SQNR = mean(x.^2)./D;
figure;
plot(SQNR);
display(iter);
title( [ 'LloydMax SQNR N=', num2str(N)]);
ylabel('SQNR');
xlabel('iterations');
figure;
plot(xq);
title( [ 'LloydMax  N=', num2str(N)]);
ylabel('signal');
 
N=4;
[xq,centers,D,iter] = Lloyd_Max(x,N,max_value,min_value);
SQNR = mean(x.^2)./D;
figure;
plot(SQNR);
display(iter);
title( [ 'LloydMax SQNR N=', num2str(N)]);
ylabel('SQNR');
xlabel('iterations');
figure;
plot(xq);
title( [ 'LloydMax  N=', num2str(N)]);
ylabel('signal');
 
N=8;
[xq,centers,D,iter] = Lloyd_Max(x,N,max_value,min_value);
SQNR = mean(x.^2)./D;
figure;
plot(SQNR);
display(iter);
title( [ 'LloydMax SQNR N=', num2str(N)]);
ylabel('SQNR');
xlabel('iterations');
figure;
plot(xq);
title( [ 'LloydMax  N=', num2str(N)]);
ylabel('signal');

