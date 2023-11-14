function x = GaussNewton(y,P,x,fun,Par)
RobPar = Par.RobPar;
Lmd    = Par.Lmd;
Stp    = Par.Stp;
Lop    = 0;
flag   = 0;
while(1)
[f A] = fun(x);
dy    = y - f;

[dx,sigma,L_est,v,P,Qx] = RobLS(A,dy,P,RobPar);
sig_E = sqrt(Qx(1,1)*sigma^2);
sig_N = sqrt(Qx(10,10)*sigma^2);
QX = [Qx(1,1) Qx(10,10)];
x.sig = [sig_E sig_N];
x.x0  = x.x0 + Lmd * dx;
%% Normal convergence conditions are met
if norm(dx) < Stp
    flag = 1;
end
%% Exceed the expected number of iterations
Lop = Lop + 1;
if Lop > Par.Lop
    flag = 1;
end
%% The specified cut-off condition is met
if Par.StopFun(x.x0)
    flag = 1;
end

if flag
    x.v = dy;
    x.P = P;
    x.f = f;
    break
end
end