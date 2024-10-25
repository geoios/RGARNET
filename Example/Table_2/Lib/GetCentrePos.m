function GetCentrePos(TableName)
%% Rigid array solution
ResMYGI = readtable('TimeSqe_Rigid/demo_timeSeq/res.MYGI.dat');
EW1 = ResMYGI.EW_m_;NS1 = ResMYGI.NS_m_;UD1 = ResMYGI.UD_m_;
RES1 = [EW1,NS1,UD1]';
Rigid_array_solution = reshape(RES1,[],1);

%% Loose-constrained solutions (\mu_0^2 = 1e4 ~ 1e-8) solution
array_solution_all = [];
Mu = [1e4,1e3,1e2,1e1,1,1e-1,1e-2,1e-3,1e-4,1e-5,1e-6,1e-7,1e-8];%
for MuIndex = 1:length(Mu)
    ResComPath = ['TimeSqe_Loose_constrained',num2str(Mu(MuIndex),'%6.2e')];
    ResFileName = 'demo_timeSeq/res.MYGI.dat';
    FilaName = fullfile(ResComPath,ResFileName);
    ResMYGI = readtable(FilaName);
    EW2 = ResMYGI.EW_m_;NS2 = ResMYGI.NS_m_;UD2 = ResMYGI.UD_m_;
    RES2 = [EW2,NS2,UD2]';
    array_solution = reshape(RES2,[],1);
    array_solution_all = [array_solution_all,array_solution];
end
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

EW3 = Epoch_dCentPos(:,1) - Fix_dCentPos(1);
NS3 = Epoch_dCentPos(:,2) - Fix_dCentPos(2);
UD3 = Epoch_dCentPos(:,3) - Fix_dCentPos(3);
RES3 = [EW3,NS3,UD3]';
Free_array_solution = reshape(RES3,[],1);


%% OutPut CSV
Epoch =[ 'MYGI.1209';'MYGI.1209';'MYGI.1209';'MYGI.1211';'MYGI.1211';'MYGI.1211';'MYGI.1212';'MYGI.1212';'MYGI.1212'];
Coor = ['E(m)';'N(m)';'U(m)';'E(m)';'N(m)';'U(m)';'E(m)';'N(m)';'U(m)'];
Table2 = table(Epoch,Coor,Rigid_array_solution,array_solution_all(:,1),array_solution_all(:,2),...
    array_solution_all(:,3),array_solution_all(:,4),array_solution_all(:,5),array_solution_all(:,6),...
    array_solution_all(:,7),array_solution_all(:,8),array_solution_all(:,9),array_solution_all(:,10),...
    array_solution_all(:,11),array_solution_all(:,12),array_solution_all(:,13),...
    Free_array_solution,'VariableNames',{'EPoch','Coor.','Rigid-array',...
    '1e4','1e3','1e2','1e1','1','1e-1','1e-2','1e-3','1e-4','1e-5','1e-6','1e-7','1e-8','Free-array'});
writetable(Table2,TableName);
end

