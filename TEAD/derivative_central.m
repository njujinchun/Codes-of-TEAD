function [ g ] = derivative_central (Xcand, dmodel, Data)
% DERIVATIVE_CENTRAL calculate the gradient at X using the central difference
%
% X     : Candidate points
% dmodel: The parameters required for surrogate prediction
% Data  : the parameters of the actual model (e.g., input dimensionality and ranges)
%
% g     : The gradient of surrogate model at X computed using central difference

[Ncand, dim] = size(Xcand); % the number and dimension of the candidates
h = 1e-4;
g = zeros(Ncand,dim,1);

for i = 1 : dim
    Xi = Xcand;
    Xi(:,i) =  Xi(:,i) + h;
    X_i = Xcand;
    X_i(:,i) = X_i(:,i) - h;

    fi  = surrogate(Xi,  dmodel, Data); % the surrogate predictions at Xi
    f_i = surrogate(X_i, dmodel, Data);
    % the value of g for all candiates in the ith dimension 
    g(1:Ncand,i,1) = (fi - f_i) ./ (2*h);       
end

end %function