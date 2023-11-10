function [x0, dL, L0, L01, X, DX, Aalf, sig, B] = NonLinearLS_t(BuoyData,BuoyData1,c,T,x0,delat)
k = 0;[m,~] = size(BuoyData);X = [];DX = [];
while(1)
    L0 = [];L01 = [];P = [];k1 = [];T_1 = [];B = [];k = k + 1;dLz = [];
    %     for j = 1:m
    %         L0(j)=norm(BuoyData(j,:)-x0);
    %         L01(j)=norm(BuoyData1(j,:)-x0(1:3));
    %         P(j)=((BuoyData(j,3)-x0(3))/L0(j))^2;
    %         k1(j)=L0(j)/(L0(j)+L01(j));
    %         T_1(j,:)=2*T(j)*k1(j);%
    %         B(j,:)=(x0-(BuoyData(j,:)))/L0(j);
    %     end
    %     P=diag(P);
    %     dL=(c*T_1-L0')';
    %         Qx = B'*B;
    %         dx = inv(Qx)*B'*dL' ;
    
    for j = 1:m
        L0(j)=norm(BuoyData(j,:)-x0);
        L01(j)=norm(BuoyData1(j,:)-x0(1:3));
        P(j)=((BuoyData(j,3)-x0(3))/L0(j))^2;
        B(j,:)=(x0-(BuoyData(j,:)))/L0(j) + (x0-(BuoyData1(j,:)))/L01(j);
%         dLz = [dLz;2 * c(j) * T(j)];
                dLz = [dLz;2 * c * T(j)];
    end
    P = diag(P);
    
    dL = (dLz - (L0 + L01)')';
    Qx = B'*B;
    dx = inv(Qx)*B'*dL' ;
    
    DX = [DX;dx'];
    %     dx=B\dL;
    x0 = x0 + dx';
    X = [X;x0];
    Aalf = B(:,3);
    sig = sqrt(dL * dL'/(m-3));
    
    if k > 20
        break
    end
    if norm(dx) < delat
        break
    end
end