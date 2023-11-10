function x = LinNlnMixFit(StnPosSeries,idx,x2,constrain,Par)
[A L t] = LinJac(StnPosSeries,idx);
x.constrain = constrain;
L = [L;x.constrain];
P = ones(length(L),1);
P(end) = P(end) * 0.1;
%%%%%%%%%%% 一步解法 %%%%%%%%%%%%%%%%%%%%
%% L = a + kt + ExpFun(t)        %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x.t  = t;
x.t0 = t(1);
%% 线性部分
[n,m] = size(A);
x1 = zeros(m,1);
x.B  = A;
%% 非线性部分
x.x0 = [x1;x2];
x.NlnFun = @ExpFun0;

%%% 高斯牛顿迭代 %%%%
x = GaussNewton(L,P,x,@LinNlnMix,Par);
x.x0