clc;clear;close all;FilePath  = mfilename('fullpath');cd(fileparts(FilePath)); 

%% Resilient array solution miu0 = 10
SetINIPath = '.\Settings-prep_TimeSqe_10.ini';
GNSS_A_Position_Cal(SetINIPath,'TimeSqe_10');

%% Resilient array solution miu0 = 0.01
SetINIPath = '.\Settings-prep_TimeSqe_0_01.ini';
GNSS_A_Position_Cal(SetINIPath,'TimeSqe_0_01');

%% Resilient array solution miu0 = 0.005
SetINIPath = '.\Settings-prep_TimeSqe_0_005.ini';
GNSS_A_Position_Cal(SetINIPath,'TimeSqe_0_005');

%% OutPut
[BaselineList0005,BaselineList001,BaselineList10] = ReadData2Baseline('TimeSqe_10','TimeSqe_0_01','TimeSqe_0_005');

% Fig.10 Baseline length time series of M12-M14,M12-M15,M13-M14,M14-M15
[FigSet] = Baseline_Plot_Fig10(BaselineList0005,BaselineList001,BaselineList10);
[FigSet] = PlotFig_ini(FigSet);
PlotFig_res(FigSet);


% Fig.11 Baseline length time series of M12-M13,M14-M15
[FigSet] = Baseline_Plot_Fig11(BaselineList0005,BaselineList001,BaselineList10);
[FigSet] = PlotFig_ini(FigSet);
PlotFig_res(FigSet);

