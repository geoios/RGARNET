% 今天12点到明天12点的温度曲线
% 每两个小时为一个小段一个节点
%每一段上用多少阶

clear all;
close all;
clc;

N=10;                %设置拟合阶数
x=1:0.5:10;
y=cos(x);           %生成待拟合点

p=polyfit(x,y,N);   %使用matlab函数拟合数据

xx=min(x):0.01:max(x);
yy=polyval(p,xx);
            
plot(xx,yy);        %画出拟合结果
hold on;
plot(x,y,'r.')

%下面是使用公式来做最小二乘多项式拟合
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
Re=Re(end:-1:1)';%数组反序
figure;
plot(x,y,'r.')
hold on;
yyy=polyval(Re,xx);
plot(xx,yyy,'g')

p
Re