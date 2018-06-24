function [Xnew] = New(X, Y, dmodel, Data)
% NEW select new sample points using a hybrid score function basing on the 
% nearest distance and the high-order remainders of Taylor expansion
% 
% X: the inputs of existing training samples
% Y: the responses of existing training samples
% dmodel: the parameters required for surrogate prediction
% Data: the parameters of the actual model (e.g., input dimensionality and ranges)
%
% Xnew: the inputs of new training samples        

%generate candidate points using LHS
Xcand = LHS(Data.range.min,Data.range.max,Data.Ncand); 

%maximum distance of any two points in the parameter space 
Lmax = pdist2(Data.range.min,Data.range.max); 

g = derivative_central (X, dmodel, Data); %gradient of the surrogate model at X

% search the nearest sample in X for each candidate point in Xcand
idx = zeros(Data.Ncand, 1); 
R = pdist2(X, Xcand);
[Dmin, index] = min(R(:,:));
Dmin = Dmin';       % the exloration metric
idx(:, 1) = index'; % the index of the nearest sample of each candidate
clear index R

DnearNorm = Dmin ./ max( Dmin(:) );% normalized exploration metric
w = 1 - Dmin ./ Lmax;              % the weight function

% Taylor expansion of each candidate expaned at the neearest sample
Ycand_taylor = nan(Data.Ncand, 1); 
for i = 1 : Data.Ncand
    gi(:,1) = g( idx(i,1), 1 : Data.dim);
    deltaX = Xcand(i,:) - X( idx(i,1), :);
    Ycand_taylor(i,1) = Y( idx(i,1)) + deltaX * gi;
end

Ypred = surrogate(Xcand, dmodel, Data);      % the surrogate predictions at candidate points
remaider = abs(Ypred - Ycand_taylor); % the exploitation metric
% normalized exploitation metric
remaiderNorm = remaider ./ ( max( remaider(:) ) + 1e-200 );

%% hybrid scores of all candidates
score = w.*remaiderNorm + DnearNorm;  
%%

[~, index] = max(score(:));
Xnew = Xcand(index,:);     % select the candidate having the largest score value as the new sample

%% selection of batch of samples at one iteration WITHOUT using the Liar strategy
for i = 2 : Data.Nnew
    remaiderNorm(index) = 0;
    Xhat = [X; Xnew];
    R = pdist2(Xhat, Xcand);
    Dmin = min(R(:,:));
    Dmin = Dmin';                      % the exloration metric
    clear index R
    DnearNorm = Dmin ./ max( Dmin(:) );% normalized exploration metric
    w = 1 - Dmin ./ Lmax;              % the weight function
    score = w.*remaiderNorm + DnearNorm;  
    [~, index] = max(score(:));
    Xnew(i,:) = Xcand(index,:);
end

%% selection of batch of samples at one iteration using the Liar strategy
% Ynew_hat = Ypred(index,1); 
% for i = 2 : Data.Nnew
%     R = pdist2(Xcand, Xnew); % the distance between candidates and new points
%     gnew = derivative_central (Xnew, dmodel, Data); % calculate the gradient vector at newly selected points
%     for j = 1 : Data.Ncand
%         [dmin,index] = min(R(j,:)); % the minimum distance between the jth candidate and new points
%         
%         % if the distance between this candidate to the new points is less than Dmin, recalculate the Ycand_taylor
%         if dmin < Dmin(j) 
%             gj(:,1) = gnew(index,1:Data.dim);
%             deltaX = Xcand(j,:) - Xnew(index,:);
%             Dmin(j,1) = dmin;
%             DnearNorm(j,1) = Dmin(j,1) / max( Dmin(:) );
%             w(j,1) = 1 - Dmin(j,1) / Lmax;
%             Ycand_taylor(j,1) = Ynew_hat(index,1) + deltaX*gj;
%         end
%     end
%     remaider = abs(Ypred - Ycand_taylor);
% 
%     remaiderNorm = remaider ./ ( max( remaider(:) ) + 1e-200 );
%     score = w.*remaiderNorm + DnearNorm;
% 
%     [~, index] = max(score(:));
%     Xnew(i,:) = Xcand(index,:);
%     Ynew_hat(i,1) = Ypred(index,1);
% end

end %function
