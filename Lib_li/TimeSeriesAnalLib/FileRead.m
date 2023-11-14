function DataStruct = FileRead(DataStruct,Fun)
%% Fun 
for i = 1:DataStruct.FileNum
    iFilePath = DataStruct.SubFileList{i};
    Data = Fun(iFilePath);
    DataStruct.Data{i} =  Data;
end