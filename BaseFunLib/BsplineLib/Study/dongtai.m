clc;
close all;
x1=0;s=0.2;%ȷ����ʼ�������
nframes=50;%ȷ���ܶ���֡��
for k=1:nframes
    x1=x1+s;%ȷ����ͼʱ�ĺ�������ֵֹx1
    x=0:0.01:x1;
    y=sin(x);
    plot(x,y);
    axis([0 2*pi   -1.2 1.2]);%������ķ�Χ
    m(k)=getframe;%����ǰͼ�δ������m��
end
movie(m,3)%�ظ�3�˲��Ŷ���
