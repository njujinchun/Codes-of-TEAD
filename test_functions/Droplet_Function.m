function y = Droplet_Function(x)

m=size(x,1);
for ii=1:m
    y(ii,1)=-4*exp(-3.125*(x(ii,1)^2+x(ii,2)^2))+7*exp(-31.25*(x(ii,1)^2+x(ii,2)^2));
end

end%function
