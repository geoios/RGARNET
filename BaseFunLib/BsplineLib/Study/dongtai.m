clc;
close all;
x1=0;s=0.2;%确定起始点和增量
nframes=50;%确定总动画帧数
for k=1:nframes
    x1=x1+s;%确定画图时的横坐标终止值x1
    x=0:0.01:x1;
    y=sin(x);
    plot(x,y);
    axis([0 2*pi   -1.2 1.2]);%坐标轴的范围
    m(k)=getframe;%将当前图形存入矩阵m中
end
movie(m,3)%重复3此播放动画
