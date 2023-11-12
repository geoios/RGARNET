function [FigSet] = Baseline_Plot_Fig10(BLList1,BLList2,BLList3)

PosNameList = {'1209','1211','1212','1302','1306',...
    '1309','1311','1401','1408','1501','1504','1508','1510','1602','1605','1607','1610','1703',...
    '1704','1708','1801','1802','1808','1903','1906','1910','2002','2006'}; % 后续更改自适应


BaselineList0005_4 = [BLList1(:,4),BLList1(:,5),BLList1(:,2),BLList1(:,6)];
BaselineList001_4 = [BLList2(:,4),BLList2(:,5),BLList2(:,2),BLList2(:,6)];

Num = size(A,1);
X = [1:Num]';
FigSet.Data{1,1} = [X, BLList1(:,4)];
FigSet.Data{1,2} = [X, BLList2(:,4)];
FigSet.Data{1,3} = [X, BLList3(:,4)];

FigSet.Data{2,1} = [X, BLList1(:,5)];
FigSet.Data{2,2} = [X, BLList2(:,5)];
FigSet.Data{2,3} = [X, BLList3(:,5)];

FigSet.Data{3,1} = [X, BLList1(:,2)];
FigSet.Data{3,2} = [X, BLList2(:,2)];
FigSet.Data{3,3} = [X, BLList3(:,2)];

FigSet.Data{4,1} = [X, BLList1(:,6)];
FigSet.Data{4,2} = [X, BLList2(:,6)];
FigSet.Data{4,3} = [X, BLList3(:,6)];


FigSet.xlabelName ={'','','','\fontname{Times new roman}{Epochs}'} ;
FigSet.ylabelName{1}  = 'M12-M14(m)';FigSet.ylabelName{2}  = 'M12-M15(m)';FigSet.ylabelName{3}  = 'M13-M14(m)';FigSet.ylabelName{4}  = 'M13-M15(m)';

FigSet.global.FontSize = 15;
FigSet.global.Fontname = 'Times new roman';
FigSet.global.linewidth = 1;

FigSet.legendType = 'Outside_Top';
FigSet.legendName= {'\fontname{Times new roman}{\mu_0 = 0.005}','\fontname{Times new roman}{\mu_0 = 0.01}','\fontname{Times new roman}{\mu_0 = 10}'};
FigSet.legendPos = [0.25 0.94 0.6 0.05];
FigSet.legendCol = 3;


FigSet.SubComb = [4,1];
FigSet.PlotModel = 'line';
FigSet.SubplotModel= 'subplot';
FigSet.LineType = {'-g','-r','-b','-g','-r','-b','-g','-r','-b','-g','-r','-b'};
FigSet.Frame = 'grid';

FigSet.Label.FontSize = 15;
FigSet.Size=[0,0,20,20];        
FigSet.PaperPosition=[0,0,20,10];    

FigSet.Xticks.LableNum = {X;X;X;X};
LableStr = {PosNameList{X}};
FigSet.Xticks.LableStr = {LableStr;LableStr;LableStr;LableStr};

FigSet.StorgePath = 'FigRes\Figure_10_Baseline_length_time_series_of_M12_M14_M12_M15_M13_M14_M14_M15.png';


end

