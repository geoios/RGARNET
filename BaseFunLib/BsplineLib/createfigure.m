function createfigure(Y1)
%CREATEFIGURE(Y1)
%  Y1:  y ���ݵ�����

%  �� MATLAB �� 30-Mar-2021 10:32:37 �Զ�����

% ���� figure
figure1 = figure;

% ���� axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');

% ���� plot
plot(Y1);

box(axes1,'on');
% ������������������
set(axes1,'FontName','Arial','FontSize',12);
