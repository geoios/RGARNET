clc;clear;close all;FilePath  = mfilename('fullpath');cd(fileparts(FilePath)); 
%% Array-free solution
SetINIPath = '.\Settings-prep_Free.ini';
GNSS_A_Position_Cal(SetINIPath,'.');

%% Fix
GNSS_A_Position_Fix('MYGI');

%% Array-fixed solution
SetINIPath = '.\Settings-prep_Fix.ini';
GNSS_A_Position_Cal(SetINIPath,'.');


%% Rigid array solution
SetINIPath = '.\Settings-prep_TimeSqe_Rigid.ini';
GNSS_A_Position_Cal(SetINIPath,'TimeSqe_Rigid');


%% Resilient array solution miu0 = 100
SetINIPath = '.\Settings-prep_TimeSqe_Rilient.ini';
GNSS_A_Position_Cal(SetINIPath,'TimeSqe_Rilient');


%% OutPut 
GetCentrePos('Table2_Array_fixed_solution_rigid_array_solution_and_resilient_array_solution.csv');