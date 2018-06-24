function y = Anisotropy_Function(x)

y(:,1) = exp(-100*(x(:,1)-0.25).^2) + 2;