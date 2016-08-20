x = wavread('speech.wav');
max_value = max(x);
min_value = min(x);
 
N = 2;
[xq,centers,p,D] = my_quantizer(x,N,max_value,min_value);
 
SQNR = mean(x.^2)/D;
sprintf('Distortion: %0.3g \nSQNR: %0.3g',D,SQNR)

figure;
plot(xq);
ylabel('Uniform Quantum Output N=2 bits');
 
N = 4;
[xq,centers,p,D] = my_quantizer(x,N,max_value,min_value);
 
SQNR = mean(x.^2)/D;
sprintf('Distortion: %0.3g \nSQNR: %0.3g',D,SQNR)

figure;
plot(xq);
ylabel('Uniform Quantum Output N=4 bits');
 
N = 8;
[xq,centers,p,D] = my_quantizer(x,N,max_value,min_value);
 
SQNR = mean(x.^2)/D;
sprintf('Distortion: %0.3g \nSQNR: %0.3g',D,SQNR)
 
figure;
plot(xq);
ylabel('Uniform Quantum Output N=8 bits');
