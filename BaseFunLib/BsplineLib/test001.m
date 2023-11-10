close all ;clear all; clc
%% 
% delta=1;alpha=2;beta=0.25;epsilon=0.005;xk=[-10];
% xx=linspace(-10,10,100);
% for i=1:1:length(xx)
%     yy(i)=function1(xx(i));
% end
% plot(xx,yy,'.b')
% [ Y,yk ] = Hooke_Jeeves( delta,alpha,beta,epsilon,xk );
%% B样条函数表示常数
P0=[1,1,1,1,1,1];
knots=1:10;
n=6;
T=linspace(1,10,100);
for j=1:length(T)
    px=0;py=0;
    for i=1:n
        px=px+P0(i)*Bbase(i,3,T(j),knots);
    end
    Pu(1,j)=px;
end
plot(T,Pu(1,:),'-','Color','b',...
    'MarkerEdgeColor','m',...
    'MarkerFaceColor','m',...
    'MarkerSize',10)
hold on


