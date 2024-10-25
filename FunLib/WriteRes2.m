function  WriteRes2(FileStruct,ModelT_MP_T,RESData,SetModelMP,ResComPath,Qxx)
CumNum = 0;CumNum2 = 0;

for DataNum = 1:FileStruct.FileNum
    INIData = RESData(DataNum).INIData;
    ResPath = [ResComPath,'\',INIData.FixSave,'\',INIData.Obs_parameter.Site_name,'\',INIData.Obs_parameter.Site_name,'.',INIData.Obs_parameter.Campaign];
    INIReadFilePath = FileStruct.SubFileList{3,DataNum};
    %% Output array solution result file
    INIWriteFilePath = [ResPath,'-res.dat'];
    MPNum = RESData(DataNum).MPNum;
    MPIndex = CumNum + 1:CumNum + MPNum(1);CumNum = MPNum(end) + CumNum;
    MPIndex2 = CumNum2 + 1:CumNum2 + MPNum(1);CumNum2 = MPNum(1) + CumNum2;
    FalseIndex = find(strcmp(RESData(DataNum).OBSData.flag,'False')==1);used_shot = length(FalseIndex);
    para = reshape(ModelT_MP_T(MPIndex),3,MPNum(1)/3)';
    D = Qxx(MPIndex2,MPIndex2);
    %%%%%%%
    for j = 1:MPNum(1)/3
        UN(j,:) = D(3*(j-1)+2,3*(j-1)+3);
        UE(j,:) = D(3*(j-1)+1,3*(j-1)+3);
        NE(j,:) = D(3*(j-1)+1,3*(j-1)+2);
    end
    Dxx = reshape(sqrt(diag(D)),3,MPNum(1)/3)';
    %%%%%%%
    para = [para,Dxx,UN,UE,NE];
    Stations = regexp(strip(INIData.Site_parameter.Stations),'\s+','split');
    RWNSinex2(INIReadFilePath,INIWriteFilePath,full(para),Stations,used_shot);
    
    
    %% Sea surface trajectory
    % TrackPath = [ResPath,'_Track.png'];
    % [FigSet] = SeaTrack_Plotini(RESData(DataNum).OBSData,para(:,1:2),TrackPath);
    % [FigSet] = PlotFig_ini(FigSet);
    % PlotFig_res(FigSet);
    
    %% Horizontal gradient
    % SavePath = [ResPath,'_SSF.png'];
    % switch SetModelMP.Inv_model.ObsEqModel
    %     case 0
    %         [OBSData] = OutPutField_0(RESData(DataNum).OBSData);
    %         if SetModelMP.Inv_model.TModel == 2 && SetModelMP.Inv_model.FloorENModel == 2 && SetModelMP.Inv_model.SurENModel == 0
    %             [FigSet] = SSFGrad_Plotini_220(OBSData,SavePath);
    %         elseif SetModelMP.Inv_model.TModel == 6 && SetModelMP.Inv_model.FloorENModel == 7 && SetModelMP.Inv_model.SurENModel == 7
    %             [FigSet] = SSFGrad_Plotini_677(OBSData,SavePath);
    %         end
    % 
    %     case 1
    %         [OBSData] = OutPutField_1(OBSData);
    %         [FigSet] = SSFGrad_Plotini_1(OBSData,SSFPath);
    % 
    % end
    % [FigSet] = PlotFig_ini(FigSet);
    % PlotFig_res(FigSet);
    %% Output time residual
    % ResiTTPath = [ResPath,'_ResiTT.png'];
    % [FigSet] = dT_Plotini(RESData(DataNum).OBSData,ResiTTPath);
    % [FigSet] = PlotFig_ini(FigSet);
    % PlotFig_res(FigSet);
    
    %% Output result file (structure to table)
    ObsWriteFilePath = [ResPath,'-obs.csv'];
    ResDatName = regexp(INIWriteFilePath,'\','split');
    cfgfileName = [INIData.FixSave,'/',INIData.Obs_parameter.Site_name,'/',ResDatName{end}];
    [OBSData] = OutPutField_0(RESData(DataNum).OBSData);
    struct2csv(OBSData,ObsWriteFilePath,cfgfileName);

end

end

