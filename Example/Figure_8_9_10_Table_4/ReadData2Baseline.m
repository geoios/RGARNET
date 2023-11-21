function [BLRes1,BLRes2,BLRes3,BLRes4] = ReadData2Baseline(BLPath1,BLPath2,BLPath3,BLPath4)

%% Read mu_0^2 = 0.005 Results
% Read File Name
Wildcard = '\*';
StnName  = 'MYGI';
StnPath  = BLPath1;

% Observation file directory
ObsPath  = ['obsdata\',StnName];
ObsTag   = '-obs.csv';
IndexTag = [Wildcard,ObsTag];
FileStruct = FileExtract(ObsPath,IndexTag);
SvpTag  = '-svp.csv';
FileStruct = nTypeFileLink(FileStruct,ObsTag,ObsPath,SvpTag);
% Profile directory
ConfPath = [StnPath,'\demo_timeSeq\',StnName];
ConfTag  = '-res.dat';
FileStruct = nTypeFileLink(FileStruct,ObsTag,ConfPath,ConfTag);

% Extract the solved coordinates
BLRes1 = zeros(FileStruct.FileNum,6);
for DataNum = 1:FileStruct.FileNum
    
    OBSFilePath = FileStruct.SubFileList{1,DataNum};
    SVPFilePath = FileStruct.SubFileList{2,DataNum};
    INIFilePath = FileStruct.SubFileList{3,DataNum};
    
    [~,~,~,MP1] = ReadData2Struct(OBSFilePath,SVPFilePath,INIFilePath);
    [BLRes1(DataNum,1),BLRes1(DataNum,2),BLRes1(DataNum,3),BLRes1(DataNum,4),BLRes1(DataNum,5),BLRes1(DataNum,6)] = ...
        deal(norm(MP1(4:6) - MP1(1:3)),norm(MP1(7:9) - MP1(4:6)),norm(MP1(10:12) - MP1(7:9)),...    % M12-M13，M13-M14，M14-M15
        norm(MP1(7:9) - MP1(1:3)),norm(MP1(10:12) - MP1(1:3)),norm(MP1(10:12) - MP1(4:6)));         % M12-M14，M12-M15，M13-M15

end

%% Read mu_0^2 = 0.01 Results
% Read File Name
Wildcard = '\*';
StnName  = 'MYGI';
StnPath  = BLPath2;

% Observation file directory
ObsPath  = ['obsdata\',StnName];
ObsTag   = '-obs.csv';
IndexTag = [Wildcard,ObsTag];
FileStruct = FileExtract(ObsPath,IndexTag);
SvpTag  = '-svp.csv';
FileStruct = nTypeFileLink(FileStruct,ObsTag,ObsPath,SvpTag);
% Profile directory
ConfPath = [StnPath,'\demo_timeSeq\',StnName];
ConfTag  = '-res.dat';
FileStruct = nTypeFileLink(FileStruct,ObsTag,ConfPath,ConfTag);

% Extract the solved coordinates
BLRes2 = zeros(FileStruct.FileNum,3);
for DataNum = 1:FileStruct.FileNum
    OBSFilePath = FileStruct.SubFileList{1,DataNum};
    SVPFilePath = FileStruct.SubFileList{2,DataNum};
    INIFilePath = FileStruct.SubFileList{3,DataNum};
    
    [~,~,~,MP1] = ReadData2Struct(OBSFilePath,SVPFilePath,INIFilePath);
    [BLRes2(DataNum,1),BLRes2(DataNum,2),BLRes2(DataNum,3),BLRes2(DataNum,4),BLRes2(DataNum,5),BLRes2(DataNum,6)] = ...
        deal(norm(MP1(4:6) - MP1(1:3)),norm(MP1(7:9) - MP1(4:6)),norm(MP1(10:12) - MP1(7:9)),...   % M12-M13，M13-M14，M14-M15
        norm(MP1(7:9) - MP1(1:3)),norm(MP1(10:12) - MP1(1:3)),norm(MP1(10:12) - MP1(4:6)));        % M12-M14，M12-M15，M13-M15
end
%% Read mu_0^2 = 0.1 Results
% Read File Name
Wildcard = '\*';
StnName  = 'MYGI';
StnPath  = BLPath3;

% Observation file directory
ObsPath  = ['obsdata\',StnName];
ObsTag   = '-obs.csv';
IndexTag = [Wildcard,ObsTag];
FileStruct = FileExtract(ObsPath,IndexTag);
SvpTag  = '-svp.csv';
FileStruct = nTypeFileLink(FileStruct,ObsTag,ObsPath,SvpTag);
% Profile directory
ConfPath = [StnPath,'\demo_timeSeq\',StnName];
ConfTag  = '-res.dat';
FileStruct = nTypeFileLink(FileStruct,ObsTag,ConfPath,ConfTag);

% Extract the solved coordinates
BLRes3 = zeros(FileStruct.FileNum,3);
for DataNum = 1:FileStruct.FileNum

    OBSFilePath = FileStruct.SubFileList{1,DataNum};
    SVPFilePath = FileStruct.SubFileList{2,DataNum};
    INIFilePath = FileStruct.SubFileList{3,DataNum};
    
    [~,~,~,MP1] = ReadData2Struct(OBSFilePath,SVPFilePath,INIFilePath);
    [BLRes3(DataNum,1),BLRes3(DataNum,2),BLRes3(DataNum,3),BLRes3(DataNum,4),BLRes3(DataNum,5),BLRes3(DataNum,6)] = ...
        deal(norm(MP1(4:6) - MP1(1:3)),norm(MP1(7:9) - MP1(4:6)),norm(MP1(10:12) - MP1(7:9)),...
        norm(MP1(7:9) - MP1(1:3)),norm(MP1(10:12) - MP1(1:3)),norm(MP1(10:12) - MP1(4:6)));
end

%% Read mu_0^2 = 10 Results
% Read File Name
Wildcard = '\*';
StnName  = 'MYGI';
StnPath  = BLPath4;

% Observation file directory
ObsPath  = ['obsdata\',StnName];
ObsTag   = '-obs.csv';
IndexTag = [Wildcard,ObsTag];
FileStruct = FileExtract(ObsPath,IndexTag);
SvpTag  = '-svp.csv';
FileStruct = nTypeFileLink(FileStruct,ObsTag,ObsPath,SvpTag);
% Profile directory
ConfPath = [StnPath,'\demo_timeSeq\',StnName];
ConfTag  = '-res.dat';
FileStruct = nTypeFileLink(FileStruct,ObsTag,ConfPath,ConfTag);

% Extract the solved coordinates
BLRes4 = zeros(FileStruct.FileNum,6);
for DataNum = 1:FileStruct.FileNum

    OBSFilePath = FileStruct.SubFileList{1,DataNum};
    SVPFilePath = FileStruct.SubFileList{2,DataNum};
    INIFilePath = FileStruct.SubFileList{3,DataNum};
    
    [~,~,~,MP1] = ReadData2Struct(OBSFilePath,SVPFilePath,INIFilePath);
    [BLRes4(DataNum,1),BLRes4(DataNum,2),BLRes4(DataNum,3),BLRes4(DataNum,4),BLRes4(DataNum,5),BLRes4(DataNum,6)] = ...
        deal(norm(MP1(4:6) - MP1(1:3)),norm(MP1(7:9) - MP1(4:6)),norm(MP1(10:12) - MP1(7:9)),...    % M12-M13，M13-M14，M14-M15
        norm(MP1(7:9) - MP1(1:3)),norm(MP1(10:12) - MP1(1:3)),norm(MP1(10:12) - MP1(4:6)));         % M12-M14，M12-M15，M13-M15

end


end

