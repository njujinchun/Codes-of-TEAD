function y=Peaks_Function(x)
m=size(x,1);
for ii=1:m
    y(ii,1)=3*(1-x(ii,1))^2*exp(-x(ii,1)^2-(x(ii,2)+1)^2)-10*(0.2*x(ii,1)-...
        x(ii,1)^3-x(ii,2)^5)*exp(-x(ii,1)^2-x(ii,2)^2)-exp(-(x(ii,1)+1)^2-x(ii,2)^2)/3.0;
end
end%function