function FileStruct = FileExtract(DataFilePath,Tag)

FileList  = dir(DataFilePath);            % Obtain the data list under the file path
DataList = {FileList.name}';
DataList(ismember(DataList,{'.','..'})) = [];

% Sublist Settings
% Sub list wildcard settings (can be changed independently)
SubFilePath  = [DataFilePath ,Tag];   
SubFileInf  = dir(SubFilePath);           % Get a list of data containing wildcards
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