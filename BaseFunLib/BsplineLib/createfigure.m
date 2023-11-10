function createfigure(Y1)
%CREATEFIGURE(Y1)
%  Y1:  y 数据的向量

%  由 MATLAB 于 30-Mar-2021 10:32:37 自动生成

% 创建 figure
figure1 = figure;

% 创建 axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');

% 创建 plot
plot(Y1);

box(axes1,'on');
% 设置其余坐标区属性
set(axes1,'FontName','Arial','FontSize',12);
