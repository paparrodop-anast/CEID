function H = edropia(p)
% Ypologismos tis Edropias tis pigis
% input p: dianysma pithanotitwn emfanisis symvolwn

h=0;
len = length(p);

for i=1:len
	if (p(i)~=0)
		h = h + (p(i) * log2(p(i)));
	end
end

H = (-1)*h;

End
