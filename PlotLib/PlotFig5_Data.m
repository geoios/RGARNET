function [FigSet] = PlotFig5_Data()
%% Array-fixed_solution
ResMYGI = readtable('demo_res\res.MYGI.dat');
EW0 = ResMYGI.EW_m_;NS0 = ResMYGI.NS_m_;UD0 = ResMYGI.UD_m_;

%% tigid_array_solution
ResMYGI = readtable('demo_timeSeq\res.MYGI.dat');
EW1 = ResMYGI.EW_m_;NS1 = ResMYGI.NS_m_;UD1 = ResMYGI.UD_m_;


%% Plot
DataNum = length(EW0);XL = [1:DataNum]';
FigSet.Data{1,1} = [XL,(EW0- EW1) *100];

FigSet.Data{2,1} = [XL,(NS0- NS1)*100];

FigSet.Data{3,1} = [XL,(UD0- UD1) *100];

FigSet.StorgePath = 'FigRes\Figure_5_Difference_between_Array-fixed_solution_and_tigid_array_solution.png';

end

