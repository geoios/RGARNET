function [V,Sig] = TimeSeriesAnalysis(dEnu,ObsPath,ConPath)
%% 作用：
% 绘制中心点偏移量的时序图、拟合直线、计算拟合站速度及拟合标准差
% 中心点偏移量的计算方式为：单历元中心点坐标 - 固定阵列基准的中心点坐标 (即 -fix.ini 文件)

dCenter_E = dEnu(:,1);
dCenter_N = dEnu(:,2);
dCenter_U = dEnu(:,3);

%% 获取文件路径
% 指定数据所在目录
Wildcard    = '\*';
% 获取日本观测文件路径
ObsTag      = '-obs.csv';
IndexTag    = [Wildcard,ObsTag];
FileStruct  = FileExtract(ObsPath,IndexTag);
SvpTag      = '-svp.csv';
FileStruct  = nTypeFileLink(FileStruct,ObsTag,ObsPath,SvpTag);
% Model1 阵列基准坐标的路径
Model1Tag   = '-initcfg.ini';
FileStruct  = nTypeFileLink(FileStruct,ObsTag,ConPath,Model1Tag);

%% 获取时间信息
[time] = ReadJapTime(0,FileStruct);  % 获取日本观测时间，即年月日
for i = 1:length(time)
    T(i,1) = datenum(time(i,1),time(i,2),time(i,3));  % 将年月日转换序列-日期
end
MidDay = mean(T);
delt   = (T - MidDay)/365;
delt = delt(1:28,:);

%% 拟合计算 (E,N,U)
RobPar = RobustControlPar();
P      = ones(length(delt),1);%
A      = [P delt];
V      = [];
Sig    = [];
ModelNum   = 1;
for i = 1:ModelNum
    % 拟合直线所需的参数
    [X_E{i},Sig_E{i},L_est_E{i},v_E{i},P_E{i},Qx_E{i}] = RobLS(A,dCenter_E(:,i),P,RobPar);
    [X_N{i},Sig_N{i},L_est_N{i},v_N{i},P_N{i},Qx_N{i}] = RobLS(A,dCenter_N(:,i),P,RobPar);
    [X_U{i},Sig_U{i},L_est_U{i},v_U{i},P_U{i},Qx_U{i}] = RobLS(A,dCenter_U(:,i),P,RobPar);
    % 拟合直线
    Y_E{i} = X_E{i}(1) + X_E{i}(2) * delt;
    Y_N{i} = X_N{i}(1) + X_N{i}(2) * delt;
    Y_U{i} = X_U{i}(1) + X_U{i}(2) * delt;
    % 拟合站速度、拟合标准差
    V   = [V;X_E{i}(2),X_N{i}(2),X_U{i}(2)];
    Sig = [Sig;Sig_E{i},Sig_N{i},Sig_U{i}];
end
Result = [V,Sig];

