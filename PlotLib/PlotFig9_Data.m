function [FigSet] = PlotFig9_Data()
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

EW0 = Epoch_dCentPos(:,1) - Fix_dCentPos(1);
NS0 = Epoch_dCentPos(:,2) - Fix_dCentPos(2);
UD0 = Epoch_dCentPos(:,3) - Fix_dCentPos(3);
%% GARPOS array-fixed solution
ResMYGI = readtable('GARPOS_V.1.0.0_Res/demo_res/res.MYGI.dat');
EW1 = ResMYGI.EW_m_;NS1 = ResMYGI.NS_m_;UD1 = ResMYGI.UD_m_;

%% Proposed array-free solution
prep_res_dir = dir('demo_prep/MYGI/*-res.dat');datNum = length(prep_res_dir);
Epoch_dCentPos = zeros(datNum,3);
for dirNum = 1:datNum
    ResData = ReadNSinex([prep_res_dir(dirNum).folder,'\',prep_res_dir(dirNum).name]);
    Epoch_dCentPos(dirNum,:) = ResData.Site_parameter.Array_cent.Center_ENU;
end
fix_dir = dir('cfgfix/MYGI/*-fix.ini');
FixData = ReadNSinex([fix_dir(1).folder,'\',fix_dir(1).name]);
Fix_dCentPos = FixData.Site_parameter.Array_cent.Center_ENU;

EW2 = Epoch_dCentPos(:,1) - Fix_dCentPos(1);
NS2 = Epoch_dCentPos(:,2) - Fix_dCentPos(2);
UD2 = Epoch_dCentPos(:,3) - Fix_dCentPos(3);

%% tight constraint resilient array solution
ResMYGI = readtable('demo_timeSeq\res.MYGI.dat');
EW3 = ResMYGI.EW_m_;NS3 = ResMYGI.NS_m_;UD3 = ResMYGI.UD_m_;

%% Plot Data
FigSet.PlotModel = 'line';FigSet.SubplotModel = 'subplot';FigSet.SubComb  = [3,1];
DataNum = length(EW0);XL = [1:DataNum]';
FigSet.Data{1,1} = [XL,(EW1 - EW0)*100];
FigSet.Data{1,2} = [XL,(EW3 - EW2)*100];

FigSet.Data{2,1} = [XL,(NS1 - NS0) *100];
FigSet.Data{2,2} = [XL,(NS3 - NS2)*100];

FigSet.Data{3,1} = [XL,(UD1 - UD0) *100];
FigSet.Data{3,2} = [XL,(UD3 - UD2) *100];


FigSet.LineType = {'-oc','-or','-oc','-or','-oc','-or'};
FigSet.PointFull = [1,1,1,1,1,1];
FigSet.legendCol = 1;

FigSet.xlabelName = {'','','\fontname{Times new roman}{Epochs}'};
FigSet.ylabelName = {'\fontname{Times new roman}{E(cm)}','\fontname{Times new roman}{N(cm)}','\fontname{Times new roman}{U(cm)}'};
FigSet.Label.FontSize = 18;

FigSet.legendType = 'Outside_Top';
FigSet.legendName = {'\fontname{Times new roman}{GARPOS array-free solution and array-fixed solution difference}',...
    '\fontname{Times new roman}{Proposed array-free solution and tight constraint resilient array solution difference}'};
FigSet.legendPos = [0.15 0.94 0.7 0.05];

PosNameList = {'1209','1211','1212','1302','1306','1309','1311','1401',...
    '1408','1501','1504','1508','1510','1602','1605','1607','1610','1703',...
    '1704','1708','1801','1802','1808','1903','1906','1910','2002','2006'};
FigSet.Xticks.LableNum = {1:DataNum;1:DataNum;1:DataNum};
LableStr = {PosNameList{1:DataNum}};
FigSet.Xticks.LableStr = {LableStr;LableStr;LableStr};

FigSet.global.FontSize = 18;
FigSet.global.Fontname = 'Times new roman';
FigSet.global.linewidth = 1;
FigSet.Size=[0,0,20,15];
FigSet.PaperPosition=[0,0,20,10];
FigSet.StorgePath = 'FigRes\Figure_9_Difference_between_the_array-free_and_solution_constrained_array_geometry.png';

end

