function [dP,knotsV,knotsU] = Sunfunction(H,p,q,ParamU,ParamV)
%% 确定B样条曲面控制顶点
% 1.给出对应u\v值和节点区间
% 参数U
UBroundSide=[0,10];
% 参数个数
u=linspace(UBroundSide(1),UBroundSide(2),size(H,2));
% 节点区间
TStart=UBroundSide(1);TEnd=UBroundSide(end);
knots0=linspace(TStart,TEnd,ParamU-p+1);
dknots=(TEnd-TStart)/(ParamU-p);
for i=1:1:p
    knots_First_U(i)=TStart-(p-i+1)*dknots;
    knots_End_U(i)=TEnd+i*dknots;
end
knotsU=[knots_First_U,knots0,knots_End_U];
% 2.计算每列控制点
% 
for k=1:size(H,1)
U1=zeros(size(H,2),ParamU);
for i=1:1:size(H,2)
    for j=1:1:ParamU
        U1(i,j)=Bbase(j,p,u(i),knotsU);
    end
end
dQ(:,k)=inv(U1'*U1)*U1'*H(k,:)';
end

% 参数V
VBroundSide=[0,10];
% 参数个数
v=linspace(VBroundSide(1),VBroundSide(2),size(dQ,2));
% 节点区间
TStart=VBroundSide(1);TEnd=VBroundSide(end);
knots0=linspace(TStart,TEnd,ParamV-q+1);
dknots=(TEnd-TStart)/(ParamV-q);
for i=1:1:q
    knots_First_V(i)=TStart-(q-i+1)*dknots;
    knots_End_V(i)=TEnd+i*dknots;
end
knotsV=[knots_First_V,knots0,knots_End_V];

% 2.计算每行控制点
for k=1:size(dQ,1)
V1=zeros(size(dQ,2),ParamV);
for i=1:1:size(dQ,2)
    for j=1:1:ParamV
        V1(i,j)=Bbase(j,q,v(i),knotsV);
    end
end
dP(:,k)=inv(V1'*V1)*V1'*dQ(k,:)';
end
end

