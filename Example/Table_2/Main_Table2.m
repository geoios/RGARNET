clc;clear;close all;FilePath  = mfilename('fullpath');cd(fileparts(FilePath)); 
%% Free-array solution
SetINIPath = '.\Settings-prep_Free.ini';
GNSS_A_Position_Cal(SetINIPath,'.');

%% Fix
GNSS_A_Position_Fix('MYGI');

%%  Loose-constrained solutions \mu_0^2 = 1e4 ~ 1e-8
SetINIPath = '.\Settings-prep_TimeSqe_Loose_constrained.ini';
Mu = [1e4,1e3,1e2,1e1,1,1e-1,1e-2,1e-3,1e-4,1e-5,1e-6,1e-7,1e-8];%
GNSS_A_Position_Cal_Tab2(SetINIPath,Mu);

%% Rigid array solution \mu^2_0 = 10^4
SetINIPath = '.\Settings-prep_TimeSqe_Rigid.ini';
GNSS_A_Position_Cal(SetINIPath,'TimeSqe_Rigid');

%% OutPut 
GetCentrePos('Tab2_Free-array_strict_rigid-array_loose-constrained_and_tight-constrained_array_solutions.csv');
