function FileStruct = FileExtract(DataFilePath,Tag)

FileList  = dir(DataFilePath);            % 获取文件路径下的数据列表
DataList = {FileList.name}';
DataList(ismember(DataList,{'.','..'})) = [];

% 子列表设置
% 子列表通配符设置（可自行更改）
SubFilePath  = [DataFilePath ,Tag];   
SubFileInf  = dir(SubFilePath);           % 获取包含通配符数据列表 
SubFileList = {[DataFilePath '\' SubFileInf.name]}';

Name = {SubFileInf.name};
for i = 1:length(Name)
  SubFileList{i} = [DataFilePath '\' Name{i}];
end
DataNum =  length(SubFileList);

FileStruct.DataFilePath = DataFilePath;
FileStruct.Tag          = Tag;
FileStruct.FileNum      = DataNum;
FileStruct.SubFileList  = SubFileList;
FileStruct.LinkNum = 1;
end