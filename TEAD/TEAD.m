function [ Data, dmodel ] = TEAD(X, Y, Data)

Iter = 1;
counter = 0;

N = size(X,1);
while N < Data.Nmax
    Iter
    N = size(X,1); 
    dmodel = Surr_Para(X, Y, Data); % computate the parameter values of the surrogate model
    
    Xnew = New(X, Y, dmodel, Data); %select new samples
    
    % evaluate the actual function at newly selected points
    evalstr = ['Ynew = ',Data.FunName,'(Xnew);']; eval(evalstr);
       
    Ynew_sur = surrogate(Xnew, dmodel, Data);
    Yvalid_sur = surrogate(Data.Xvalid, dmodel, Data);  

    Data.RMSE(Iter, 1) = N; %number of samples
    % Global accuracy of the surrogate model
    Data.RMSE(Iter, 2) = norm(Data.Yvalid - Yvalid_sur) / sqrt(Data.Nvalid); 
    % RMSE at new sample points, i.e., error indicator for termination
    Data.RMSE(Iter, 3) = norm(Ynew - Ynew_sur) / sqrt(Data.Nnew); 
    % quality of the new samples, a value > 1.0 indicates informative sampels at this iteration
    Data.RMSE(Iter, 4) = Data.RMSE(Iter, 3) / Data.RMSE(Iter, 2); 

    X = [X; Xnew];
    Y = [Y; Ynew];
    XY = [X, Y];
    save XY.dat XY -ascii
    
    % the initial three iterations are not considered in the termination 
    % judgement due to TEAD is relatively "sparse" at the begining
    if ( Data.RMSE(Iter,3) - Data.Threshold ) <= 1.0e-20  && Iter > 3  
       counter = counter + 1;
    else
       counter = 0;
    end
    
    RMSE = Data.RMSE;
    save RMSE.dat RMSE -ascii;
          
    Iter = Iter + 1;
    
    if counter == 2 % if the stopping criterion is met, stop the design process
        break;
    end

end  

dmodel = Surr_Para(X, Y, Data);
Yvalid_sur = surrogate(Data.Xvalid, dmodel, Data);
Data.RMSE(Iter, 1) = size(X,1);
Data.RMSE(Iter, 2) = norm(Data.Yvalid - Yvalid_sur) / sqrt(Data.Nvalid); 
Data.RMSE(Iter, 3) = norm(Ynew - Ynew_sur) / sqrt(Data.Nnew); 
Data.RMSE(Iter, 4) = 1.0; 
RMSE = Data.RMSE;
save RMSE.dat RMSE -ascii;

Data.X = X;
Data.Y = Y;

end %function