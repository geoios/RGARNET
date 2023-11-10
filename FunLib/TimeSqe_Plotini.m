function [FigSet] = TimeSqe_Plotini(TimeSqeMp,PosNameList,SavePath)
[m,n] = size(TimeSqeMp);
%% draw data
FigSet.PlotModel = 'line';FigSet.SubplotModel = 'subplot';FigSet.SubComb  = [3,1];
XL = [1:m]';
FigSet.Data{1,1} = [XL,TimeSqeMp(:,1) *100];

FigSet.Data{2,1} = [XL,TimeSqeMp(:,2) *100];

FigSet.Data{3,1} = [XL,TimeSqeMp(:,3) *100];

FigSet.LineType = {'-ob','-or','-og'};

FigSet.xlabelName = {'','','\fontname{Times new roman}{Epochs}'};
FigSet.ylabelName = {'\fontname{Times new roman}{E(cm)}',...
    '\fontname{Times new roman}{N(cm)}',...
    '\fontname{Times new roman}{U(cm)}'};
FigSet.Label.FontSize = 18;

FigSet.Xticks.LableNum = {XL;XL;XL};
LableStr = {PosNameList{XL}};
FigSet.Xticks.LableStr = {LableStr;LableStr;LableStr};

FigSet.global.FontSize = 18;
FigSet.global.Fontname = 'Times new roman';
FigSet.global.linewidth = 1;
FigSet.Size=[0,0,20,15];                              
FigSet.PaperPosition=[0,0,20,10];                    
FigSet.StorgePath = SavePath;

end

