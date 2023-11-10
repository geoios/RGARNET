%% 多项式插值 polyfit   polyval
close
clc
clear
% x=linspace(0,2*pi,10); %取y=sinx上的十个数据点
x=load('时间.txt');
% y=sin(x);
y=load('位移.txt');
P=polyfit(x,y,6) %7为拟合阶数，p为多项式的系数
poly2str(P,'x'); %组装成插值多项式
x1=linspace(min(x),max(x),100);
y1=polyval(P,x1);%用x1代替插值多项式中的x
plot(x,y,'o',x1,y1)
 
% x=linspace(1000,2000,10);  %初始10个数据点
% y=1e5*[0.02 0.04 0.05 0.055 0.5 0.6 0.9 1.52 2.3 3.6];
% plot(x,y,'o')%数据点绘图
% hold on
% x1=linspace(1000,2000,100);  
% [P,~,mu]=polyfit(x,y,6); %mu为居中和缩放参数 具体查看函数定义
% y1=polyval(P,x1,[],mu);
% plot(x1,y1)