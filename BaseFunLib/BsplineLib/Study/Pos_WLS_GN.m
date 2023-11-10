function LS = Pos_WLS_GN(X,L,x0,P,delt)
%%
% X 控制点坐标
% L 距离观测
% x0 初值
% delt 迭代误差

[n m]=size(X);
k=0;

while (1)
        x00 = x0(1:m)';
        for i = 1:n
            dif = X(i,:) - x00;
            dis = norm(dif);
            A(i,:) = dif./dis;
            dL(i) = L(i) - dis + x0(m+1);
        end
    
          AA = [A ones(n,1)];

          dx = inv(AA'*P*AA)*AA'*P*dL';
          vv = AA*dx-dL';

    x0 = x0 - dx;
    k = k + 1;
   
    aa=norm(dx);
    %%停止循环
    if aa<delt
      break
    end
    if k > 100
      break
    end
end

    Zeros = 0;
    for i=1:n
        if P(i,i) == 0
        Zeros = Zeros + 1;
        end
    end
    sig0_2 = dL*P*dL'/(n-m-1-Zeros);
    QQ = inv(AA'*P*AA)* sig0_2;

    P;
sss = sqrt(diag(P));
vv1 = vv.*sss;

 mbv = vv'*P*vv;
% mbv = vv1'*P*vv1;

LS.Par = x0;
LS.ParVar = QQ;
LS.ObsVar = sig0_2;
LS.Inter = k;
LS.Res = dL;
LS.Joc = AA;
LS.R = eye(n) - AA*inv(AA'*AA)*AA'*P;
LS.v1 = vv1;
LS.v = vv; 
LS.mbv = mbv;
end