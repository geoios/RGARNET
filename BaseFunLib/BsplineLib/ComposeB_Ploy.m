close all; clear; clc;close("all");
%% 获取当前脚本的位置
ScriptPath      = mfilename('fullpath');      % 脚本位置
[FilePath] = fileparts(ScriptPath);      % 文件夹位置
cd(FilePath);
clear FilePath;


LineWidth1=1;
%% 
subplot(2,2,3)

x=linspace(-1,1,10);
y=1./(1+25*x.^2);
for i=5:9
p=polyfit(x,y,i-1);
xx=-1:0.01:1;
yy=polyval(p,xx);
plot(xx,yy,'g','LineWidth',LineWidth1);
hold on;
grid on;
end
plot(x,1./(1+25*x.^2),'.r','MarkerSize',12);

FigSet.FontSize=18;
FigSet.Name1=['多项式拟合'];
hTitle = title(FigSet.Name1,'FontSize',FigSet.FontSize);

hXLabel = xlabel('\fontname{Times new roman}{\itX}\fontname{楷体}{\it轴}','FontSize',FigSet.FontSize);
hYLabel = ylabel('\fontname{Times new roman}{\itY}\fontname{楷体}{\it轴}','FontSize',FigSet.FontSize);
FigSet.PaperPosition=[0,0,30,10];
set(gcf, 'PaperPosition', FigSet.PaperPosition);
% 指定figure的尺寸
FigSet.Size=[0,0,20,15];
set(gcf,'unit','centimeters','position',FigSet.Size);
% 改变ylabel离坐标轴的距离
set(findobj('FontSize',10),'FontSize',FigSet.FontSize);
%  h=legend({'方法B','方法D'});
% h=legend({'方法D','方法E','GARPOS'});
% set(h,'FontName','宋体','FontSize',FigSet.FontSize,'Location','best');
%% 设置B样条曲线拟合的p次数和控制点的n个数（0，1，...n）
subplot(2,2,4)

for i=5:2:9
A=50;B=5;C=1;
MPNum=i;
spdeg=3;
MP=[0,MPNum];
mp=zeros(MPNum,1);
%% 标准曲线，误差曲线绘制
% 节点参数的生成
% 读取型值点坐标，型值点的坐标弦长，累加弦长/总弦长
tt=x;
yy=y;
yreal=A*sin(2*tt);
a=plot(tt,yy,'.r','MarkerSize',12);
hold on
% plot(tt,yreal,'-k','MarkerSize',12)
% hold on 
%% 重新构建时间节点
tstart=tt(1);tend=tt(end);
M.ST(1)=tstart;M.RT(1)=tend;
[knots]=Make_Bspline_knots(M,spdeg,MP);%
[dmp] = SubJcbBspline(mp,tt,knots,spdeg,yy);




T=linspace(tstart,tend,50);
for j=1:length(T)
    py=0;
    for i=1:length(dmp)
        py=py+dmp(i)*Bbase(i,spdeg,T(j),knots{1});
    end
    Pu(j)=py;
end
plot(T,Pu,'-','Color','g',...
    'MarkerEdgeColor','m',...
    'MarkerFaceColor','m',...
    'MarkerSize',12,'LineWidth',LineWidth1);
hold on 
grid on
end
FigSet.FontSize=18;
FigSet.Name1=['B样条拟合'];
hTitle = title(FigSet.Name1,'FontSize',FigSet.FontSize);

hXLabel = xlabel('\fontname{Times new roman}{\itX}\fontname{楷体}{\it轴}','FontSize',FigSet.FontSize);
hYLabel = ylabel('\fontname{Times new roman}{\itY}\fontname{楷体}{\it轴}','FontSize',FigSet.FontSize);
FigSet.PaperPosition=[0,0,30,10];
set(gcf, 'PaperPosition', FigSet.PaperPosition);
% 指定figure的尺寸
FigSet.Size=[0,0,20,15];
set(gcf,'unit','centimeters','position',FigSet.Size);
% 改变ylabel离坐标轴的距离
set(findobj('FontSize',1),'FontSize',FigSet.FontSize);

%% 

subplot(2,2,1)
x=0:0.5:3*pi;
y=sin(x)+0.1*randn(size(x));
for i=9
p=polyfit(x,y,i-1);
xx=0:0.1:3*pi;
yy=polyval(p,xx);
plot(xx,yy,'g','LineWidth',LineWidth1);
hold on;
grid on;
end

y(2)=y(2)-1;
for i=9
p=polyfit(x,y,i-1);
xx=0:0.1:3*pi;
yy=polyval(p,xx);
plot(xx,yy,'b','LineWidth',LineWidth1);
hold on;
grid on;
end
plot(x,y,'.r','MarkerSize',12);

FigSet.FontSize=18;
FigSet.Name1=['多项式拟合'];
hTitle = title(FigSet.Name1,'FontSize',FigSet.FontSize);

hXLabel = xlabel('\fontname{Times new roman}{\itX}\fontname{楷体}{\it轴}','FontSize',FigSet.FontSize);
hYLabel = ylabel('\fontname{Times new roman}{\itY}\fontname{楷体}{\it轴}','FontSize',FigSet.FontSize);




subplot(2,2,2)
y(2)=y(2)+1;
for i=9
A=50;B=5;C=1;
MPNum=i;
spdeg=3;
MP=[0,MPNum];
mp=zeros(MPNum,1);
%% 标准曲线，误差曲线绘制
% 节点参数的生成
% 读取型值点坐标，型值点的坐标弦长，累加弦长/总弦长
tt=x;
yy=y;
% plot(tt,yreal,'-k','MarkerSize',12)
% hold on 
%% 重新构建时间节点
tstart=tt(1);tend=tt(end);
M.ST(1)=tstart;M.RT(1)=tend;
[knots]=Make_Bspline_knots(M,spdeg,MP);%
[dmp] = SubJcbBspline(mp,tt,knots,spdeg,yy);




T=linspace(tstart,tend,50);
for j=1:length(T)
    py=0;
    for i=1:length(dmp)
        py=py+dmp(i)*Bbase(i,spdeg,T(j),knots{1});
    end
    Pu(j)=py;
end
c=plot(T,Pu,'-','Color','g',...
    'MarkerEdgeColor','m',...
    'MarkerFaceColor','m',...
    'MarkerSize',10,'LineWidth',LineWidth1);
hold on 
grid on
end
y(2)=y(2)-1;
for i=9
A=50;B=5;C=1;
MPNum=i;
spdeg=3;
MP=[0,MPNum];
mp=zeros(MPNum,1);
%% 标准曲线，误差曲线绘制
% 节点参数的生成
% 读取型值点坐标，型值点的坐标弦长，累加弦长/总弦长
tt=x;
yy=y;
yreal=A*sin(2*tt);
plot(tt,yy,'.r','MarkerSize',12)
hold on
% plot(tt,yreal,'-k','MarkerSize',12)
% hold on 
%% 重新构建时间节点
tstart=tt(1);tend=tt(end);
M.ST(1)=tstart;M.RT(1)=tend;
[knots]=Make_Bspline_knots(M,spdeg,MP);%
[dmp] = SubJcbBspline(mp,tt,knots,spdeg,yy);




T=linspace(tstart,tend,50);
for j=1:length(T)
    py=0;
    for i=1:length(dmp)
        py=py+dmp(i)*Bbase(i,spdeg,T(j),knots{1});
    end
    Pu(j)=py;
end
b=plot(T,Pu,'-','Color','b',...
    'MarkerEdgeColor','m',...
    'MarkerFaceColor','m',...
    'MarkerSize',10,'LineWidth',LineWidth1);
hold on 
grid on
end

FigSet.FontSize=18;
FigSet.Name1=['B样条拟合'];
hTitle = title(FigSet.Name1,'FontSize',FigSet.FontSize);

hXLabel = xlabel('\fontname{Times new roman}{\itX}\fontname{楷体}{\it轴}','FontSize',FigSet.FontSize);
hYLabel = ylabel('\fontname{Times new roman}{\itY}\fontname{楷体}{\it轴}','FontSize',FigSet.FontSize);



ah = axes('position',get(gca,'position'),'visible','off'); %新建一个坐标轴对象，位置和当前的坐标轴一致，并且设置为不可见，这样就不会覆原来绘制的图
legend2 = legend([a,c,b],{'数值点','无粗差拟合曲线','粗差拟合曲线'},'FontSize', 13,'FontName','楷体','location','northeast');   %  设置第2个图例，注意这里需要传入建立的坐标轴对象

set(legend2,'Orientation','vertical');  % 默认垂直排列  改为水平排列
FigSet.PaperPosition=[0,0,30,10];
set(gcf, 'PaperPosition', FigSet.PaperPosition);