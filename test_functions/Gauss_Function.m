function y=Gauss_Function(x)
m=size(x,1);
for ii=1:m
    y(ii,1)=feval(@gauss,x(ii,:));
end
end