function [FigSet] = PlotFig4_Data()
%% 读取阵列解算
ResMYGI = readtable('demo_res\res.MYGI.dat');
EW0 = ResMYGI.EW_m_;NS0 = ResMYGI.NS_m_;UD0 = ResMYGI.UD_m_;

%% 读取紧约束
ResMYGI = readtable('demo_timeSeq\res.MYGI.dat');
EW1 = ResMYGI.EW_m_;NS1 = ResMYGI.NS_m_;UD1 = ResMYGI.UD_m_;


%% 绘制数据
% FigSet.PlotModel = 'line';FigSet.SubplotModel = 'subplot';FigSet.SubComb  = [3,1];
DataNum = length(EW0);XL = [1:DataNum]';
FigSet.Data{1,1} = [XL,(EW0- EW1) *100];

FigSet.Data{2,1} = [XL,(NS0- NS1)*100];

FigSet.Data{3,1} = [XL,(UD0- UD1) *100];


% FigSet.LineType = {'-or','-or','-or'};
% FigSet.PointFull = [1,1,1];
% % 坐标轴
% FigSet.xlabelName = {'','','\fontname{Times new roman}{Epochs}'};
% FigSet.ylabelName = {'\fontname{Times new roman}{E(cm)}',...
%     '\fontname{Times new roman}{N(cm)}',...
%     '\fontname{Times new roman}{U(cm)}'};
% FigSet.Label.FontSize = 18;
% 
% PosNameList = {'1209','1211','1212','1302','1306','1309','1311','1401',...
%     '1408','1501','1504','1508','1510','1602','1605','1607','1610','1703',...
%     '1704','1708','1801','1802','1808','1903','1906','1910','2002','2006'}; % 后续更改自适应
% FigSet.Xticks.LableNum = {1:DataNum;1:DataNum;1:DataNum};
% LableStr = {PosNameList{1:DataNum}};
% FigSet.Xticks.LableStr = {LableStr;LableStr;LableStr};
% 
% FigSet.global.FontSize = 18;
% FigSet.global.Fontname = 'Times new roman';
% FigSet.global.linewidth = 1;
% FigSet.Size=[0,0,20,15];                                % 指定figure的尺寸
% FigSet.PaperPosition=[0,0,20,10];                       % 设定图窗大小和位置
FigSet.StorgePath = 'FigRes\Figure_4_Difference_between_Array-fixed_solution_and_tigid_array_solution.png';

end

