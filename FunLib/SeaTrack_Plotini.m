function [FigSet] = SeaTrack_Plotini(OBSData,FloorEN,SavePath)


SurEN = [OBSData.transducer_e0,OBSData.transducer_n0];
FigSet.Data{1} = SurEN;
FigSet.Data{2} = FloorEN;
%% Draw data
FigSet.PlotModel = 'point';FigSet.SubplotModel = 'solo';FigSet.SubComb  = [1,1];

FigSet.PointType = {'.b','sr'};
FigSet.xlabelName = '\fontname{Times new roman}E(m)';
FigSet.ylabelName = '\fontname{Times new roman}N(m)';
FigSet.Label.FontSize = 18;
FigSet.legendName = {'\fontname{Times new roman}Surface Point','\fontname{Times new roman}Seafloor Point'};
FigSet.global.Fontname = 'Times new roman';FigSet.global.FontSize = 18;
FigSet.global.linewidth = 1;
FigSet.StorgePath = SavePath;

end

