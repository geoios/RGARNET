function [FigSet] = dT_Plotini(OBSData,SavePath)

index = find(strcmp(OBSData.flag,'True'));
dT = [(OBSData.ST + OBSData.RT)/2,OBSData.ResiTT];
dT(index,:) = [];
FigSet.Data{1} = dT;
%% Draw data
FigSet.PlotModel = 'point';FigSet.SubplotModel = 'solo';FigSet.SubComb  = [1,1];

FigSet.PointType = {'.b'};
FigSet.xlabelName = '\fontname{Times new roman}Time(s)';
FigSet.ylabelName = '\fontname{Times new roman}ResiTT(s)';
FigSet.Label.FontSize = 18;
FigSet.global.Fontname = 'Times new roman';FigSet.global.FontSize = 18;
FigSet.global.linewidth = 1;
FigSet.StorgePath = SavePath;

end

