% ����12�㵽����12����¶�����
% ÿ����СʱΪһ��С��һ���ڵ�
%ÿһ�����ö��ٽ�

clear all;
close all;
clc;

N=10;                %������Ͻ���
x=1:0.5:10;
y=cos(x);           %���ɴ���ϵ�

p=polyfit(x,y,N);   %ʹ��matlab�����������

xx=min(x):0.01:max(x);
yy=polyval(p,xx);
            
plot(xx,yy);        %������Ͻ��
hold on;
plot(x,y,'r.')

%������ʹ�ù�ʽ������С���˶���ʽ���
F=zeros(N+1,length(x));
F(1,:)=1;
for i=2:N+1
   for j=1:length(x) 
        F(i,j) = x(j)^(i-1);      
   end
end
F=F*F';

[m ~]=size(F);
Y=zeros(m,1);
Y(1) = sum(y);
for i=2:m
    for j=1:length(y)
        Y(i) = Y(i)+y(j)*x(j)^(i-1);
    end  
end

Re = F\Y;
Re=Re(end:-1:1)';%���鷴��
figure;
plot(x,y,'r.')
hold on;
yyy=polyval(Re,xx);
plot(xx,yyy,'g')

p
Re