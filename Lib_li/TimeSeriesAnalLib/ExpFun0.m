function [f A] = ExpFun0(x)
% f(t) = K * (1-exp(-t/tao))
x0 = x.x0;
t  = x.t;
t0 = x.t0;
K   = x0(1);
tau = x0(2);

n = length(t);
t = t - t0; %% 
if ~(t<0)
   f = K*(1-exp(-t./tau));
   A = [1-exp(-t./tau) -K*t.*exp(-t./tau)/tau^2];
else
   f = 0;
   A = [zeros(n,1) zeros(n,1)];
end