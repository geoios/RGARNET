function [f C B A] = LinNlnMix(x)
%% f = a + kt + ExpFun(t)

t  = x.t;
t0 = x.t0;

%%线性函数部分
B  = x.B;
m = size(B,2);
x1 = x.x0(1:m);

%%非线性函数部分
x2.x0 = x.x0(m+1:end);
x2.t  = t;
x2.t0 = t0;

[f A] = x.NlnFun(x2); %% ExpFun0
f = f + B*x1;
C = [B A];

if isfield(x,'constrain')
   con = x.constrain;
   f = [f;x.x0(end)];
   [p q] = size(C);
   ConEq = zeros(1,q);
   ConEq(q) = 1;
   C = [C;ConEq];
end