close all;clear all;clc;
% 设置控制点
Px=[0, 1/10, 3/10, 5/10, 7/10, 9/10];
Py=[1, 4, 2, 5, 1, 3];
NodeVector=[0,1/10,2/10,3/10,4/10,5/10,6/10,7/10,8/10,9/10,1];
plot(Px,Py,'.k','MarkerSize',12);
hold on
plot(Px,Py);
hold on
k=2;
m=length(Px);
j=1;

u=0.6;
px=0;py=0;
for i=1:1:m
    px=px+Px(i)*Bbase(i,k,u,NodeVector);
    py=py+Py(i)*Bbase(i,k,u,NodeVector);
end
plot(px,py,'o','Color','c',...
                'MarkerEdgeColor','c',...
               'MarkerFaceColor','c',...
                'MarkerSize',5);


for u=NodeVector(k+1):0.005:NodeVector(m+1)
    px=0;py=0;
    for i=1:1:m
        px=px+Px(i)*Bbase(i,k,u,NodeVector);
        py=py+Py(i)*Bbase(i,k,u,NodeVector);
    end
    Pt(1,j)=px; Pt(2,j)=py;
    j=j+1;
end
plot(Pt(1,:),Pt(2,:),'-','Color','r',...
    'MarkerEdgeColor','m',...
    'MarkerFaceColor','m',...
    'MarkerSize',5);

hold on

         
% for i=0:1:3
%     for t=0:0.05:1
%         px=0;py=0;
%         for k=0:1:n
%             px=px+Px(i+k+1)*Bbase2(t,k,n);
%             py=py+Py(i+k+1)*Bbase2(t,k,n);
% %             plot(Px(i+k+1),Py(i+k+1),'or',...
% %                 'MarkerSize',9)
%         end
%         Pt(1,j)=px; Pt(2,j)=py;
%         j=j+1;
%     end
%     plot(Pt(1,:),Pt(2,:),'-','Color','r',...
%                 'MarkerEdgeColor','m',...
%                'MarkerFaceColor','m',...
%                 'MarkerSize',5);
% end
xlabel('t轴');
ylabel('α轴');
legend({'控制点','B样条控制多边形','B样条带入值','B样条拟合曲线'});

title('B样条拟合曲线段')
axis([0 1   0.5 5.5]);%坐标轴的范围