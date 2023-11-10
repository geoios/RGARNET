function [FigSet] = SSFGrad_Plotini_1(OBSData,SavePath)

%% 
X = (OBSData.ST + OBSData.RT)/2;
FigSet.Data{1,1} = [X, OBSData.dV0];
FigSet.Data{2,1} = [X, OBSData.gradV1e];
FigSet.Data{2,2} = [X, OBSData.gradV1n];
FigSet.Data{3,1} = [X, OBSData.gradV2e];
FigSet.Data{3,2} = [X, OBSData.gradV2n];

FigSet.PlotModel = 'line';FigSet.SubplotModel= 'subplot';FigSet.SubComb = [3,1];
FigSet.LineType = {'-g','-r','-b','-.r','-.b'};
FigSet.Label.FontSize = 12;
FigSet.legendName = {'\fontname{Times new roman}T','';'\fontname{Times new roman}E','\fontname{Times new roman}N';'\fontname{Times new roman}E','\fontname{Times new roman}N'};
FigSet.xlabelName = {'','','Epoch'};
FigSet.ylabelName = { '\fontname{Times new roman}{dV0(m/s)}', '\fontname{Times new roman}{g1(m/s/km)}','\fontname{Times new roman}{g2(m/s/km)}'};

FigSet.Size=[0,0,20,15];    
FigSet.PaperPosition=[0,0,20,10];  

FigSet.Frame = 'grid';
FigSet.StorgePath = SavePath;




end

