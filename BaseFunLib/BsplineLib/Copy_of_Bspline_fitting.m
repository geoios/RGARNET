clear all;close all;clc
%% 设置B样条曲线拟合的p次数和控制点的n个数（0，1，...n）
n=100;p=3;A=50;B=5;C=1;
lambda0=0;
%% 标准曲线，误差曲线绘制
% 节点端点p+1重
% knots_First=zeros(1,p+1);
% knots_End=ones(1,p+1);

% 非重节点
knots_First=zeros(1,p);
knots_End=ones(1,p);

% 节点参数的生成
% 读取型值点坐标，型值点的坐标弦长，累加弦长/总弦长
load('matlab123.mat')
yy=yy(10,:)';
plot(xx,yy,'.g','MarkerSize',12)
hold on
%% 采用高斯平滑
% SS=smooth(yy);
% plot(xx,SS,'.r','MarkerSize',12);
% hold on 
%% 节点生成
% for i=1+1:length(xx)
%     Li(i-1)=sqrt(xx(i)^2+yy(i)^2);
% end
% L=sum(Li);
%
% t(1)=0;
% for i=1:length(Li)
%     Lki=0;
%     for j=1:i
%         Lki=Lki+Li(j);
%     end
%     t(i+1)=Lki/L;
% end
%
% % 生成节点
% % 节点初始化
% knots0=zeros(1,p+1);
% paras_temp=t;
% % 节点个数U（0，1，...，n+k+1）
% m=n+p+1;
% % 段数 为n+1段
% num=m-p;
% ind=linspace(0,length(paras_temp)-1,num);
% ind=fix(ind);
% for i=1:length(ind)
%     paras_knots(i)=paras_temp(ind(i)+1);
% end
% % 从整体中均等取出n+1段
% for j=1+1:1:n-p+1
%     k_temp=0;
%     for i=j:j+p-1
%         k_temp=k_temp+paras_knots(i);
%     end
%     k_temp=k_temp/p;
%     knots0(j-1)=k_temp;
% end
% knots=[knots_First,knots0,knots_End];

%% 重新构建时间节点
% 假定时间发生在下午2：00-3：00
tstart=xx(1);
tend=xx(end);
knots0=linspace(tstart,tend,n-2);
dkn=(tend-tstart)/(n-3);
for i=1:1:p
    knots_First(i)=tstart-(p-i+1)*dkn;
    knots_End(i)=tend+i*dkn;
end
knots=[knots_First,knots0,knots_End];

t=linspace(tstart,tend,299);

% t不等间距
% for i=2:1:length(t)-1
%     t(i)=t(i)+randn(1);
% end

%% 型值点拟合控制点
% 控制点初始化,确定控制点的个数
% P=zeros(n+1,2);
P=zeros(n,2);
%% 增加粗糙惩罚的样条拟合  K=Q*inv(R)*Q';

% 计算正则项
S=length(knots0)+2;
Q=zeros(S-2,S);
R=zeros(S-2,S-2);

for i=1:1:S-2
    % 定义节点区间长度，h=t(i+1)-t(i)
    dk0=knots(i+p+1)-knots(i+p);
    dk1=knots(i+p+2)-knots(i+p+1);
    
    % 构建矩阵Q和R
    Q(i,i)=1/dk0;
    Q(i,i+1)=-1/dk0-1/dk1;
    Q(i,i+2)=1/dk1;
    if i>=2
        R(i,i-1)=1/6*dk0;
        R(i-1,i)=1/6*dk0;
    end
    R(i,i)=1/3*(dk0+dk1);
end
K=Q'*inv(R)*Q;

%% 不考虑端点
% 初始化B样条基函数
% N=zeros(length(xx),n);
% for i=1:1:length(xx)
%     for j=1:1:size(P,1)
%         N(i,j)=Bbase(j,p,t(i),knots);
%     end
% end
% l=[xx;yy];
% dd= inv(N'*N)*N'*l';
%
% for i=1:1:length(P)
%     P(i,1)=dd(i,1);
%     P(i,2)=dd(i,2);
% end
% plot(P(:,1),P(:,2),'or');
% hold on

%% 考虑端点.
% P(1,1)=xx(1);P(1,2)=yy(1);
% P(n+1,1)=xx(length(xx));P(n+1,2)=yy(length(yy));
% 初始化B样条基函数
% N=zeros(length(xx)-2,n-2);
% 构建法方程的设计矩阵
% for i=2:1:length(xx)-1
%     for j=2:1:size(P,1)-1
%         N(i-1,j-1)=Bbase(j,p,t(i),knots);
%     end
% end

% l=[xx(2:length(yy)-1);yy(2:length(yy)-1)];

% for i=2:length(xx)-1
%     Lx(i-1)=xx(i)-P(1,1)*Bbase(1,p,t(i),knots)-P(n+1,1)*Bbase(n+1,p,t(i),knots);
%     Ly(i-1)=yy(i)-P(1,2)*Bbase(1,p,t(i),knots)-P(n+1,2)*Bbase(n+1,p,t(i),knots);
% end
% Ll=[Lx;Ly];
% dd= inv(N'*N+lambda*K)*N'*Ll';
% for i=2:1:length(P)-1
%     P(i,1)=dd(i-1,1);
%     P(i,2)=dd(i-1,2);
% end

%% B样条过拟合，进行正则化处理，确定最适正则参数，使用模式搜索法确定CV（交叉有效）min的方式.

% 使用模式搜索法求解CV最小，最适lambda.
xk1=[1];
[ CV,lambda1,EDF,SSE,R2,MSE] = Hooke_Jeeves_CV(xk1,Q',R,yy);

% 测试函数图像
% ZZ=linspace(1,100,100);
% for i=length(ZZ)
%     CC(i)=function1( ZZ(i),Q',R,yy );
% end
% figure
% plot(ZZ,CC,'.b')
% hold on

%% B样条过拟合，进行正则化处理，确定最适正则参数，使用模式搜索法确定GCV（广义交叉有效）min的方式
xk2=[10^6];
[ GCV,lambda2] = Hooke_Jeeves_GCV(xk2,Q',R,yy);


%%
N=zeros(length(xx),n);
for i=1:1:length(xx)
    for j=1:1:size(P,1)
        N(i,j)=Bbase(j,p,t(i),knots);
    end
end
l=[xx;yy];
for i=1:length(xx)
    Lx(i)=xx(i);Ly(i)=yy(i);
end

Ll=[Lx;Ly];
dd0=inv(N'*N+lambda0*K)*N'*Ll';
dd= inv(N'*N+lambda1*K)*N'*Ll';
dd2=inv(N'*N+lambda2*K)*N'*Ll';

for i=1:1:length(P)
    P(i,1)=dd(i,1);
    P(i,2)=dd(i,2);
    P0(i,1)=dd0(i,1);
    P0(i,2)=dd0(i,2);
    P2(i,1)=dd2(i,1);
    P2(i,2)=dd2(i,2);
end

% plot(P0(:,1),P0(:,2),'or');
% hold on
%% C模拟法
% Bm=n-1-p;
% for i=0:1:Bm
%     for u=0:0.05:1
%         px=0;py=0;
%         for k=0:1:p
%             px=px+P(i+k+1,1)*Bbase2(u,k,p);
%             py=py+P(i+k+1,2)*Bbase2(u,k,p);
%         end
%         Pt(1,j)=px; Pt(2,j)=py;
%         j=j+1;
%     end
%     plot(Pt(1,:),Pt(2,:),'k');
% end
%% bestain 模拟
T=linspace(tstart,tend,298);
for j=1:length(T)
    px=0;py=0;
    for i=1:n
        px=px+P0(i,1)*Bbase(i,p,T(j),knots);
        py=py+P0(i,2)*Bbase(i,p,T(j),knots);
    end
    Pu(1,j)=px;Pu(2,j)=py;
end
plot(Pu(1,:),Pu(2,:),'-','Color','b',...
    'MarkerEdgeColor','m',...
    'MarkerFaceColor','m',...
    'MarkerSize',10)
hold on

T=linspace(tstart,tend,298);
for j=1:length(T)
    px=0;py=0;
    for i=1:n
        px=px+P(i,1)*Bbase(i,p,T(j),knots);
        py=py+P(i,2)*Bbase(i,p,T(j),knots);
    end
    Pu(1,j)=px;Pu(2,j)=py;
end
plot(Pu(1,:),Pu(2,:),'-','Color','r',...
    'MarkerEdgeColor','m',...
    'MarkerFaceColor','m',...
    'MarkerSize',10)
hold on

T=linspace(tstart,tend,298);
for j=1:length(T)
    px=0;py=0;
    for i=1:n
        px=px+P2(i,1)*Bbase(i,p,T(j),knots);
        py=py+P2(i,2)*Bbase(i,p,T(j),knots);
    end
    Pu(1,j)=px;Pu(2,j)=py;
end
plot(Pu(1,:),Pu(2,:),'-','Color','m',...
    'MarkerEdgeColor','m',...
    'MarkerFaceColor','m',...
    'MarkerSize',10)
hold on

title('B样条拟合曲线')
xlabel('X轴');
ylabel('Y轴');
legend({'型值点','lambda=0','CV最适lambda','GCV最适lambda'});
% legend({'型值点','原函数','拟合曲线'});
axis([1500 5500  -2 2]);%坐标轴的范围

%% 检验CV、GCV是否最小
for i=0:10^5:10^8
    if CV > function_CV( i,Q',R,yy )
        disp('CV is not min');
        i
        break;
    end
end
for i=0:10^5:10^8
    if GCV > function_GCV( i,Q',R,yy )
         disp('GCV is not min')
         i
        break;
    end
end

%% 主成分分析作为权重最适的选取
% [U S V]=svd(N);