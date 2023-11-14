function [FigSet] = Table5_Data(ResPath1,ResPath2,ResPath3,ResPath4,ResPath5,ResPath6,ResPath7,ResPath8,ResPath9,ResPath10,ResPath11)
%% 
ResMYGI = readtable([ResPath1,'\demo_timeSeq\res.MYGI.dat']);
EW1 = ResMYGI.EW_m_; NS1 = ResMYGI.NS_m_; UD1 = ResMYGI.UD_m_;

%% 
ResMYGI = readtable([ResPath2,'\demo_timeSeq\res.MYGI.dat']);
EW2 = ResMYGI.EW_m_; NS2 = ResMYGI.NS_m_; UD2 = ResMYGI.UD_m_;

%% 
ResMYGI = readtable([ResPath3,'\demo_timeSeq\res.MYGI.dat']);
EW3 = ResMYGI.EW_m_; NS3 = ResMYGI.NS_m_; UD3 = ResMYGI.UD_m_;

%% 
ResMYGI = readtable([ResPath4,'\demo_timeSeq\res.MYGI.dat']);
EW4 = ResMYGI.EW_m_; NS4 = ResMYGI.NS_m_; UD4 = ResMYGI.UD_m_;

%% 
ResMYGI = readtable([ResPath5,'\demo_timeSeq\res.MYGI.dat']);
EW5 = ResMYGI.EW_m_; NS5 = ResMYGI.NS_m_; UD5 = ResMYGI.UD_m_;

%% 
ResMYGI = readtable([ResPath6,'\demo_timeSeq\res.MYGI.dat']);
EW6 = ResMYGI.EW_m_; NS6 = ResMYGI.NS_m_; UD6 = ResMYGI.UD_m_;

%% 
ResMYGI = readtable([ResPath7,'\demo_timeSeq\res.MYGI.dat']);
EW7 = ResMYGI.EW_m_; NS7 = ResMYGI.NS_m_; UD7 = ResMYGI.UD_m_;

%% 
ResMYGI = readtable([ResPath8,'\demo_timeSeq\res.MYGI.dat']);
EW8 = ResMYGI.EW_m_; NS8 = ResMYGI.NS_m_; UD8 = ResMYGI.UD_m_;

%% 
ResMYGI = readtable([ResPath9,'\demo_timeSeq\res.MYGI.dat']);
EW9 = ResMYGI.EW_m_; NS9 = ResMYGI.NS_m_; UD9 = ResMYGI.UD_m_;

%% 
ResMYGI = readtable([ResPath10,'\demo_timeSeq\res.MYGI.dat']);
EW10 = ResMYGI.EW_m_; NS10 = ResMYGI.NS_m_; UD10 = ResMYGI.UD_m_;

%% 
ResMYGI = readtable([ResPath11,'\demo_timeSeq\res.MYGI.dat']);
EW11 = ResMYGI.EW_m_; NS11 = ResMYGI.NS_m_; UD11 = ResMYGI.UD_m_;

%% 
DataNum = length(EW1);XL = [1:DataNum]';
FigSet.Data{1,1} = [XL,EW1 * 100];
FigSet.Data{1,2} = [XL,EW2 * 100];
FigSet.Data{1,3} = [XL,EW3 * 100];
FigSet.Data{1,4} = [XL,EW4 * 100];
FigSet.Data{1,5} = [XL,EW5 * 100];
FigSet.Data{1,6} = [XL,EW6 * 100];
FigSet.Data{1,7} = [XL,EW7 * 100];
FigSet.Data{1,8} = [XL,EW8 * 100];
FigSet.Data{1,9} = [XL,EW9 * 100];
FigSet.Data{1,10} = [XL,EW10 * 100];
FigSet.Data{1,11} = [XL,EW11 * 100];

FigSet.Data{2,1} = [XL,NS1 * 100];
FigSet.Data{2,2} = [XL,NS2 * 100];
FigSet.Data{2,3} = [XL,NS3 * 100];
FigSet.Data{2,4} = [XL,NS4 * 100];
FigSet.Data{2,5} = [XL,NS5 * 100];
FigSet.Data{2,6} = [XL,NS6 * 100];
FigSet.Data{2,7} = [XL,NS7 * 100];
FigSet.Data{2,8} = [XL,NS8 * 100];
FigSet.Data{2,9} = [XL,NS9 * 100];
FigSet.Data{2,10} = [XL,NS10 * 100];
FigSet.Data{2,11} = [XL,NS11 * 100];

FigSet.Data{3,1} = [XL,UD1 *100];
FigSet.Data{3,2} = [XL,UD2 *100];
FigSet.Data{3,3} = [XL,UD3 *100];
FigSet.Data{3,4} = [XL,UD4 *100];
FigSet.Data{3,5} = [XL,UD5 *100];
FigSet.Data{3,6} = [XL,UD6 *100];
FigSet.Data{3,7} = [XL,UD7 *100];
FigSet.Data{3,8} = [XL,UD8 *100];
FigSet.Data{3,9} = [XL,UD9 *100];
FigSet.Data{3,10} = [XL,UD10 *100];
FigSet.Data{3,11} = [XL,UD11 *100];


FigSet.StorgePath = 'Table_5_Displacement time series analysis results with loose constraints_results.csv';
end

