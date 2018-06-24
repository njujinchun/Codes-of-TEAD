function [X, Y] = Initial(Data)
% generate initial sample set for the adaptive sampling;
% the initial samples are selected from the corners and the center of the
% domain

X = gridsamp([Data.range.min;Data.range.max],2); % the corner points
X = [X; (Data.range.min + Data.range.max)/2];    % the corner points and the center point

evalstr = ['Y = ',Data.FunName,'(X);']; eval(evalstr);

XY = [X, Y];
save initXY.dat XY -ascii

end%function