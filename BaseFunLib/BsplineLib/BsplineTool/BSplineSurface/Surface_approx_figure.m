close all; clear; clc;close("all");
%% 获取当前脚本的位置
ScriptPath      = mfilename('fullpath');      % 脚本位置
[FilePath] = fileparts(ScriptPath);      % 文件夹位置
cd(FilePath);
clear FilePath;

%% 已知数据
% H=[20:-1:0
%    21:-1:1
%    22:-1:2
%    23:-1:3
%    24:-1:4
%    25:-1:5
%    26:-1:6
%    27:-1:7];
% H=H+randn(8,21);
X=-2:0.2:2;Y=-2:0.2:2;
[x,y]=meshgrid(X,Y);
h=x.*exp(-x.^2-y.^2);
H=h+0.1*randn(21,21);
%% 假设D_X为我们所要选用的散点数据
% 确定u、v方向的B样条阶次
p=3;q=2;
% 参数个数
ParamU=5;ParamV=4;

[dP1,knotsV1,knotsU1] = Sunfunction(h,p,q,ParamU,ParamV);
[dP2,knotsV2,knotsU2] = Sunfunction(H,p,q,ParamU,ParamV);
%% 通过控制顶点表示B样条曲面

for v=1:0.2:10
    for u=1:0.2:10
        value1=0;value2=0;
        for i=1:ParamV
            for j=1:ParamU
                value1=value1+Bbase(i,q,v,knotsV1)*Bbase(j,p,u,knotsU1)*dP1(i,j);
                value2=value2+Bbase(i,q,v,knotsV2)*Bbase(j,p,u,knotsU2)*dP2(i,j);
            end
        end
        a=scatter3(v,u,value1,12,'r','filled');
        hold on
        b=scatter3(v,u,value2,12,'b','filled');
        hold on 
    end
end
xlabel('v');
ylabel('u')
zlabel('h')
h1=legend([a,b],{'无误差拟合点位','0.1倍标准正态拟合点位'},...
        'FontSize',12,'LineWidth',0.5);%'location','best'