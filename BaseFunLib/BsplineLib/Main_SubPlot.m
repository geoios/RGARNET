clc
clear all
%% 获取当前脚本的位置
ScriptPath = mfilename('C:\Users\asus\Desktop\shujuchuli\PlotFigure');      % 脚本位置
[FilePath] = fileparts(ScriptPath);      % 文件夹位置
cd(FilePath);
clear FilePath;

%%% 加载或 设置个性化的设置参数
Par.FigSet.Name = 'Demo';
Par.FigSet.Path = 'C:\Users\asus\Desktop\shujuchuli\PlotFigure\'; %% 保存文件路径，若为空，保存在当前路径下
k = 1;
Num = 100;
Col = 1;
Row = 1;
%for i = 1:Row
    %for j = 1:Col
        %Data.yData{i,j} = i*j*rand(2,Num);
        %Data.xData{i,j} = [[1:Num];[1:Num]];
        Data=load('C:\Users\asus\Desktop\shujuchuli\demo_prep\CHOS\1can1508.txt');
        Par.FigSet.YLab = 'residual*mean speed';
        Par.FigSet.XLab = 'dat No.';
       % Par.LineSet.LegTit{i,j} = {'ModelA' 'ModelB'};
    %end
%end
Par.PlotFun = @PlotSubFig;
%%%% 绘图和输出
PlotFigFrame(Data,Par)

%%%%%%%%%%%%%%%%%%%%%% 绘制 stem图 实例  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% 主要展现，如何封装多个不同的画图函数，让使用变的简单，%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%仅仅关注到当前关心的参数和画图函数。                 %%%%%%%%%%%%%%%%
N = 100;
Data.yData = rand(2,N);
Data.xData = [[1:N];[1:N]];
Par.FigSet.Name = 'StemDemo';
Par.FigSet.Path = 'D:\github\Apps\PlotFigure\'; %% 保存文件路径，若为空，保存在当前路径下
Par.LineSet.LegTit = {'aa' 'bb'};

Par.PlotFun = @PlotStem;
%%%% 绘图和输出
PlotFigFrame(Data,Par);

