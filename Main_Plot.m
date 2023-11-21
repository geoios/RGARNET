clear;clc;close all;FilePath = mfilename('fullpath');cd(fileparts(FilePath)); 
%% Fig.4 Array-fixed solution and rigid array solution
clear;clc;close all
[FigSet] = PlotFig4_Data();
[FigSet] = PlotFig_ini(FigSet);
PlotFig_res(FigSet);

%% Fig.5 Difference between Array-fixed solution and rigid array solution
clear;clc;close all
[FigSet] = PlotFig5_Data();
E_resi = FigSet.Data{1,1}(:,2);
N_resi = FigSet.Data{2,1}(:,2);
U_resi = FigSet.Data{3,1}(:,2);
subplot(1,3,1);
plotHist(E_resi);
xlabel('\fontname{Times new roman}{E(cm)}');
subplot(1,3,2);
plotHist(N_resi);
xlabel('\fontname{Times new roman}{N(cm)}');ylabel('');
subplot(1,3,3);
plotHist(U_resi);
xlabel('\fontname{Times new roman}{U(cm)}');ylabel('');
set(gcf,'Units','centimeter','Position',[5 5 25 10])
print(gcf,'-dpng','-r600',FigSet.StorgePath);

%% Fig.6 Array-free solution compared with the array-fixed solution
clear;clc;close all
[FigSet] = PlotFig6_Data();
[FigSet] = PlotFig_ini(FigSet);
PlotFig_res(FigSet);

%% Table.3 Displacement time series analysis results of the proposed models
clear;clc;close all
[FigSet] = Table3_Data();
ObsPath = 'obsdata\MYGI';
ConPath = 'initcfg\MYGI';
aEnu = [FigSet.Data{1,1}(:,2) FigSet.Data{2,1}(:,2) FigSet.Data{3,1}(:,2)];
bEnu = [FigSet.Data{1,2}(:,2) FigSet.Data{2,2}(:,2) FigSet.Data{3,2}(:,2)];
[V(1,:),Sig(1,:)] = TimeSeriesAnalysis(aEnu,ObsPath,ConPath);
[V(2,:),Sig(2,:)] = TimeSeriesAnalysis(bEnu,ObsPath,ConPath);
OutTable3(V,Sig,FigSet.StorgePath );
%% Figure.7  Runtime increasing with the remeasurement period number N（Comparison of additional examples）
clear;clc;close all
SetINIPath = 'PlotLib\Settings-prep_TimeCompare.ini';
GNSS_A_Position_Time(SetINIPath)

%% 
clear;clc;close all