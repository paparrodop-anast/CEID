function [xq,centers,D,iter] = Lloyd_Max(x,N,max_value,min_value)

% Mi Omiomorfos Kvadistis - Lloyd Max
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
% 		D 		: dianysma pou periexei tis times [D1:Dk_max] me Di h %					mesh paramorfwsi se kathe epanalipsi i tou 
%					algorithmou
  
levels=2.^N;                %arithmos epipedwn kvadisti
centers=zeros(levels,1);    %dianisma me ta kedra kathe stathmis kvadisis
T = zeros(levels+1,1);      %dianisma me ta akra kathe perioxis kvadisis
vima = (max_value+abs(min_value))/(levels); %euros kathe perioxis
 
%arxikopoihsh twn kedrwn me ta kedra tou omoiomorfou kvadisti
centers = min_value + vima/2 : vima :max_value-(vima/2);
 
 
 
Dprev=0;                    %Paramorfwsi prohgoumenis epanalipsis
diff=1;                     %diafora diadoxikwn paramorfwsewn -arxika 1
iter=1;                     %counter gia ta iteration tou Lloyd-Max
threshold = 1e-7;           %katofli syglisis
 
%loop oso to diff den exei ftasei to katwfli
while(diff>threshold)
    
   
    % arxikopoihsh twn akrwn twn perioxwn kvadisis
    T(1) = -inf;
    for j=2:levels
        T(j)= 0.5*( centers(j-1)+centers(j) );
    end
    T(levels+1) = inf;
    
    
    %kvadisi simatos
    for i=1:length(x)
        for k=1:levels
           if ((x(i)<=T(k+1)) && (x(i)>T(k)))
                   xq(i)=centers(k);
           end
        end
    end
    
    %ypologismos mesis paramorfwsis tis trexousas epanalipsis
    d = mean((x-xq').^2);
    D(iter) = d;
    
    %ypologismos tis diaforas Paramorfwsis
    diff = abs(D(iter)-Dprev);
    Dprev = D(iter); 
 
    
    %Nea kedra kvadismou: einai ta kedroeidi twn zwnwn
    for k=1:levels
        centers(k) = mean ( x ( x>T(k) & x<=T(k+1) ));
    end
        
    %increase ton counter twn iterations
    iter = iter + 1;
    
end
 
end

