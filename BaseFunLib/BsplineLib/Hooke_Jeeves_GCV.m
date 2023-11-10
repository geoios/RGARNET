function [ Y,yk ] = Hooke_Jeeves_GCV( xk,Q,R,yy )

% 输入初始探测搜索步长 delta;
% 加速因子 alpha(alpha>=1),
% 缩减率 beta(0<beta<1),
% 允许误差 epsilon(epsilon>0)，
% 初始点xk
delta=10^5;alpha=2;beta=0.25;epsilon=1;
% delta=10;alpha=2;beta=0.25;epsilon=0.005;
yk=xk;

% 求问题的维数
dim=size(xk,1);
% 初始化迭代次数
k=1;
e=[];

while delta>epsilon
    for i=1:1:dim
        % 生成本次探测的坐标方向
        e=zeros(1,dim);
        e(i)=1;
        
        t1=function_GCV(yk+delta*e,Q,R,yy);
        t2=function_GCV(yk,Q,R,yy);
        if t1<t2
            yk=yk+delta*e;
        else
            t1=function_GCV(yk-delta*e,Q,R,yy);
            t2=function_GCV(yk,Q,R,yy);
            if t1<t2
                yk = yk - delta * e;
            end
        end
        t1=function_GCV(yk,Q,R,yy);
        t2=function_GCV(xk,Q,R,yy);
        if t1<t2
            xk1=yk;
            yk=yk+alpha*(yk-xk);
            xk=xk1;
        else
            delta=delta*beta;
            yk=xk;
        end
        k=k+1;
    end
    
end
Y=function_GCV(yk,Q,R,yy);
end

