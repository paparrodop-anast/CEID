function L_meso = mikos_kwdika(p,len)
% Ypologizei to meso mikos kwdika
% input
% p: dianysma pithanotitwn emfanisis
% len:dianusma me ta length tou kathe
% kwdikopoihmenoy symvolou

disp(p);
L_meso=0;

for i=1:length(p)
	L_meso = L_meso +p(i)*len(i);
end
end
