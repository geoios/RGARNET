function [V,Sig] = TimeSeriesAnalysis(dEnu,ObsPath,ConPath)
%% Function：
% Plot the timing plot of the center point offset, fit straight lines, calculate fitting station velocities, and fit standard deviations
% The center point offset is calculated as follows: Single epoch center point coordinates - fixed center point coordinates of the array datum (i.e. -fix .ini file)

dCenter_E = dEnu(:,1);
dCenter_N = dEnu(:,2);
dCenter_U = dEnu(:,3);

%% Get the file path
% Specify the directory where the data resides
Wildcard    = '\*';
% Obtain the path to the observation file
ObsTag      = '-obs.csv';
IndexTag    = [Wildcard,ObsTag];
FileStruct  = FileExtract(ObsPath,IndexTag);
SvpTag      = '-svp.csv';
FileStruct  = nTypeFileLink(FileStruct,ObsTag,ObsPath,SvpTag);
% Get the profile path
Model1Tag   = '-initcfg.ini';
FileStruct  = nTypeFileLink(FileStruct,ObsTag,ConPath,Model1Tag);

%% Get time information
[time] = ReadJapTime(0,FileStruct);  % Obtain the observation time of Japan, i.e., year, month and day
for i = 1:length(time)
    T(i,1) = datenum(time(i,1),time(i,2),time(i,3));  % Convert year, month, and day to series-date
end
MidDay = mean(T);
delt   = (T - MidDay)/365;
delt = delt(1:28,:);

%% Fitting Calculations (E,N,U)
RobPar = RobustControlPar();
P      = ones(length(delt),1);%
A      = [P delt];
V      = [];
Sig    = [];
ModelNum   = 1;
for i = 1:ModelNum
    % The parameters required to fit the line
    [X_E{i},Sig_E{i},L_est_E{i},v_E{i},P_E{i},Qx_E{i}] = RobLS(A,dCenter_E(:,i),P,RobPar);
    [X_N{i},Sig_N{i},L_est_N{i},v_N{i},P_N{i},Qx_N{i}] = RobLS(A,dCenter_N(:,i),P,RobPar);
    [X_U{i},Sig_U{i},L_est_U{i},v_U{i},P_U{i},Qx_U{i}] = RobLS(A,dCenter_U(:,i),P,RobPar);
    % Fit straight lines
    Y_E{i} = X_E{i}(1) + X_E{i}(2) * delt;
    Y_N{i} = X_N{i}(1) + X_N{i}(2) * delt;
    Y_U{i} = X_U{i}(1) + X_U{i}(2) * delt;
    % Fitting station speed, fitting standard deviation
    V   = [V;X_E{i}(2),X_N{i}(2),X_U{i}(2)];
    Sig = [Sig;Sig_E{i},Sig_N{i},Sig_U{i}];
end
Result = [V,Sig];

