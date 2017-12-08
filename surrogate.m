function [ y ] = surrogate(x, RBFdata)
% Predict the value at x using the surrogate model

y = RBF_eval(x,RBFdata.X,RBFdata.lambda,RBFdata.gamma,RBFdata.bs);

end