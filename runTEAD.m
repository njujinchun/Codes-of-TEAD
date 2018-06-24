% TEAD is an adaptive experimental design algorithm for adaptive selection
% of training samples to construction surrogate model. The implementation 
% is based on the following published paper:
% Mo, S., Lu, D., Shi, X., Zhang, G., Ye, M., Wu, J., & Wu, J. (2017). A 
% Taylor expansion©\based adaptive design strategy for global surrogate 
% modeling with applications in groundwater modeling. Water Resources 
% Research, 53, 10,802¨C10,823. https://doi.org/10.1002/2017WR021622
%
% The paper should be referenced whenever the codes are used to 
% generate results for the user's own research. 
%
% The codes of Kriging and radial basis function (RBF) were developed by 
% Dr. M¨¹ller (M¨¹ller J., (2014). MATSuMoTo Code Documentation.) and 
% Dr. Lophaven (Lophaven, S.N., Nielsen, H.B., S?ndergaard, J., 2002. 
% DACE-A MATLAB kriging toolbox, version 2.0.), respectively. 
% It is noted that the RBF used in our manuscript mentioned above is the 
% multi-quadric RBF implemented in the SUMO toolbox (Gorissen, D., 
% Couckuyt, I., Demeester, P., Dhaene, T., & Crombecq, K. (2010). A 
% surrogate modeling and adaptive sampling toolbox for computer based 
% design. Journal of Machine Learning Research, 11(Jul), 2051-2055.), 
% which is available at http://www.sumo.intec.ugent.be/SUMO.
%
%
%----------------*****  Code Author Information *****----------------------
%   Code Author (Implementation Questions, Bug Reports, etc.): 
%       Shaoxing Mo: smo@smail.nju.edu.cn
%**************************************************************************
%   Please refer with all questions, comments, bug reports, etc. to
%   smo@smail.nju.edu.cn
%----------------********************************--------------------------

clear all; clc; close all

currentpath = pwd;
addpath([currentpath,'/Kriging']);
addpath([currentpath,'/RBF']);
addpath([currentpath,'/TEAD']);
addpath([currentpath,'/test_functions']);

data_file = 'datainput_Gauss';

Data = feval(data_file); % load problem data

Data.surr = 'RBF';   % the surrogate method used. 'Kriging', 'RBF'

[X, Y] = Initial(Data); % generate initial samples

tic;
%run TEAD to adaptively generate inoformative training samples for surrogate construction
[ Data, dmodel] = TEAD(X, Y, Data); 
toc;

save results


figure, %plot the RMSE decay 
plot(Data.RMSE(:,1),Data.RMSE(:,2),'-o');
xlabel('Number of samples'),ylabel('RMSE');
title('RMSE decay');
set(gca, 'FontName', 'Times newman', 'FontSize', 14);

if Data.dim == 2 %plot the 2D surrogate response surface and associated approximation errors
    x = gridsamp([Data.range.min;Data.range.max],Data.level);
    evalstr = ['y = ',Data.FunName,'(x);']; eval(evalstr);
    ypred = surrogate(x, dmodel, Data);
    res = y - ypred;
    x1 = reshape(x(:,1),Data.level,Data.level); x2 = reshape(x(:,2),Data.level,Data.level);
    ypred = reshape(ypred,size(x1));
    res = reshape(res,size(x1));
    
    figure,
    surf(x1,x2,ypred,res);
    xlabel('\itx_{\rm1}'),ylabel('\itx_{\rm2}'),zlabel('\its{\rm(}\itx{\rm)}')
    set(gca, 'CLim', [ 1.0*min( res(:) )  1.*max( res(:) ) ]); 
    colorbar;
    title('Surrogate response surface and associated approximation errors');
    set(gca, 'FontName', 'Times newman', 'FontSize', 14);
    hold on,
    scatter3( Data.X(:,1), Data.X(:,2), Data.Y,'ow','filled' )
end

rmpath([currentpath,'/Kriging']);
rmpath([currentpath,'/RBF']);
rmpath([currentpath,'/TEAD']);
rmpath([currentpath,'/test_functions']);