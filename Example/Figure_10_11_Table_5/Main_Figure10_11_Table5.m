clc;clear;close all;FilePath  = mfilename('fullpath');cd(fileparts(FilePath)); 

%% Resilient array solution mu_0^2 = 100
SetINIPath = '.\Settings-prep_TimeSqe_100.ini';
GNSS_A_Position_Cal(SetINIPath,'TimeSqe_100');

%% Resilient array solution mu_0^2 = 0.1
SetINIPath = '.\Settings-prep_TimeSqe_0_1.ini';
GNSS_A_Position_Cal(SetINIPath,'TimeSqe_0_1');

%% Resilient array solution mu_0^2 = 0.01
SetINIPath = '.\Settings-prep_TimeSqe_0_01.ini';
GNSS_A_Position_Cal(SetINIPath,'TimeSqe_0_01');

%% Resilient array solution mu_0^2 = 0.005
SetINIPath = '.\Settings-prep_TimeSqe_0_005.ini';
GNSS_A_Position_Cal(SetINIPath,'TimeSqe_0_005');

%% OutPut Figure10 & 11
clear;clc;close all
[BaselineList0005,BaselineList001,BaselineList01,BaselineList100] = ReadData2Baseline('TimeSqe_0_005','TimeSqe_0_01','TimeSqe_0_1','TimeSqe_100');

% Fig.10 Baseline length time series of M12-M14,M12-M15,M13-M14,M14-M15
[FigSet] = Baseline_Plot_Fig10(BaselineList0005,BaselineList001,BaselineList01,BaselineList100);
[FigSet] = PlotFig_ini(FigSet);
PlotFig_res(FigSet);


% Fig.11 Baseline length time series of M12-M13,M14-M15
[FigSet] = Baseline_Plot_Fig11(BaselineList0005,BaselineList001,BaselineList01,BaselineList100);
[FigSet] = PlotFig_ini(FigSet);
PlotFig_res(FigSet);

%% Resilient array solution mu_0^2 = 1
SetINIPath = '.\Settings-prep_TimeSqe_1.ini';
GNSS_A_Position_Cal(SetINIPath,'TimeSqe_1');

%% Resilient array solution mu_0^2 = 0.5
SetINIPath = '.\Settings-prep_TimeSqe_0_5.ini';
GNSS_A_Position_Cal(SetINIPath,'TimeSqe_0_5');

%% Resilient array solution mu_0^2 = 0.05
SetINIPath = '.\Settings-prep_TimeSqe_0_05.ini';
GNSS_A_Position_Cal(SetINIPath,'TimeSqe_0_05');

%% Resilient array solution mu_0^2 = 0.001
SetINIPath = '.\Settings-prep_TimeSqe_0_001.ini';
GNSS_A_Position_Cal(SetINIPath,'TimeSqe_0_001');

%% Resilient array solution mu_0^2 = 0.0005
SetINIPath = '.\Settings-prep_TimeSqe_0_0005.ini';
GNSS_A_Position_Cal(SetINIPath,'TimeSqe_0_0005');

%% Resilient array solution mu_0^2 = 0.0001
SetINIPath = '.\Settings-prep_TimeSqe_0_0001.ini';
GNSS_A_Position_Cal(SetINIPath,'TimeSqe_0_0001');

%% Resilient array solution mu_0^2 = 0.00005
SetINIPath = '.\Settings-prep_TimeSqe_0_00005.ini';
GNSS_A_Position_Cal(SetINIPath,'TimeSqe_0_00005');

%% OutPut Table 5
clear;clc;close all
[FigSet] = Table5_Data('TimeSqe_0_00005','TimeSqe_0_0001','TimeSqe_0_0005','TimeSqe_0_001','TimeSqe_0_005','TimeSqe_0_01','TimeSqe_0_05','TimeSqe_0_1','TimeSqe_0_5','TimeSqe_1','TimeSqe_100');
ObsPath = 'obsdata\MYGI';
ConPath = 'initcfg\MYGI';
cEnu = [FigSet.Data{1,1}(:,2) FigSet.Data{2,1}(:,2) FigSet.Data{3,1}(:,2)];
dEnu = [FigSet.Data{1,2}(:,2) FigSet.Data{2,2}(:,2) FigSet.Data{3,2}(:,2)];
eEnu = [FigSet.Data{1,3}(:,2) FigSet.Data{2,3}(:,2) FigSet.Data{3,3}(:,2)];
fEnu = [FigSet.Data{1,4}(:,2) FigSet.Data{2,4}(:,2) FigSet.Data{3,4}(:,2)];
gEnu = [FigSet.Data{1,5}(:,2) FigSet.Data{2,5}(:,2) FigSet.Data{3,5}(:,2)];
hEnu = [FigSet.Data{1,6}(:,2) FigSet.Data{2,6}(:,2) FigSet.Data{3,6}(:,2)];
iEnu = [FigSet.Data{1,7}(:,2) FigSet.Data{2,7}(:,2) FigSet.Data{3,7}(:,2)];
jEnu = [FigSet.Data{1,8}(:,2) FigSet.Data{2,8}(:,2) FigSet.Data{3,8}(:,2)];
kEnu = [FigSet.Data{1,9}(:,2) FigSet.Data{2,9}(:,2) FigSet.Data{3,9}(:,2)];
lEnu = [FigSet.Data{1,10}(:,2) FigSet.Data{2,10}(:,2) FigSet.Data{3,10}(:,2)];
mEnu = [FigSet.Data{1,11}(:,2) FigSet.Data{2,11}(:,2) FigSet.Data{3,11}(:,2)];
[V(1,:),Sig(1,:)] = TimeSeriesAnalysis(cEnu,ObsPath,ConPath);
[V(2,:),Sig(2,:)] = TimeSeriesAnalysis(dEnu,ObsPath,ConPath);
[V(3,:),Sig(3,:)] = TimeSeriesAnalysis(eEnu,ObsPath,ConPath);
[V(4,:),Sig(4,:)] = TimeSeriesAnalysis(fEnu,ObsPath,ConPath);
[V(5,:),Sig(5,:)] = TimeSeriesAnalysis(gEnu,ObsPath,ConPath);
[V(6,:),Sig(6,:)] = TimeSeriesAnalysis(hEnu,ObsPath,ConPath);
[V(7,:),Sig(7,:)] = TimeSeriesAnalysis(iEnu,ObsPath,ConPath);
[V(8,:),Sig(8,:)] = TimeSeriesAnalysis(jEnu,ObsPath,ConPath);
[V(9,:),Sig(9,:)] = TimeSeriesAnalysis(kEnu,ObsPath,ConPath);
[V(10,:),Sig(10,:)] = TimeSeriesAnalysis(lEnu,ObsPath,ConPath);
[V(11,:),Sig(11,:)] = TimeSeriesAnalysis(mEnu,ObsPath,ConPath);
OutTable5(V,Sig,FigSet.StorgePath);

%% 
clc;clear;close all
[FigSet] = Curver();
[FigSet] = PlotFig_ini(FigSet);
PlotFig_res(FigSet);
figure(1)

[FigSet] = Curver2();
[FigSet] = PlotFig_ini(FigSet);
PlotFig_res(FigSet);
figure(2)




