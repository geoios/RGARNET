function [FigSet] = Table4_Data()


%% The proposed array-free solution
prep_res_dir = dir('demo_prep/MYGI/*-res.dat');datNum = length(prep_res_dir);
Epoch_dCentPos = zeros(datNum,3);
for dirNum = 1:datNum
    ResData = ReadNSinex([prep_res_dir(dirNum).folder,'\',prep_res_dir(dirNum).name]);
    Epoch_dCentPos(dirNum,:) = ResData.Site_parameter.Array_cent.Center_ENU;
end
fix_dir = dir('cfgfix/MYGI/*-fix.ini');
FixData = ReadNSinex([fix_dir(1).folder,'\',fix_dir(1).name]);
Fix_dCentPos = FixData.Site_parameter.Array_cent.Center_ENU;

EW0 = Epoch_dCentPos(:,1) - Fix_dCentPos(1);
NS0 = Epoch_dCentPos(:,2) - Fix_dCentPos(2);
UD0 = Epoch_dCentPos(:,3) - Fix_dCentPos(3);

%% GARPOS array-free solution
prep_res_dir = dir('GARPOS_V.1.0.0_Res/demo_prep/MYGI/*-res.dat');datNum = length(prep_res_dir);
Epoch_dCentPos = zeros(datNum,3);
for dirNum = 1:datNum
    ResData = ReadNSinex([prep_res_dir(dirNum).folder,'\',prep_res_dir(dirNum).name]);
    Epoch_dCentPos(dirNum,:) = ResData.Site_parameter.Array_cent.Center_ENU;
end
fix_dir = dir('GARPOS_V.1.0.0_Res/cfgfix/MYGI/*-fix.ini');
FixData = ReadNSinex([fix_dir(1).folder,'\',fix_dir(1).name]);
Fix_dCentPos = FixData.Site_parameter.Array_cent.Center_ENU;

EW1 = Epoch_dCentPos(:,1) - Fix_dCentPos(1);
NS1 = Epoch_dCentPos(:,2) - Fix_dCentPos(2);
UD1 = Epoch_dCentPos(:,3) - Fix_dCentPos(3);

%% The proposed rigid array solution
ResMYGI = readtable('demo_timeSeq\res.MYGI.dat');
EW2 = ResMYGI.EW_m_;NS2 = ResMYGI.NS_m_;UD2 = ResMYGI.UD_m_;

%% GARPOS array-fixed slotio
ResMYGI = readtable('GARPOS_V.1.0.0_Res/demo_res/res.MYGI.dat');
EW3 = ResMYGI.EW_m_;NS3 = ResMYGI.NS_m_;UD3 = ResMYGI.UD_m_;



%% Plot
FigSet.PlotModel = 'line';FigSet.SubplotModel = 'subplot';FigSet.SubComb  = [3,1];
DataNum = length(EW0);XL = [1:DataNum]';

FigSet.Data{1,1} = [XL,EW0*100];FigSet.Data{1,2} = [XL,EW1*100];
FigSet.Data{1,3} = [XL,EW2*100];FigSet.Data{1,4} = [XL,EW3*100];

FigSet.Data{2,1} = [XL,NS0*100];FigSet.Data{2,2} = [XL,NS1*100];
FigSet.Data{2,3} = [XL,NS2*100];FigSet.Data{2,4} = [XL,NS3*100];

FigSet.Data{3,1} = [XL,UD0*100];FigSet.Data{3,2} = [XL,UD1*100];
FigSet.Data{3,3} = [XL,UD2*100];FigSet.Data{3,4} = [XL,UD3*100];

FigSet.StorgePath = 'FigRes\Table_4_Displacement_time_series_analysis_results.csv';
end

