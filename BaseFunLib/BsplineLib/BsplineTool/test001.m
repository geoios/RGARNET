close all; clear; clc;close("all");
%% 获取当前脚本的位置
ScriptPath      = mfilename('fullpath');      % 脚本位置
[FilePath] = fileparts(ScriptPath);      % 文件夹位置
cd(FilePath);
clear FilePath;

%% B样条测试（De-Boor Cox 与 Clark）
Mp = [3,4,1,2];
knots = 0:2:14;
i=1;
for u = 6:0.1:8
    [Y(i)] = Bspline_Function(u,Mp,knots,3,1);
    [X(i)] = Bspline_Function(u,Mp,knots,3,2);
    i=i+1;
end
plot(6:0.1:8,Y,'ro')
hold on 
plot(6:0.1:8,X,'b.')


figure(2)
i=1;
for u = 6:0.1:8
[Y1(i),Y2(i)]=BsplineFunction(u,Mp,[6,8],3);
i=i+1;
end
plot(6:0.1:8,Y1,'ro')
hold on 
plot(6:0.1:8,Y2,'b.')

%%
X=(0:0.2:10)';

Mp=[2,3,1,4];
knots=[-2,0,2,4,6,8,10,12];
spdeg=3;
j=1;
for t=4:0.1:6
    [Y] = BsplineFunction(t,Mp,knots,spdeg);
end


% plot(0:0.5:10,Y,'ro')


%%
% Create the knots sequences
t1 = [0 1 2];
t2 = [3 4 5  6];
t3 = [7  8  9 10 11];
tt = [t1 t2 t3];

% Accessory variables and commands for plotting purposes
cl = ['g','r','b','k','k'];
v = 5.4; d1 = 2.5; d2 = 0; s1 = 1; s2 = .5;
ext = tt([1 end])+[-.5 .5];
plot(ext([1 2]),[v v],cl(5))
hold on
plot(ext([1 2]),[d1 d1],cl(5))
plot(ext([1 2]),[d2 d2],cl(5))
ts = [tt;tt;NaN(size(tt))];
ty = repmat(.2*[-1;0;NaN],size(tt));
plot(ts(:),ty(:)+v,cl(5))
plot(ts(:),ty(:)+d1,cl(5))
plot(ts(:),ty(:)+d2,cl(5))

% Spline 1 (linear)
b1 = spmak(t1,1); % 生成B样条函数
p1 = [t1;0 1 0];
% Calculate the first and second derivative of spline 1   %% 计算1次样条的一阶导数和二阶导数
db1 = fnder(b1);  % 求导一次
p11 = fnplt(db1,'j');  % 绘图
p12 = fnplt(fnder(db1)); % 求导二次
lw = 2;
plot(p1(1,:),p1(2,:)+v,cl(2),'LineWidth',lw)
plot(p11(1,:),s1*p11(2,:)+d1,cl(2),'LineWidth',lw)
plot(p12(1,:),s2*p12(2,:)+d2,cl(2),'LineWidth',lw)

% Spline 2 (quadratic)
b1 = spmak(t2,1);
p1 = fnplt(b1);
% Calculate the first and second derivative of spline 2    %% 计算2次样条的一阶导数和二阶导数
db1 = fnder(b1);
p11 = [t2;fnval(db1,t2)];
p12 = fnplt(fnder(db1),'j');
plot(p1(1,:),p1(2,:)+v,cl(3),'LineWidth',lw)
plot(p11(1,:),s1*p11(2,:)+d1,cl(3),'LineWidth',lw)
plot(p12(1,:),s2*p12(2,:)+d2,cl(3),'LineWidth',lw)

% Spline 3 (cubic)
b1 = spmak(t3,1);
p1 = fnplt(b1);
% Calculate the first and second derivative of spline 3     %% 计算3次样条的一阶导数和二阶导数
db1 = fnder(b1);
p11 = fnplt(db1);
p12=[t3;fnval(fnder(db1),t3)];
plot(p1(1,:),p1(2,:)+v,cl(4),'LineWidth',lw)
plot(p11(1,:),s1*p11(2,:)+d1,cl(4),'LineWidth',lw)
plot(p12(1,:),s2*p12(2,:)+d2,cl(4),'LineWidth',lw)

% Formatting the plot
tey = v+1.5;
text(t1(2)-.5,tey,'linear','FontSize',12,'Color',cl(2))
text(t2(2)-.8,tey,'quadratic','FontSize',12,'Color',cl(3))
text(t3(3)-.5,tey,'cubic','FontSize',12,'Color',cl(4))
text(-2,v,'B','FontSize',12)
text(-2,d1,'DB','FontSize',12)
text(-2,d2,'D^2B')
axis([-1 12 -2 7.5])
title({'B-splines with Simple Knots and Their Derivatives'})
axis off
hold off