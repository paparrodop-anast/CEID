x = wavread('speech.wav');
max_value = 1;
display('Huffman encoding');
display('=====================');
display('Uniform N=4');
N=4;
[xq,p] = my_quantizer(x,N,max_value,min_value);
[code,len] = huffman(p);
%Apodotikotita = H(X)/L_meso
%H(X): endropia pigis , L_meso: meso mikos kwdika
L_meso = mikos_kwdika(p,len);
H = edropia(p);
perf_u4 = H/L_meso;
display(perf_u4);
display('Uniform N=6');
N=6;
[xq,p] = my_quantizer(x,N,max_value,min_value);
[code,len] = huffman(p);
%Apodotikotita = H(X)/L_meso
%H(X): endropia pigis , L_meso: meso mikos kwdika
L_meso = mikos_kwdika(p,len);
H = edropia(p);
perf_u6 = H/L_meso;
display(perf_u6);
display('PCM m-type N=4');
N=4;
[x_new,D,SQNR,p] = test_nonuni_m(N);
[code,len] = huffman(p);
L_meso = mikos_kwdika(p,len);
H = edropia(p);
perf_m4 = H/L_meso;
display(perf_m4);
display('PCM m-type N=6');
N=6;
[x_new,D,SQNR,p] = test_nonuni_m(N);
[code,len] = huffman(p);
L_meso = mikos_kwdika(p,len);
H = edropia(p);
perf_m6 = H/L_meso;
display(perf_m6);
display('PCM A-type N=4');
N=4;
[xq,p] = compress_a(N);
[code,len] = huffman(p);
L_meso = mikos_kwdika(p,len);
H = edropia(p);
perf_a4 = H/L_meso;
display(perf_a4);
display('PCM A-type N=6');
N=6;
[xq,p] = compress_a(N);
[code,len] = huffman(p);
L_meso = mikos_kwdika(p,len);
H = edropia(p);
perf_a6 = H/L_meso;
display(perf_a6);
display('Lloyd-Max N=4');
N=4;
[xq, centers, D] = Lloyd_Max(x,N,max_value,min_value);
p = Lloyd_probs(xq);
[code,len] = huffman(p);
L_meso = mikos_kwdika(p,len);
H = edropia(p);
perf_ld4 = H/L_meso;
display(perf_ld4);
display('Lloyd-Max N=6');
N=6;
[xq, centers, D] = Lloyd_Max(x,N,max_value,min_value);
p = Lloyd_probs(xq);
[code,len] = huffman(p);
L_meso = mikos_kwdika(p,len);
H = edropia(p);
perf_ld6 = H/L_meso;
display(perf_ld6);