clear all;close all;clc
%% ����ʽ��� ������ʽ��ϵ�p����
p=6;lambda=0;
%% ��ֵ�������
xx=linspace(0,6,21);
% xx=load('ʱ��.txt');
yy=5*sin(2*xx)+2*randn(1,length(xx));
% yy=load('λ��.txt');
plot(xx,yy,'.b','MarkerSize',8)
hold on 
% plot(xx,10*sin(2*xx),'.r','MarkerSize',8)
% hold on

%% ���������̵���ƾ���
% ��ƾ����ʼ��
B=zeros(length(xx),p+1);
% �����ƾ���
for i=1:1:length(xx)
    for j=1:1:p+1
        B(i,j)=xx(i)^(j-1);
    end
end
% ��ⷨ����
dl=(B'*B)\B'*yy';
%% ���ƶ���ʽ�������
% ����
Px=linspace(min(xx),max(xx),101);
% ��������ʽ����
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
title('�ζ���ʽ���')
xlabel('X��');
ylabel('Y��');
legend({'��ֵ��','����ʽ�������'});
