function FileStruct = FileExtract(DataFilePath,Tag)

FileList  = dir(DataFilePath);            % ��ȡ�ļ�·���µ������б�
DataList = {FileList.name}';
DataList(ismember(DataList,{'.','..'})) = [];

% ���б�����
% ���б�ͨ������ã������и��ģ�
SubFilePath  = [DataFilePath ,Tag];   
SubFileInf  = dir(SubFilePath);           % ��ȡ����ͨ��������б� 
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