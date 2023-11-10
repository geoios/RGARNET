function [FigSet] = SSFGrad_Plotini_677(OBSData,SavePath)
%% 
Index = find(OBSData.ST(2:end)-OBSData.ST(1:end-1)>3600);
X = (OBSData.ST + OBSData.RT)/2;
if isempty(Index)
    FigSet.Data{1,1} = [X, OBSData.GradT];
    FigSet.Data{2,1} = [X, OBSData.GradVe];
    FigSet.Data{2,2} = [X, OBSData.GradVn];
    FigSet.Data{3,1} = [X, OBSData.GradRe];
    FigSet.Data{3,2} = [X, OBSData.GradRn];
else
    [X_tmp,GradT_tmp,GradVe_tmp,GradVn_tmp,GradRe_tmp,GradRn_tmp ] = deal(Inf(length(X) + length(Index),1));
    Index_tmp = [0;Index;length(X)];
    for IndexNum = 1:length(Index)+1
        X_tmp(Index_tmp(IndexNum)+IndexNum:Index_tmp(IndexNum+1)+IndexNum-1) = X(Index_tmp(IndexNum)+1:Index_tmp(IndexNum+1));
        GradT_tmp(Index_tmp(IndexNum)+IndexNum:Index_tmp(IndexNum+1)+IndexNum-1) = OBSData.GradT(Index_tmp(IndexNum)+1:Index_tmp(IndexNum+1));
        GradVe_tmp(Index_tmp(IndexNum)+IndexNum:Index_tmp(IndexNum+1)+IndexNum-1) = OBSData.GradVe(Index_tmp(IndexNum)+1:Index_tmp(IndexNum+1));
        GradVn_tmp(Index_tmp(IndexNum)+IndexNum:Index_tmp(IndexNum+1)+IndexNum-1) = OBSData.GradVn(Index_tmp(IndexNum)+1:Index_tmp(IndexNum+1));
        GradRe_tmp(Index_tmp(IndexNum)+IndexNum:Index_tmp(IndexNum+1)+IndexNum-1) = OBSData.GradRe(Index_tmp(IndexNum)+1:Index_tmp(IndexNum+1));
        GradRn_tmp(Index_tmp(IndexNum)+IndexNum:Index_tmp(IndexNum+1)+IndexNum-1) = OBSData.GradRn(Index_tmp(IndexNum)+1:Index_tmp(IndexNum+1));
    end
    FigSet.Data{1,1} = [X_tmp, GradT_tmp];
    FigSet.Data{2,1} = [X_tmp, GradVe_tmp];
    FigSet.Data{2,2} = [X_tmp, GradVn_tmp];
    FigSet.Data{3,1} = [X_tmp, GradRe_tmp];
    FigSet.Data{3,2} = [X_tmp, GradRn_tmp];
end
FigSet.PlotModel = 'line';FigSet.SubplotModel= 'subplot';FigSet.SubComb = [3,1];
% 点型
FigSet.LineType = {'-g','-r','-b','-.r','-.b'};
% 坐标轴
FigSet.Label.FontSize = 12;
FigSet.legendName = {'\fontname{Times new roman}T','';'\fontname{Times new roman}E','\fontname{Times new roman}N';'\fontname{Times new roman}E','\fontname{Times new roman}N'};
FigSet.xlabelName = {'','','观测历元'};
FigSet.ylabelName = { '\fontname{Times new roman}{GradT(m/s)}', '\fontname{Times new roman}{ZR(s)}','\fontname{Times new roman}{ZV(s)}'};

FigSet.Size=[0,0,20,15];                                % Specify the size of the figure
FigSet.PaperPosition=[0,0,20,10];                       % Specify the size of the figure

FigSet.Frame = 'grid';
FigSet.StorgePath = SavePath;




end

