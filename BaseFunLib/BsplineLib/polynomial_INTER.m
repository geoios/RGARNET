%% ����ʽ��ֵ polyfit   polyval
close
clc
clear
% x=linspace(0,2*pi,10); %ȡy=sinx�ϵ�ʮ�����ݵ�
x=load('ʱ��.txt');
% y=sin(x);
y=load('λ��.txt');
P=polyfit(x,y,6) %7Ϊ��Ͻ�����pΪ����ʽ��ϵ��
poly2str(P,'x'); %��װ�ɲ�ֵ����ʽ
x1=linspace(min(x),max(x),100);
y1=polyval(P,x1);%��x1�����ֵ����ʽ�е�x
plot(x,y,'o',x1,y1)
 
% x=linspace(1000,2000,10);  %��ʼ10�����ݵ�
% y=1e5*[0.02 0.04 0.05 0.055 0.5 0.6 0.9 1.52 2.3 3.6];
% plot(x,y,'o')%���ݵ��ͼ
% hold on
% x1=linspace(1000,2000,100);  
% [P,~,mu]=polyfit(x,y,6); %muΪ���к����Ų��� ����鿴��������
% y1=polyval(P,x1,[],mu);
% plot(x1,y1)