close all;clear all;clc;
%% �������׵����ĸ���
X1=[-100.1,100,100];X2=[100,100.1,100];X3=[100,-100,100];X4=[-100,-100,100.1];
X=[X1;X2;X3;X4];
[m,n]=size(X);
delat=10^-5;
for i=1:1:m
    plot(X(i,1),X(i,2),'xr');
    hold on
end

%% ָ��Բ�ĳ�ʼֵ
xx=[mean(X(:,1)),mean(X(:,2)),mean(X(:,3))];
plot(xx(1),xx(2),'ob');
hold on
% ����۲����
for j=1:1:m
    for i=1:1:n
        Z(j,i)=X(j,i)-xx(i);
    end
    l(j)=norm(Z(j,:));
end
Ll=mean(l);
for i=1:1:m
    L(i,1)=Ll;
end

%% ƽ�����Բ������
[x0] = NonLinearLS_Robust(X,L,xx,delat);
plot(x0(1),x0(2),'or');
hold on

%% ������
for j=1:1:m
    for i=1:1:n
        r(j,i)=X(j,i)-x0(i);
    end
    R(j,1)=norm(r(j,:));
end
