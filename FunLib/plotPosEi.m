function [FigSet] = plotPosEi(filname)
load(filname);
Ei = readtable('a.csv');
E = Ei.Var2(2:end);
MTList = {'M12','M13';'M14','M15'};[m,n]=size(MTList);
for MTRowLine = 1:m
    for MTRowNum = 1:n
        Index = find(strcmp(OBSData.flag,'False') & strcmp(OBSData.MT,MTList{MTRowLine,MTRowNum}) ==1);
        X = OBSData.ant_e0(Index);Y = OBSData.ant_n0(Index);Z = E(Index);
        FigSet.Data{MTRowLine,MTRowNum} = [X,Y,Z];
    end
end
%% 
FigSet.PlotModel = 'pointcolorbar';FigSet.SubplotModel = 'tiledlayout';FigSet.SubComb = [2,2];
FigSet.title ={'\fontname{Times new roman}{\itM12}','\fontname{Times new roman}{\itM13}';...
    '\fontname{Times new roman}{\itM14}','\fontname{Times new roman}{\itM15}'};
FigSet.xlabelName = {'','';'\fontname{Times new roman}{\itE(m)}','\fontname{Times new roman}{\itE(m)}'};
FigSet.ylabelName = {'\fontname{Times new roman}{\itN(m)}','';'\fontname{Times new roman}{\itN(m)}',''};
FigSet.Label.FontSize = 15;FigSet.Label.FontName = 'Times new roman';
FigSet.Colorbar.Colormap = 'jet';
FigSet.Layout.Tile = 'east';
FigSet.Colorbar.Lable.String = '\fontname{宋体}{权}';


FigSet.Size=[0,0,20,15];                                % 指定figure的尺寸
FigSet.PaperPosition=[0,0,20,10];                       % 设定图窗大小和位置



end

