function [ y ] = surrogate(x, dmodel, Data)
% Predict the value at x using the surrogate model
% y = predictor(x,dmodel);
% y = RBF_eval(x,RBFdata.X,RBFdata.lambda,RBFdata.gamma,RBFdata.bs);

if strcmp(Data.surr, 'Kriging')
    y = predictor(x,dmodel);
elseif strcmp(Data.surr, 'RBF')
    y = RBF_eval(x,dmodel.X,dmodel.lambda,dmodel.gamma,dmodel.bs);
else
    disp('Error! Please specify a surrogate method!');
end

end