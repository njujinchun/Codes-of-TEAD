%% 
% TEAD (Taylor Expansion-based Adaptive Design) Experimental Design Tool %
% 
% TEAD is an Taylor expansion-based adaptive design algorithm for efficient  
% global surrogate model construction. The TEAD algorithm is proposed in a 
% manuscript entitled "A Taylor expansion-based adaptive design strategy 
% for global surrogate modeling with applications in groundwater modeling" 
% by Mo SX, Lu D, Shi XQ, Zhang GN, Ye M, Wu JF, and Wu JC, submitting to 
% Water Resources Research. The surrogate method containing in this 
% documentation is Radial Basis Function (RBF) implemented in MATSuMoTo 
% toolbox developed by Dr. M¨¹ller (M¨¹ller J., (2014). MATSuMoTo Code 
% Documentation). It is noted that the RBF used in our manuscript mentioned 
% above is the multi-quadric RBF implemented in the SUMO toolbox 
% (Gorissen, D., Couckuyt, I., Demeester, P., Dhaene, T., 
% & Crombecq, K. (2010). A surrogate modeling and adaptive sampling 
% toolbox for computer based design. Journal of Machine Learning Research,
% 11(Jul), 2051-2055), which is available at 
% http://www.sumo.intec.ugent.be/SUMO.
%%

clear all; clc; close all

currentpath = pwd;
addpath([currentpath,'\test_functions']);

% example 1: Droplet function
% example 2: Peaks function
% example 3: Anisoropy function
% example 4: Gauss function
exam = 1;
if exam == 1 %Droplet function
    data_file = 'datainput_Droplet';
    MaxNum = 100; %maximum number of samples
end
if exam == 2 %Peaks function
    data_file = 'datainput_Peaks';
    MaxNum = 100; 
end
if exam == 3 %Anisotropy function
    data_file = 'datainput_Anisotropy';
    MaxNum = 150;
end
if exam == 4 %Gauss function
    data_file = 'datainput_Gauss';
    MaxNum = 80;
end

Data = feval(data_file); % load problem data

[X, Y] = Initial(Data); % generate initial samples

Nnew = Data.dim^2; %number of new samples at each iteration
RBF.bs = 'cubic';%basis function for RBF. 'linear','TPS', and 'cubic'

%run TEAD to adaptively generate inoformative training samples for surrogate construction
[ Data, RBFdata] = TEAD(X, Y, Data, Nnew, MaxNum); 
% Data.RMSE: The first to third columns of Data.RMSE are the number of 
% samples, the global RMSE accuracy evaluated at the validaiton samples, 
% and the RMSE accuracy evaluated at the newly selected samples at the 
% current iteration,repectively.
%
% Data.Res: the approximation errors at the validation points
%

save results

%% plot results
figure(1), %plot the RMSE decay 
plot(Data.RMSE(:,1),Data.RMSE(:,2),'-o');
xlabel('Number of samples'),ylabel('RMSE');
title('RMSE decay');
set(gca, 'FontName', 'Times newman', 'FontSize', 14);

if Data.dim == 2 %plot the 2D surrogate response surface and associated approximation errors
    level = 51;
    x = gridsamp([Data.range.min;Data.range.max],level);
    y = surrogate(x, RBFdata);
    x1 = reshape(x(:,1),level,level); x2 = reshape(x(:,2),level,level);
    y = reshape(y,size(x1));
    Data.Res = reshape(Data.Res,size(x1));
    
    figure(2),
    surf(x1,x2,y,Data.Res);
    xlabel('\itx_{\rm1}'),ylabel('\itx_{\rm2}'),zlabel('\its{\rm(}\itx{\rm)}')
    set(gca, 'CLim', [ 1.2*min( Data.Res(:) )  1.2*max( Data.Res(:) ) ]); 
    colorbar;
    title('Surrogate response surface and associated approximation errors');
    set(gca, 'FontName', 'Times newman', 'FontSize', 14);
    hold on,
    scatter3( Data.X(:,1), Data.X(:,2), Data.Y,'ow','filled' )
end
%%

rmpath([currentpath,'\test_functions']);