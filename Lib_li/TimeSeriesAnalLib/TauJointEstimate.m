function x = TauJointEstimate(DataFilePath,Tag,constrain,Par)
%% station position series producing
StnPosSeries = File2StnPos(DataFilePath,Tag)
%% 数据建模 %%%%%%%%
%% E 方向
% L1 = A1*x1 + f(y1)
idx = 1; %%
[A1 L1 t1] = LinJac(StnPosSeries,idx);

P1 = ones(length(L1),1);
[x1,sigma1,L_est,v,P,Qx1] = RobLS(A1,L1,P1,Par.RobPar);

%figure(1)
%plot(v)
%% N 方向
% L2 = A1*x2 + f(y2)
idx = 2; %%
[A2 L2 t2] = LinJac(StnPosSeries,idx);
P2 = ones(length(L2),1);
[x2,sigma2,L_est,v,P,Qx2] = RobLS(A2,L2,P2,Par.RobPar);
% sig_N = sqrt(Qx2(1,1)*sigma2^2);

%sqrt(Qx2(end,end))
%figure(2)
%plot(v)
% N方向
x.t1  = t1;
x.t10 = t1(1);
x.A1  = A1;
%[n,m] = size(A1);
%x1   = zeros(m,1);
% E方向
x.t2  = t2;
x.t20 = t2(1);
x.A2  = A2;
%[n,m] = size(A1);
%x2   = zeros(m,1);

x.x0 = [x1;x2;Par.x3];
x.NlnFun = @ExpFun0;

x.constrain = constrain;
L = [L1;L2;x.constrain];
%%%%
P = ones(length(L),1);
P(end) = P(end) * 0.1;
% P(end-1) = P(end-1) * 0.05;
% P(end-2) = P(end-2) * 0.05;
%%% 高斯牛顿迭代 %%%%
x = GaussNewton(L,P,x,@Lin2Nln2Mix,Par);
