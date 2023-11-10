clear all;close all;clc
%% 多项式拟合 设置项式拟合的p次数
p=6;lambda=0;
%% 型值点的生成
xx=linspace(0,6,21);
% xx=load('时间.txt');
yy=5*sin(2*xx)+2*randn(1,length(xx));
% yy=load('位移.txt');
plot(xx,yy,'.b','MarkerSize',8)
hold on 
% plot(xx,10*sin(2*xx),'.r','MarkerSize',8)
% hold on

%% 构建法方程的设计矩阵
% 设计矩阵初始化
B=zeros(length(xx),p+1);
% 填充设计矩阵
for i=1:1:length(xx)
    for j=1:1:p+1
        B(i,j)=xx(i)^(j-1);
    end
end
% 求解法方程
dl=(B'*B)\B'*yy';
%% 绘制多项式拟合曲线
% 构建
Px=linspace(min(xx),max(xx),101);
% 构建多项式方程
for j=1:1:length(Px)
    Pyy=0;
    for k =1:1:p+1
        Pyy=Pyy+dl(k,1)*Px(j)^(k-1);
    end
    Py(j)=Pyy;
end

plot(Px,Py,'-','Color','r',...
    'MarkerEdgeColor','m',...
    'MarkerFaceColor','m',...
    'MarkerSize',8);
title('次多项式拟合')
xlabel('X轴');
ylabel('Y轴');
legend({'型值点','多项式拟合曲线'});
