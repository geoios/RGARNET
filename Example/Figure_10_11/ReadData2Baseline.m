function [BLRes1,BLRes2] = ReadData2Baseline(BLPath1,BLPath2,BLPath3)

%% 读取约束因子Mu3 = 0.005的观测数据
% 读取文件名
Wildcard = '\*';
StnName  = 'MYGI';
StnPath  = BLPath1;

% 观测文件目录
ObsPath  = [StnPath,'\obsdata\',StnName];
ObsTag   = '-obs.csv';
IndexTag = [Wildcard,ObsTag];
FileStruct = FileExtract(ObsPath,IndexTag);
SvpTag  = '-svp.csv';
FileStruct = nTypeFileLink(FileStruct,ObsTag,ObsPath,SvpTag);
% 配置文件目录
ConfPath = [StnPath,'\demo_timeSeq\',StnName];
ConfTag  = '-res.dat';
FileStruct = nTypeFileLink(FileStruct,ObsTag,ConfPath,ConfTag);

% 提取解算坐标
BLRes1 = zeros(FileStruct.FileNum,6);
for DataNum = 1:FileStruct.FileNum
    % 数据格式转化
    %----------------观测文件绝对路径-----------------
    OBSFilePath = FileStruct.SubFileList{1,DataNum};
    %----------------声速剖面绝对路径-----------------
    SVPFilePath = FileStruct.SubFileList{2,DataNum};
    %----------------配置参数设置文件-----------------
    INIFilePath = FileStruct.SubFileList{3,DataNum};
    
    [~,~,~,MP1] = ReadData2Struct(OBSFilePath,SVPFilePath,INIFilePath);
    [BLRes1(DataNum,1),BLRes1(DataNum,2),BLRes1(DataNum,3)] = ...
        deal(norm(MP1(4:6) - MP1(1:3)),norm(MP1(7:9) - MP1(4:6)),norm(MP1(10:12) - MP1(7:9)),...    % M12-M13，M13-M14，M14-M15
        norm(MP1(7:9) - MP1(1:3)),norm(MP1(10:12) - MP1(1:3)),norm(MP1(10:12) - MP1(4:6)));         % M12-M14，M12-M15，M13-M15

end

%% 读取约束因子Mu3 = 0.01的观测数据
% 读取文件名
Wildcard = '\*';
StnName  = 'MYGI';
StnPath  = BLPath2;

% 观测文件目录
ObsPath  = [StnPath,'\obsdata\',StnName];
ObsTag   = '-obs.csv';
IndexTag = [Wildcard,ObsTag];
FileStruct = FileExtract(ObsPath,IndexTag);
SvpTag  = '-svp.csv';
FileStruct = nTypeFileLink(FileStruct,ObsTag,ObsPath,SvpTag);
% 配置文件目录
ConfPath = [StnPath,'\demo_timeSeq\',StnName];
ConfTag  = '-res.dat';
FileStruct = nTypeFileLink(FileStruct,ObsTag,ConfPath,ConfTag);

% 提取解算坐标
BLRes2 = zeros(FileStruct.FileNum,3);
for DataNum = 1:FileStruct.FileNum
    % 数据格式转化
    %----------------观测文件绝对路径-----------------
    OBSFilePath = FileStruct.SubFileList{1,DataNum};
    %----------------声速剖面绝对路径-----------------
    SVPFilePath = FileStruct.SubFileList{2,DataNum};
    %----------------配置参数设置文件-----------------
    INIFilePath = FileStruct.SubFileList{3,DataNum};
    
    [~,~,~,MP1] = ReadData2Struct(OBSFilePath,SVPFilePath,INIFilePath);
    [BLRes2(DataNum,1),BLRes2(DataNum,2),BLRes2(DataNum,3)] = ...
        deal(norm(MP1(4:6) - MP1(1:3)),norm(MP1(7:9) - MP1(4:6)),norm(MP1(10:12) - MP1(7:9)),...
        norm(MP1(7:9) - MP1(1:3)),norm(MP1(10:12) - MP1(1:3)),norm(MP1(10:12) - MP1(4:6)));
end

%% 读取约束因子Mu3 = 100的观测数据
% 读取文件名
Wildcard = '\*';
StnName  = 'MYGI';
StnPath  = BLPath3;

% 观测文件目录
ObsPath  = [StnPath,'\obsdata\',StnName];
ObsTag   = '-obs.csv';
IndexTag = [Wildcard,ObsTag];
FileStruct = FileExtract(ObsPath,IndexTag);
SvpTag  = '-svp.csv';
FileStruct = nTypeFileLink(FileStruct,ObsTag,ObsPath,SvpTag);
% 配置文件目录
ConfPath = [StnPath,'\demo_timeSeq\',StnName];
ConfTag  = '-res.dat';
FileStruct = nTypeFileLink(FileStruct,ObsTag,ConfPath,ConfTag);

% 提取解算坐标
BLRes3 = zeros(FileStruct.FileNum,6);
for DataNum = 1:FileStruct.FileNum
    % 数据格式转化
    %----------------观测文件绝对路径-----------------
    OBSFilePath = FileStruct.SubFileList{1,DataNum};
    %----------------声速剖面绝对路径-----------------
    SVPFilePath = FileStruct.SubFileList{2,DataNum};
    %----------------配置参数设置文件-----------------
    INIFilePath = FileStruct.SubFileList{3,DataNum};
    
    [~,~,~,MP1] = ReadData2Struct(OBSFilePath,SVPFilePath,INIFilePath);
    [BLRes3(DataNum,1),BLRes3(DataNum,2),BLRes3(DataNum,3)] = ...
        deal(norm(MP1(4:6) - MP1(1:3)),norm(MP1(7:9) - MP1(4:6)),norm(MP1(10:12) - MP1(7:9)),...    % M12-M13，M13-M14，M14-M15
        norm(MP1(7:9) - MP1(1:3)),norm(MP1(10:12) - MP1(1:3)),norm(MP1(10:12) - MP1(4:6)));         % M12-M14，M12-M15，M13-M15

end


end

