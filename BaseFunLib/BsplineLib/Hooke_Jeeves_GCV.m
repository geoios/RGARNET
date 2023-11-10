function [ Y,yk ] = Hooke_Jeeves_GCV( xk,Q,R,yy )

% �����ʼ̽���������� delta;
% �������� alpha(alpha>=1),
% ������ beta(0<beta<1),
% ������� epsilon(epsilon>0)��
% ��ʼ��xk
delta=10^5;alpha=2;beta=0.25;epsilon=1;
% delta=10;alpha=2;beta=0.25;epsilon=0.005;
yk=xk;

% �������ά��
dim=size(xk,1);
% ��ʼ����������
k=1;
e=[];

while delta>epsilon
    for i=1:1:dim
        % ���ɱ���̽������귽��
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

