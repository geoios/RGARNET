function [OBSData,SVP,INIData,MP_ENU] = FileInFun(FileStruct,DataNum)
% Data format conversion
%----------Absolute path of observation file------
OBSFilePath = FileStruct.SubFileList{1,DataNum};
%-----Absolute path of sound velocity profile-----
SVPFilePath = FileStruct.SubFileList{2,DataNum};
%---------Absolute path of Configure file---------
INIFilePath = FileStruct.SubFileList{3,DataNum};

[OBSData,SVP,INIData,MP_ENU] = ReadData2Struct(OBSFilePath,SVPFilePath,INIFilePath);
end

