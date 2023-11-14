function sol = ExpFitRes(StnPosSeries,idx,x,Par)
[A L t] = LinJac(StnPosSeries,idx);
x.t  = t;
x.t0 = t(1,1);
P = ones(length(L),1);
[x1,sigma,L_est,v,P,Qx] = RobLS(A,L,P,Par.RobPar);
%% Residual fitting  %%%%
y  = v;
%%%%%%%%%%% Two-step solution %%%%%%%%%%%%%%%%%%%%
%%  Linear Model Residuals --> Nonlinear exponential fitting %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Initial value of the parameter  %%%%
y = [y;x.constrain];
P = ones(length(y),1);
P(end) = P(end)*0.1;
%%% The GaussNewton method solves the nonlinear observational equations
sol = GaussNewton(y,P,x,@ExpFun,Par);
sol.t = t;
sol.v = v;
sol.x1= x1;