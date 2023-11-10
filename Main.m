clear;clc;close all;FilePath = mfilename('fullpath');cd(fileparts(FilePath)); 
%% Single Period Observation Solving
SetINIPath = '.\Settings-prep_Free.ini';
GNSS_A_Position_Cal(SetINIPath,'.');

%% Determine Seafloor Array 
GNSS_A_Position_Fix('MYGI');

%% Seafloor Array Offset Solving
SetINIPath = '.\Settings-prep_Fix.ini';
GNSS_A_Position_Cal(SetINIPath,'.');

%% Seafloor Array Baseline Constraint Solving
SetINIPath = '.\Settings-prep_TimeSqe.ini';
GNSS_A_Position_Cal(SetINIPath,'.');
