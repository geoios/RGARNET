function DataStruct = FileRead(DataStruct,Fun)
%% Fun 
for i = 1:DataStruct.FileNum
    % 读取配置文件信息
    iFilePath = DataStruct.SubFileList{i};
    Data = Fun(iFilePath);
    DataStruct.Data{i} =  Data;    % 文件名对应的res读取结果
end