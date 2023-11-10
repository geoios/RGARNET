function sol = ExpFitRes(StnPosSeries,idx,x,Par)
[A L t] = LinJac(StnPosSeries,idx);
x.t  = t;
x.t0 = t(1,1);
P = ones(length(L),1);
[x1,sigma,L_est,v,P,Qx] = RobLS(A,L,P,Par.RobPar);
%% 残差拟合  %%%%
y  = v;
%%%%%%%%%%% 两步解法 %%%%%%%%%%%%%%%%%%%%
%%  线性模型残差 --> 非线性指数拟合 %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% 参数初值  %%%%
y = [y;x.constrain];
P = ones(length(y),1);
P(end) = P(end)*0.1;
%%% GaussNewton方法求解非线性观测方程
sol = GaussNewton(y,P,x,@ExpFun,Par);
sol.t = t;
sol.v = v;
sol.x1= x1;