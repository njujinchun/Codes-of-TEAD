function dmodel = Surr_Para(X, Y, Data)
% SURR_PARA compute the surrogate model's parameter value
%
% X     : the inputs of existing training samples
% Y     : the responses of existing training samples
% Data  : the parameters of the actual model (e.g., input dimensionality and ranges)
%
% dmodel: the surrogate parameters

if strcmp(Data.surr, 'Kriging')  % use the Kriging method for surrogate construction
    theta = 10*ones(1,Data.dim); % Initial setting for Kriging model parameters
    lob = 0.1*ones(1,Data.dim); upb = 20*ones(1,Data.dim);
    [dmodel, perf]=dacefit(X,Y,@regpoly1,@corrgauss,theta,lob,upb); 
elseif strcmp(Data.surr, 'RBF') % use the RBF method for surrogate construction
    dmodel.bs = 'cubic'; % 'linear', 'TPS', and 'cubic'
    dmodel.X = X;
    [dmodel.lambda,dmodel.gamma] = RBF(dmodel.X, Y, dmodel.bs);
else
    disp('Error! Please specify a surrogate method!');
end

