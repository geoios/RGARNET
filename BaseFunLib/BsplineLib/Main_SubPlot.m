clc
clear all
%% ��ȡ��ǰ�ű���λ��
ScriptPath = mfilename('C:\Users\asus\Desktop\shujuchuli\PlotFigure');      % �ű�λ��
[FilePath] = fileparts(ScriptPath);      % �ļ���λ��
cd(FilePath);
clear FilePath;

%%% ���ػ� ���ø��Ի������ò���
Par.FigSet.Name = 'Demo';
Par.FigSet.Path = 'C:\Users\asus\Desktop\shujuchuli\PlotFigure\'; %% �����ļ�·������Ϊ�գ������ڵ�ǰ·����
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
%%%% ��ͼ�����
PlotFigFrame(Data,Par)

%%%%%%%%%%%%%%%%%%%%%% ���� stemͼ ʵ��  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% ��Ҫչ�֣���η�װ�����ͬ�Ļ�ͼ��������ʹ�ñ�ļ򵥣�%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%������ע����ǰ���ĵĲ����ͻ�ͼ������                 %%%%%%%%%%%%%%%%
N = 100;
Data.yData = rand(2,N);
Data.xData = [[1:N];[1:N]];
Par.FigSet.Name = 'StemDemo';
Par.FigSet.Path = 'D:\github\Apps\PlotFigure\'; %% �����ļ�·������Ϊ�գ������ڵ�ǰ·����
Par.LineSet.LegTit = {'aa' 'bb'};

Par.PlotFun = @PlotStem;
%%%% ��ͼ�����
PlotFigFrame(Data,Par);

