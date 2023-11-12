function [FigSet] = Baseline_Plot_Fig11(A,B,C)

PosNameList = {'1209','1211','1212','1302','1306',...
    '1309','1311','1401','1408','1501','1504','1508','1510','1602','1605','1607','1610','1703',...
    '1704','1708','1801','1802','1808','1903','1906','1910','2002','2006'}; % 后续更改自适应

%% Data
Num = size(A,1);
X = [1:Num]';
FigSet.Data{1,1} = [X, A(:,1)];
FigSet.Data{1,2} = [X, B(:,1)];
FigSet.Data{1,3} = [X, C(:,1)];


FigSet.Data{2,1} = [X, A(:,2)];
FigSet.Data{2,2} = [X, B(:,2)];
FigSet.Data{2,3} = [X, C(:,2)];

%% Fig Set
FigSet.xlabelName{1} = '';FigSet.xlabelName{2} = '\fontname{Times new roman}{Epochs}';
FigSet.ylabelName{1}  = 'M12-M13(m)';FigSet.ylabelName{2}  = 'M14-M15(m)';

FigSet.global.FontSize = 15;
FigSet.global.Fontname = 'Times new roman';
FigSet.global.linewidth = 1;

FigSet.legendType = 'Outside_Top';
FigSet.legendName= {'\fontname{Times new roman}{\mu_0 = 0.005}','\fontname{Times new roman}{\mu_0 = 0.01}','\fontname{Times new roman}{\mu_0 = 10}'};
FigSet.legendPos = [0.25 0.94 0.6 0.05];
FigSet.legendCol = 3;



FigSet.SubComb = [2,1];
FigSet.PlotModel = 'line';
FigSet.SubplotModel= 'subplot';
FigSet.LineType = {'-g','-r','-b','-g','-r','-b'};
FigSet.Frame = 'grid';


FigSet.Label.FontSize = 15;
FigSet.Size=[0,0,20,12];
FigSet.PaperPosition=[0,0,20,10];

FigSet.Xticks.LableNum = {X;X};
LableStr = {PosNameList{X}};
FigSet.Xticks.LableStr = {LableStr;LableStr};

FigSet.StorgePath = 'FigRes\Figure_11_Baseline_length_time_series_of_M12_M13_M14_M15.png';

end

