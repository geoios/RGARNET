function [FigSet] = PlotFig6_Data(TimeList)
%% 绘制数据
FigSet.PlotModel = 'line';FigSet.SubplotModel = 'solo';
ListNum = size(TimeList,1);XL = [1:ListNum]';
FigSet.Data{1,1} = [XL,TimeList(:,1)];FigSet.Data{1,2} = [XL,TimeList(:,2)];
FigSet.LineType = {'-or','-*b'};

% 坐标轴
FigSet.xlabelName = {'\fontname{Times new roman}{Start and end dates}'};
FigSet.ylabelName = {'\fontname{Times new roman}{Runtime duration(s)}'};
FigSet.Label.FontSize = 18;

FigSet.legendName = {'\fontname{Times new roman}{Ordinary LS algorithm (11)}','\fontname{Times new roman}{Sequential LS algorithm (21)}'};
PosNameList = {'1209-1211','1209-1212','1209-1302','1209-1306','1209-1309','1209-1311','1209-1401',...
    '1209-1408','1209-1501','1209-1504','1209-1508','1209-1510','1209-1602','1209-1605','1209-1607','1209-1610','1209-1703',...
    '1209-1704','1209-1708','1209-1801','1209-1802','1209-1808','1209-1903','1209-1906','1209-1910','1209-2002','1209-2006'}; % 后续更改自适应
FigSet.Xticks.LableNum{1} = [1:ListNum];
FigSet.Xticks.LableStr{1} = {PosNameList{1:ListNum}};
FigSet.Frame = 'grid';
FigSet.global.FontSize = 18;
FigSet.global.Fontname = 'Times new roman';
FigSet.global.linewidth = 1;
FigSet.Size=[0,0,30,15];                                % 指定figure的尺寸
FigSet.PaperPosition=[0,0,40,20];                       % 设定图窗大小和位置                     % 设定图窗大小和位置
% FigSet.LabelLimit.XLimit = [1,ListNum];
% FigSet.LabelLimit.YLimit = [0,10000];
FigSet.StorgePath = 'FigRes\Figure_6_Runtime_increasing_with_the_remeasurement_period_numbre_N.png';
end

