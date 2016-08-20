tic
toc;
t=zeros(20,1);
for i=1:20
    tic
    t(i)=toc;
end
time=sum(t)/20;
