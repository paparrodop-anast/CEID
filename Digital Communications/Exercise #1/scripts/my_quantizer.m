function [xq,centers,p,D] = my_quantizer(x,N,max_value,min_value)
% Uniform Quantizer N bits, 2^N levels
% 	input:
% 		x 		: dianysma deigmatwn shmatos eisodoy
% 		N 		: o arithmos twn bits
% 		max_value 	: megisti timi dinamikis perioxis [min_value,max_value]
%		min_value 	: elaxisti timi dinamikis perioxis [min_value,max_value]
% 					
% 	output:
% 		xq 		: dianysma me to kvadismeno shma eksodou
% 		centers 	: dianysma me ta kedra twn perioxwn
% 					kvadisis
% 		p 		: dianysma me tis pithanotites emfanisis
% 					kathe kedrou toy kvantisti
% 		D 		: h Paramorfwsi
lenx = length(x);
stathmes = 2^N;
b = (max_value+abs(min_value))/stathmes; %euros statmis
a = zeros(stathmes+1,1);               %desmeusi gia to dianisma twn ai
centers = zeros(stathmes,1);           %desmeusi gia to dianisma twn kedrwn
p = zeros(stathmes,1);                 %desmeusi gia to dianisma pithanotitwn
c = zeros(stathmes,1);                 %dianisma gia to plithos emfanisis tou kathe kedrou
 
%% ----- Ypologismos ai ----- %%
a(1) = min_value;
for i=2:stathmes+1
    a(i) = a(1) + (i-1)*b;
end
 
%% ----- Ypologismos kedrwn ----- %%
for i=1:stathmes
    centers(i) = ( a(i) + a(i+1) ) / 2;
end
 
 
%% Kvadisi dld Q(x) = center(i) gia kathe x e Ri %%
for i=1:lenx
    quantum = 0;
    j=1;
    while (j<=stathmes) && (quantum==0)
        
        if  ( ( x(i)>=a(j) ) && ( x(i)<a(j+1)) )
                xq(i) = centers(j);
                
                c(j) = c(j) + 1;
                quantum = 1;
        else
                j = j+1;
        end
         
    end
end   
xq = xq';
 
%% Ypologismos Pithanotitas %%
for i=1:stathmes
    p(i) = c(i) / length(xq);
end
 
%% Paramorfwsi %%
D = mean((x-xq).^2);
