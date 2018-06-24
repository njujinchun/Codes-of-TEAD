function Data = datainput_Droplet

Data.dim = 2;                          % problem dimension
Data.range.min = -1*ones(1,Data.dim);  % lower variable bounds
Data.range.max = 1*ones(1,Data.dim);   % upper variable bounds
Data.FunName = 'Droplet_Function';     % test function name
Data.Nmax = 100;                       % maximum number of samples
Data.Threshold = 0.03;                 % desired accuracy
Data.Nnew = Data.dim^2;                % number of new samples selected at each iteration
Data.Ncand = 500 * ( 2^Data.dim );     % number of candidate points

% generate the validation samples
Data.level = 51;
Data.Xvalid = gridsamp([Data.range.min;Data.range.max],Data.level);
evalstr = ['Data.Yvalid = ',Data.FunName,'(Data.Xvalid);']; eval(evalstr);
Data.Nvalid = length(Data.Yvalid);

end