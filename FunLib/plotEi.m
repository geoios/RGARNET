function [FigSet] = plotEi(filename)
load(filename)

Ei = readtable('a.csv');
E = Ei.Var2(2:end);
for MTNum = 1:4
    index = find(OBSData.MTPSign == (MTNum-1)*3+1);
    FigSet.Data{MTNum,1} = [index,E(index)];
end
FigSet.PlotModel = 'point';FigSet.SubplotModel = 'subplot';FigSet.SubComb = [4,1];

%% 
FigSet.xlabelName = {'','','','\fontname{宋体}{观测历元}'};
FigSet.ylabelName = {'\fontname{宋体}{权}','\fontname{宋体}{权}','\fontname{宋体}{权}','\fontname{宋体}{权}'};
FigSet.Label.FontSize = 15;FigSet.Label.FontName = 'Times new roman';
FigSet.legendName = {'M12';'M13';'M14';'M15'};
end

