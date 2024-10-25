function [FigSet] = Table4_Data()
%% The proposed rigid array solution
ResMYGI = readtable('demo_timeSeq\res.MYGI.dat');
EW0 = ResMYGI.EW_m_;NS0 = ResMYGI.NS_m_;UD0 = ResMYGI.UD_m_;

%% sphere_constrain array solution
ResMYGI2 = readtable('TimeSqe_Earth_adhered\demo_timeSeq\res.MYGI.dat');
EW1 = ResMYGI2.EW_m_;NS1 = ResMYGI2.NS_m_;UD1 = ResMYGI2.UD_m_;

%% 
DataNum = length(EW1);XL = [1:DataNum]';
FigSet.Data{1,1} = [XL,EW0 * 100];
FigSet.Data{1,2} = [XL,EW1 * 100];

FigSet.Data{2,1} = [XL,NS0 * 100];
FigSet.Data{2,2} = [XL,NS1 * 100];

FigSet.Data{3,1} = [XL,UD0 *100];
FigSet.Data{3,2} = [XL,UD1 *100];

FigSet.StorgePath = 'FigRes\Table_4_Comparison_between_the_rigid-array_and_Earth-adhered rigid-array solutions.csv';
end

