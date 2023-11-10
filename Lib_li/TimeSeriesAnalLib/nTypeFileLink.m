function FileStruct = nTypeFileLink(FileStruct,Tag1,DataPath,Tag2)
n = length(FileStruct.SubFileList);
FileStruct.LinkNum = FileStruct.LinkNum + 1;
for i = 1:n
    iObsFilePath = FileStruct.SubFileList{1,i};
    if iscell(iObsFilePath)
        iObsFilePath = iObsFilePath{1};
    end
    [iObsPath iObsFileName ext] = fileparts(iObsFilePath);  %% 
    
    iSvpFileName = strrep([iObsFileName ext],Tag1,Tag2);
    iSvpFilePath = [DataPath '\' iSvpFileName];
    iSvpFilePath;
    if exist(iSvpFilePath,'file') == 2
       FileStruct.SubFileList{FileStruct.LinkNum,i} = iSvpFilePath;
    else
       FileStruct.SubFileList{FileStruct.LinkNum,i} = ''; 
    end
    %iSvpFileName = strrep(iObsFileName,Tag1,Tag3);
end
end