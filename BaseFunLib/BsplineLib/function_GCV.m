function [ GCV ] = function_GCV( lambda,Q,R,yy )

n=size(Q,1);
[L,U]=lu(R+lambda*Q'*Q);dd=diag(U);D=diag(dd');
d=inv(D)*inv(L);
% æÿ’ÛB=R+lambda*Q'*Q
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

A=[];
% æÿ’ÛA = inv(I+lambda*Q*inv(R)*Q')
A=inv(eye(n)+lambda*Q*inv(R)*Q');
% CV(lambda)=[(Yi-g(ti))/(1-A)]^2/n

fenzi=0;trA=0;
for i=1:1:n
    fit_g=0;
    for j=1:1:n
        fit_g=fit_g+A(i,j)*yy(j);
    end
    fenzi=fenzi+(yy(i)-fit_g)^2;
    trA=trA+A(i,i);
end

fenmu2=(1-trA/n)^2;


GCV=(fenzi/fenmu2)/n;
end

