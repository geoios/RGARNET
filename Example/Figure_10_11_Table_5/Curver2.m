function [FigSet] = Curver2()

X = [0.00005;0.0001;0.0005;0.001;0.005;0.01;0.05;0.1;0.5;1;100];
Y = [6.3686;6.0829;5.7838;5.7068;5.6550;5.6306;5.6272;5.6245;5.6241;5.6252;5.6238];

FigSet.Data{1,1} = [log10(Y), log10(sqrt(X))];

FigSet.PlotModel = 'line';
FigSet.SubplotModel= 'solo';
FigSet.LineType = {'-or'};
FigSet.PointFull = [1];
FigSet.xlabelName ={'\fontname{Times new roman}{lg(Root Sum Squares)}'} ;
FigSet.ylabelName = {'\fontname{Times new roman}{lg(\mu_0)}'};



FigSet.Label.FontSize = 15;
FigSet.Size=[0,0,20,15];
FigSet.PaperPosition=[0,0,20,10];

FigSet.global.FontSize = 15;
FigSet.global.Fontname = 'Times new roman';
FigSet.global.linewidth = 1;



end

