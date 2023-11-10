function GetCentrePos(TableName)
%% Array-fixed solution
ResMYGI = readtable('demo_res/res.MYGI.dat');
EW0 = ResMYGI.EW_m_;NS0 = ResMYGI.NS_m_;UD0 = ResMYGI.UD_m_;
RES0 = [EW0,NS0,UD0]';
Array_fixed_solution = reshape(RES0,[],1);
%% Rigid array solution
ResMYGI = readtable('TimeSqe_Rigid/demo_timeSeq/res.MYGI.dat');
EW1 = ResMYGI.EW_m_;NS1 = ResMYGI.NS_m_;UD1 = ResMYGI.UD_m_;
RES1 = [EW1,NS1,UD1]';
Rigid_array_solution = reshape(RES1,[],1);
%% Resilient array solution
ResMYGI = readtable('TimeSqe_Rilient/demo_timeSeq/res.MYGI.dat');
EW2 = ResMYGI.EW_m_;NS2 = ResMYGI.NS_m_;UD2 = ResMYGI.UD_m_;
RES2 = [EW2,NS2,UD2]';
Resilient_array_solution = reshape(RES2,[],1);
%% Array-free solution
prep_res_dir = dir('demo_prep/MYGI/*-res.dat');datNum = length(prep_res_dir);
Epoch_dCentPos = zeros(datNum,3);
for dirNum = 1:datNum
    ResData = ReadNSinex([prep_res_dir(dirNum).folder,'\',prep_res_dir(dirNum).name]);
    Epoch_dCentPos(dirNum,:) = ResData.Site_parameter.Array_cent.Center_ENU;
end
fix_dir = dir('cfgfix/MYGI/*-fix.ini');
FixData = ReadNSinex([fix_dir(1).folder,'\',fix_dir(1).name]);
Fix_dCentPos = FixData.Site_parameter.Array_cent.Center_ENU;

EW3 = Epoch_dCentPos(:,1) - Fix_dCentPos(1);
NS3 = Epoch_dCentPos(:,2) - Fix_dCentPos(2);
UD3 = Epoch_dCentPos(:,3) - Fix_dCentPos(3);
RES3 = [EW3,NS3,UD3]';
Array_free_solution = reshape(RES3,[],1);
%% OutPut CSV
Epoch =[ 'MYGI.1209';'MYGI.1209';'MYGI.1209';'MYGI.1211';'MYGI.1211';'MYGI.1211';'MYGI.1212';'MYGI.1212';'MYGI.1212'];
Coor = ['E(m)';'N(m)';'U(m)';'E(m)';'N(m)';'U(m)';'E(m)';'N(m)';'U(m)'];
Table2 = table(Epoch,Coor,Array_free_solution,Array_fixed_solution,Rigid_array_solution,Resilient_array_solution);
writetable(Table2,TableName);
end

