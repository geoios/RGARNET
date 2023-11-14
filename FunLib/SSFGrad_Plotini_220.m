function [FigSet] = SSFGrad_Plotini_220(OBSData,SavePath)
%% 
Index = find(OBSData.ST(2:end)-OBSData.ST(1:end-1)>3600);
X = (OBSData.ST + OBSData.RT)/2;
if isempty(Index)
    FigSet.Data{1,1} = [X, OBSData.GradT];
    FigSet.Data{2,1} = [X, OBSData.GradVe];
    FigSet.Data{2,2} = [X, OBSData.GradVn];
else
    [X_tmp,GradT_tmp,GradRe_tmp,GradRn_tmp] = deal(Inf(length(X) + length(Index),1));
    Index_tmp = [0;Index;length(X)];
    for IndexNum = 1:length(Index)+1
        X_tmp(Index_tmp(IndexNum)+IndexNum:Index_tmp(IndexNum+1)+IndexNum-1) = X(Index_tmp(IndexNum)+1:Index_tmp(IndexNum+1));
        GradT_tmp(Index_tmp(IndexNum)+IndexNum:Index_tmp(IndexNum+1)+IndexNum-1) = OBSData.GradT(Index_tmp(IndexNum)+1:Index_tmp(IndexNum+1));
        GradRe_tmp(Index_tmp(IndexNum)+IndexNum:Index_tmp(IndexNum+1)+IndexNum-1) = OBSData.GradRe(Index_tmp(IndexNum)+1:Index_tmp(IndexNum+1));
        GradRn_tmp(Index_tmp(IndexNum)+IndexNum:Index_tmp(IndexNum+1)+IndexNum-1) = OBSData.GradRn(Index_tmp(IndexNum)+1:Index_tmp(IndexNum+1));
    end
    FigSet.Data{1,1} = [X_tmp, GradT_tmp];
    FigSet.Data{2,1} = [X_tmp, GradRe_tmp];
    FigSet.Data{2,2} = [X_tmp, GradRn_tmp];
end
FigSet.PlotModel = 'line';FigSet.SubplotModel= 'subplot';FigSet.SubComb = [2,1];
% Point type
FigSet.LineType = {'-g','-r','-b'};
% Axis
FigSet.Label.FontSize = 12;
FigSet.legendName = {'\fontname{Times new roman}T','';'\fontname{Times new roman}E','\fontname{Times new roman}N'};
FigSet.xlabelName = {'','','Cumulative Second(s)'};
FigSet.ylabelName = { '\fontname{Times new roman}{k_t(m/s)}', '\fontname{Times new roman}{k_e_n(m/s/km)}'};

FigSet.Size=[0,0,20,15];                                %Specify the size of the figure
FigSet.PaperPosition=[0,0,20,10];                       %Specify the size of the figure

FigSet.Frame = 'grid';
FigSet.StorgePath = SavePath;

end

