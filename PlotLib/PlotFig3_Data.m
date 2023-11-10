function [FigSet] = PlotFig3_Data()
%% 读取阵列解算
ResMYGI = readtable('demo_res\res.MYGI.dat');
EW0 = ResMYGI.EW_m_;NS0 = ResMYGI.NS_m_;UD0 = ResMYGI.UD_m_;

%% 读取紧约束
ResMYGI = readtable('demo_timeSeq\res.MYGI.dat');
EW1 = ResMYGI.EW_m_;NS1 = ResMYGI.NS_m_;UD1 = ResMYGI.UD_m_;


%% 绘制数据
FigSet.PlotModel = 'line';FigSet.SubplotModel = 'subplot';FigSet.SubComb  = [3,1];

DataNum = length(EW0);XL = [1:DataNum]';
FigSet.Data{1,1} = [XL,EW0 * 100];
FigSet.Data{1,2} = [XL,EW1 * 100];

FigSet.Data{2,1} = [XL,NS0 * 100];
FigSet.Data{2,2} = [XL,NS1 * 100];

FigSet.Data{3,1} = [XL,UD0 *100];
FigSet.Data{3,2} = [XL,UD1 *100];


FigSet.LineType = {'-^m','-ob','-^m','-ob','-^m','-ob'};
FigSet.PointFull = [1,0,1,0,1,0];
FigSet.PointSize = [4,8,4,8,4,8];
% 坐标轴
FigSet.xlabelName = {'','','\fontname{Times new roman}{Epochs}'};
FigSet.ylabelName = {'\fontname{Times new roman}{E(cm)}','\fontname{Times new roman}{N(cm)}','\fontname{Times new roman}{U(cm)}'};
FigSet.Label.FontSize = 18;


FigSet.legendType = 'Outside_Top';
FigSet.legendName = {'\fontname{Times new roman}{Array-fixed solution}','\fontname{Times new roman}{Rigid array solution}'};
FigSet.legendPos = [0.17 0.94 0.7 0.05];
FigSet.legendCol = 2;

PosNameList = {'1209','1211','1212','1302','1306','1309','1311','1401',...
    '1408','1501','1504','1508','1510','1602','1605','1607','1610','1703',...
    '1704','1708','1801','1802','1808','1903','1906','1910','2002','2006'}; % 后续更改自适应
FigSet.Xticks.LableNum = {1:DataNum;1:DataNum;1:DataNum};
LableStr = {PosNameList{1:DataNum}};
FigSet.Xticks.LableStr = {LableStr;LableStr;LableStr};

FigSet.global.FontSize = 18;
FigSet.global.Fontname = 'Times new roman';
FigSet.global.linewidth = 1;
FigSet.Size=[0,0,20,15];                                % 指定figure的尺寸
FigSet.PaperPosition=[0,0,20,10];                       % 设定图窗大小和位置
FigSet.StorgePath = 'FigRes\Figure_3_Array-fixed_solution_and_rigid_array_solution.png';

end

