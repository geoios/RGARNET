function [FigSet] = PlotFig4_Data()
%% Free-array solution
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


%% Two-step rigid-array solution
ResMYGI = readtable('demo_res\res.MYGI.dat');
EW1 = ResMYGI.EW_m_;NS1 = ResMYGI.NS_m_;UD1 = ResMYGI.UD_m_;

%% Strict rigid-array solution
ResMYGI = readtable('demo_timeSeq\res.MYGI.dat');
EW2 = ResMYGI.EW_m_;NS2 = ResMYGI.NS_m_;UD2 = ResMYGI.UD_m_;


%% Plot
FigSet.PlotModel = 'line';FigSet.SubplotModel = 'subplot';FigSet.SubComb  = [3,1];

DataNum = length(EW0);XL = [1:DataNum]';
FigSet.Data{1,1} = [XL,EW0 * 100];
FigSet.Data{1,2} = [XL,EW1 * 100];
FigSet.Data{1,3} = [XL,EW2 * 100];

FigSet.Data{2,1} = [XL,NS0 * 100];
FigSet.Data{2,2} = [XL,NS1 * 100];
FigSet.Data{2,3} = [XL,NS2 * 100];

FigSet.Data{3,1} = [XL,UD0 *100];
FigSet.Data{3,2} = [XL,UD1 *100];
FigSet.Data{3,3} = [XL,UD2 *100];


FigSet.LineType = {'sg','^m','ob','sg','^m','ob','sg','^m','ob'};
FigSet.Line1Type = {'-g','-m','-b','-g','-m','-b','-g','-m','-b'};
FigSet.PointFull = [0,1,0,0,1,0,0,1,0];
% FigSet.PointSize = [4,8,4,8,4,8];
FigSet.PointSize = [10,7,10,10,7,10,10,7,10];
% axis
FigSet.title = {' ','',''};
FigSet.xlabelName = {'','','\fontname{Times new roman}{Year/Month/Day}'};  % Epochs
FigSet.ylabelName = {'\fontname{Times new roman}{E(cm)}','\fontname{Times new roman}{N(cm)}','\fontname{Times new roman}{U(cm)}'};
FigSet.Label.FontSize = 15;


FigSet.legendType = 'Outside_Top';
FigSet.legendName = {'\fontname{Times new roman}{Free-array solution}','\fontname{Times new roman}{Trend of free-array solution series}',...
                    '\fontname{Times new roman}{Two-step rigid-array solution}','\fontname{Times new roman}{Trend of two-step rigid-array solution series}',...
                    '\fontname{Times new roman}{Strict rigid-array solution}','\fontname{Times new roman}{Trend of strict rigid-array solution series}'};
FigSet.legendPos = [0.17 0.94 0.7 0.05];
FigSet.legendCol = 2;

PosNameList = {'1209','1211','1212','1302','1306','1309','1311','1401',...
    '1408','1501','1504','1508','1510','1602','1605','1607','1610','1703',...
    '1704','1708','1801','1802','1808','1903','1906','1910','2002','2006'}; 
FigSet.Xticks.LableNum = {1:DataNum;1:DataNum;1:DataNum};
LableStr = {PosNameList{1:DataNum}};
FigSet.Xticks.LableStr = {LableStr;LableStr;LableStr};
FigSet.FontSize = 12;
FigSet.global.FontSize = 15;
FigSet.global.Fontname = 'Times new roman';
FigSet.global.linewidth = 1;
FigSet.Size=[0,0,25,20];
FigSet.PaperPosition=[0,0,20,10];
FigSet.StorgePath = 'FigRes\Figure_5_Results_of_the_two-step_rigid-array_solution_strict_rigid-array_solution_and_free-array_solution.png';

end

