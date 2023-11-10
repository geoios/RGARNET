clear all;close all;clc
Px=[0, 1, 2, 3, 4, 5];
Py=[1, 4, 2, 5, 1, 3];
plot(Px,Py,'.k','MarkerSize',12);
hold on
plot(Px,Py);
hold on
n=2;
m=length(Px)-1-n;
j=1;

for i=3
    for t=0:0.05:1
        px=0;py=0;
        for k=0:1:n
            px=px+Px(i+k+1)*Bbase2(t,k,n);
            py=py+Py(i+k+1)*Bbase2(t,k,n);
            plot(Px(i+k+1),Py(i+k+1),'or',...
                'MarkerSize',9)
            
        end
        Pt(1,j)=px; Pt(2,j)=py;
        j=j+1;
    end
    plot(Pt(1,:),Pt(2,:),'-','Color','r',...
                'MarkerEdgeColor','m',...
               'MarkerFaceColor','m',...
                'MarkerSize',5);
end
xlabel('X轴');
ylabel('Y轴');
legend({'控制点','B样条控制多边形','使用的控制点'});

title('2次第4段B样条拟合曲线段')
axis([-0.5 5.5   0.5 5.5]);%坐标轴的范围