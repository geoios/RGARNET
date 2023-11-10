function [ CV,EDF,SSE,R2,MSE ] = function_CV( lambda,Q,R,yy )

n=size(Q,1);
[L,U]=lu(R+lambda*Q'*Q);dd=diag(U);D=diag(dd');
d=inv(D)*inv(L);
% 矩阵B=R+lambda*Q'*Q
invB=[];
invB(n-2,n-2)=d(n-2);
invB(n-3,n-2)=-L(n-2,n-3)*invB(n-2,n-2);    invB(n-2,n-3)=invB(n-3,n-2);
invB(n-3,n-3)=d(n-3)-L(n-2,n-3)*invB(n-3,n-2);
for i = n-4:-1:1
    invB(i,i+2)=-L(i+1,i)*invB(i+2,i+2);invB(i+2,i)=invB(i,i+2);
    invB(i,i+1)=-L(i+1,i)*invB(i+1,i+1)-L(i+2,i+1)*invB(i+1,i+2);invB(i+1,i)=invB(i,i+1);
    invB(i,i)=d(i)-L(i+1,i)*invB(i,i+1)-L(i+2,i)*invB(i,i+2);
end

% 1-A(lambda)
for i=1:1:n
    if i==1
        Q_invB_QT_ii(i,i)=(Q(i,i))^2*invB(i,i)+(Q(i,i+1))^2*invB(i+1,i+1)+2*Q(i,i)*Q(i,i+1)*invB(i,i+1);
    elseif i==n
        Q_invB_QT_ii(i,i)=0;
    elseif i==n-1
        Q_invB_QT_ii(i,i)=(Q(i,i-1))^2*invB(i-1,i-1);
    elseif i==n-2
        Q_invB_QT_ii(i,i)=(Q(i,i-1))^2*invB(i-1,i-1)+(Q(i,i))^2*invB(i,i)+2*Q(i,i-1)*Q(i,i)*invB(i-1,i);
    else
        Q_invB_QT_ii(i,i)=(Q(i,i-1))^2*invB(i-1,i-1)+(Q(i,i))^2*invB(i,i)+(Q(i,i+1))^2*invB(i+1,i+1)+2*Q(i,i-1)*Q(i,i)*invB(i-1,i)+2*Q(i,i-1)*Q(i,i+1)*invB(i-1,i+1)+2*Q(i,i)*Q(i,i+1)*invB(i,i+1);
    end
end

fenmu=lambda*Q*inv(R+lambda*Q'*Q)*Q';


%% 矩阵A = inv(I+lambda*Q*inv(R)*Q')
A=[];
A=inv(eye(n)+lambda*Q*inv(R)*Q');


%% CV(lambda)=[(Yi-g(ti))/(1-A)]^2/n
nCV=0;
for i=1:1:n
    fit_g=0;
    for j=1:1:n
        fit_g=fit_g+A(i,j)*yy(j);
    end
    nCV=nCV+((yy(i)-fit_g)/(fenmu(i,i)))^2;
    % nCV=nCV+((yy(i)-fit_g)/(1-A(i,i)))^2;
end
CV=nCV/n;

%% 评判标准
% 误差的等价自由度EDF(equivalent degrees of freedom)
EDF=0;
edf=eye(n)-A;
for i=1:1:n
    EDF=EDF+edf(i,i);
end

% SSE残差平方和
SSE=0;
for i=1:1:n
        fit_g=0;
    for j=1:1:n
        fit_g=fit_g+A(i,j)*yy(j);
    end
    SSE=SSE+(yy(i)-fit_g)^2;
end

% 拟合优度R^2
M=0;
for i=1:1:n
    M=M+(yy(i)-mean(yy))^2;
end
R2=1-SSE/M;

% 均方误差MSE（mean square error）
MSE=SSE/EDF;
end

