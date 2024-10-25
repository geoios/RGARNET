function [FigSet] = PlotFig7_Data(TimeList,deltaX)
%% Plot
FigSet.PlotModel = 'line';
FigSet.PlotModel_left = 'line';FigSet.SubplotModel = 'biax';FigSet.PlotModel_right = 'point';
ListNum = size(TimeList,1);XL = [1:ListNum]';
FigSet.Data_left{1,1} = [XL,TimeList(:,1)];FigSet.Data_left{1,2} = [XL,TimeList(:,2)];
FigSet.Data_right{1,1} = [XL,deltaX(:,1)];
FigSet.LineType = {'-ob','-*b'};FigSet.MarkerSize = 10;FigSet.PointType = {'^r'};

% axis
FigSet.xlabelName = {'\fontname{Times new roman}{The Number N of campaigns}'};
FigSet.ylabelName_left = {'\fontname{Times new roman}{Runtime duration(s)}'};
FigSet.ylabelName_right = {'\fontname{Times new roman}{||\bfX_{20} - \bfX_{28}||_2(m)}'};
FigSet.Label.FontSize = 18;

FigSet.legendName = {'\fontname{Times new roman}{OA}','\fontname{Times new roman}{EA}','\fontname{Times new roman}{Positional error of EA}'};
% PosNameList = {'1209-1211','1209-1212','1209-1302','1209-1306','1209-1309','1209-1311','1209-1401',...
%     '1209-1408','1209-1501','1209-1504','1209-1508','1209-1510','1209-1602','1209-1605','1209-1607','1209-1610','1209-1703',...
%     '1209-1704','1209-1708','1209-1801','1209-1802','1209-1808','1209-1903','1209-1906','1209-1910','1209-2002','1209-2006'};
PosNameList = {'2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28'};
FigSet.Xticks.LableNum{1} = [1:ListNum];
FigSet.Xticks.LableStr{1} = {PosNameList{1:ListNum}};
FigSet.Frame = 'grid';
FigSet.global.FontSize = 18;
FigSet.global.Fontname = 'Times new roman';
FigSet.global.linewidth = 1;
FigSet.Size=[0,0,30,15];
FigSet.PaperPosition=[0,0,40,20];
FigSet.LabelLimit.XLimit = [1,ListNum];
FigSet.LabelLimit.YLimit_left = [0,10000];
FigSet.LabelLimit.YLimit_right = [0,0.15*10^-5];
FigSet.StorgePath = 'FigRes\Figure_7_The_runtime_comparison_of_different_algorithms_with_respect_to_the_number_of_campaigns.png';
end

