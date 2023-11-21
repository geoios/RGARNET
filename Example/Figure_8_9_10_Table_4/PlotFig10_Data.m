function [FigSet] = PlotFig10_Data(X,Y)

FigSet.Data{1,1} = [log10(sqrt(X)), log10(Y)];

FigSet.PlotModel = 'line';
FigSet.SubplotModel= 'solo';
FigSet.LineType = {'-or'};
FigSet.PointFull = [1];
FigSet.xlabelName ={'\fontname{Times new roman}{lg(\mu_0)}'} ;
FigSet.ylabelName = {'\fontname{Times new roman}{lg(Root Sum Squares)}'};



FigSet.Label.FontSize = 15;
FigSet.Size=[0,0,20,15];
FigSet.PaperPosition=[0,0,20,10];

FigSet.global.FontSize = 15;
FigSet.global.Fontname = 'Times new roman';
FigSet.global.linewidth = 1;

FigSet.StorgePath = 'Figure_10_Logarithm_curve_of_root_sum_squares_of_the_residual_STDs_about_lg(u0).png';

end

