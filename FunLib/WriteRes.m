function  [TimSqeList] = WriteRes(FileStruct,ModelT_MP_T,OBSData,INIData,MPNum,Qxx,sigma0,SVP,DataNum,SetModelMP,ResComPath)
INIReadFilePath = FileStruct.SubFileList{3,DataNum};
ResPath = [ResComPath,'\',INIData.FixSave,'\',INIData.Obs_parameter.Site_name];
ResPath = [ResPath,'\',INIData.Obs_parameter.Site_name,'.',INIData.Obs_parameter.Campaign];
INIWriteFilePath = [ResPath,'-res.dat'];
if INIData.FixModel
    %% Output array solution result file
    para = ModelT_MP_T(MPNum(1)-2:MPNum(1));
    FalseIndex = find(strcmp(OBSData.flag,'False')==1);used_shot = length(FalseIndex);
    % Obtain variance
    SVPAvg = MeanVel(SVP);
    sigma_xx = Qxx(1:3,1:3)./ SVPAvg * sigma0;
    
    UN = sigma_xx(2,3);
    UE = sigma_xx(1,3);
    NE = sigma_xx(1,2);
    Sigma_Diag = sqrt(diag(sigma_xx));
    para = [para,Sigma_Diag',UN,UE,NE];
    RWNSinex1(INIReadFilePath,INIWriteFilePath,para,used_shot);
    TimSqeList = para(1:6);
else
    %% Output single epoch calculation result file configuration file
    para = reshape(ModelT_MP_T(1:MPNum(1)-3),3,(MPNum(1)-3)/3)'; 
    % Obtain variance
    SVPAvg = MeanVel(SVP);
    FalseIndex = find(strcmp(OBSData.flag,'False')==1);used_shot = length(FalseIndex);
    sigma_xx = Qxx(1:MPNum(1)-3,1:MPNum(1)-3)./ SVPAvg * sigma0;
    for j = 1:MPNum(1)/3-1
        UN(j,:) = sigma_xx(3*(j-1)+2,3*(j-1)+3);
        UE(j,:) = sigma_xx(3*(j-1)+1,3*(j-1)+3);
        NE(j,:) = sigma_xx(3*(j-1)+1,3*(j-1)+2);
    end
    Sigma_Diag = reshape(sqrt(diag(sigma_xx)),3,(MPNum(1)-3)/3)';
    para = [para,Sigma_Diag,UN,UE,NE];
    Stations = regexp(strip(INIData.Site_parameter.Stations),'\s+','split');
    RWNSinex2(INIReadFilePath,INIWriteFilePath,para,Stations,used_shot);
    TimSqeList = zeros(1,6);
end
%% Sea surface trajectory
TrackPath = [ResPath,'_Track.png'];
MPPos = reshape(ModelT_MP_T(1:MPNum(1)),3,MPNum(1)/3)';
[FigSet] = SeaTrack_Plotini(OBSData,MPPos(:,1:2),TrackPath);
[FigSet] = PlotFig_ini(FigSet);
PlotFig_res(FigSet);

%% Horizontal gradient
SSFPath = [ResPath,'_SSF.png'];
switch SetModelMP.Inv_model.ObsEqModel
    case 0
        [OBSData] = OutPutField_0(OBSData);
        if SetModelMP.Inv_model.TModel == 2 && SetModelMP.Inv_model.FloorENModel == 2 && SetModelMP.Inv_model.SurENModel == 0
            [FigSet] = SSFGrad_Plotini_220(OBSData,SSFPath);
        elseif SetModelMP.Inv_model.TModel == 6 && SetModelMP.Inv_model.FloorENModel == 7 && SetModelMP.Inv_model.SurENModel == 7
            [FigSet] = SSFGrad_Plotini_677(OBSData,SSFPath);
        end
        
    case 1
        [OBSData] = OutPutField_1(OBSData);
        [FigSet] = SSFGrad_Plotini_1(OBSData,SSFPath);
        
end
[FigSet] = PlotFig_ini(FigSet);
PlotFig_res(FigSet);


%% Output time residual
ResiTTPath = [ResPath,'_ResiTT.png'];
[FigSet] = dT_Plotini(OBSData,ResiTTPath);
[FigSet] = PlotFig_ini(FigSet);
PlotFig_res(FigSet);

%% Output result file (structure to table)
ObsWriteFilePath = strrep(INIWriteFilePath,'-res.dat','-obs.csv');
ResDatName = regexp(INIWriteFilePath,'\','split');
cfgfileName = [INIData.FixSave,'/',INIData.Obs_parameter.Site_name,'/',ResDatName{end}];
struct2csv(OBSData,ObsWriteFilePath,cfgfileName);

%% Output".mat" result file
MatPath = [ResPath,'_Res.mat'];
save(MatPath)
end

