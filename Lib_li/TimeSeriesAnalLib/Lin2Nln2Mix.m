function [f C] = Lin2Nln2Mix(x)
%% f1 = a1 + k1t + ExpFun(t,A1,tau)
x1.t  = x.t1;
x1.t0 = x.t10;
x1.B  = x.A1;
[n,m] = size(x1.B);
x1.x0 = [x.x0(1:m);x.x0(end-2);x.x0(end)];
x1.NlnFun = x.NlnFun;
[f1 C1 B1 A1] = LinNlnMix(x1);

%% f2 = a2 + k2t + ExpFun(t,A2,tau) 
x2.t  = x.t2;
x2.t0 = x.t20;
x2.B  = x.A2;
[n,m] = size(x2.B);
x2.x0 = [x.x0(m+1:2*m);x.x0(end-1);x.x0(end)];
x2.NlnFun = x.NlnFun;
[f2 C2 B2 A2] = LinNlnMix(x2);
f = [f1;f2];

n1 = length(f1);
n2 = length(f2);
C = [ B1   B2*0     A1(:,1)   zeros(n1,1)  A1(:,2);
     B1*0   B2     zeros(n2,1)   A2(:,1)   A2(:,2);];
if isfield(x,'constrain')
   con = x.constrain;
   f = [f;x.x0(end)];
   [p q] = size(C);
   ConEq = zeros(1,q);
   ConEq(q) = 1;
   C = [C;ConEq];
end
end