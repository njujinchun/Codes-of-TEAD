function [y] = gauss(xx)
sum1=(xx(1,1)-0.6)^2 + (xx(1,2)-0.6)^2;
y=exp(-200*sum1);
end
