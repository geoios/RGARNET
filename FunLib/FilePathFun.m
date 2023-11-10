function [FileStruct] = FilePathFun(SetModelMP)

if contains(SetModelMP.FilePath.ConfTag,'fix')
    ConfFileName = 'cfgfix';
else 
    ConfFileName = 'initcfg';
end

switch SetModelMP.FilePath.FileFormat 
    case 'alone'
        StnPath = SetModelMP.FilePath.StnPath;
        StnName = SetModelMP.FilePath.StnName;
        
        FileStruct.SubFileList{1,1} = [StnPath ,'\obsdata\',StnName,'\',SetModelMP.FilePath.ObsTag];
        FileStruct.SubFileList{2,1} = [StnPath ,'\obsdata\',StnName,'\',SetModelMP.FilePath.SvpTag];
        
        FileStruct.SubFileList{3,1} = [StnPath ,'\',ConfFileName,'\',StnName,'\',SetModelMP.FilePath.ConfTag];
        
        FileStruct.FileNum = 1;
    case 'bat'
        Wildcard = '\*';
        StnName  = SetModelMP.FilePath.StnName;
        StnPath  = SetModelMP.FilePath.StnPath;
        
        % Observation File Directory
        ObsPath  = [StnPath,'\obsdata\',StnName];
        ObsTag   = SetModelMP.FilePath.ObsTag;
        IndexTag = [Wildcard,ObsTag];
        FileStruct = FileExtract(ObsPath,IndexTag);
        SvpTag  = SetModelMP.FilePath.SvpTag;
        FileStruct = nTypeFileLink(FileStruct,ObsTag,ObsPath,SvpTag);
        % Configuration File Directory
        ConfPath = [StnPath,'\',ConfFileName,'\',StnName];
        ConfTag  = SetModelMP.FilePath.ConfTag;
        FileStruct = nTypeFileLink(FileStruct,ObsTag,ConfPath,ConfTag);
        
        switch StnName
            case 'MYGI'
                PosNameList = {'1209','1211','1212','1302','1306',...
                    '1309','1311','1401','1408','1501','1504','1508','1510','1602','1605','1607','1610','1703',...
                    '1704','1708','1801','1802','1808','1903','1906','1910','2002','2006'};
        end
        FileStruct.PosNameList = PosNameList;
end
FileStruct.ConfFileName = ConfFileName;
end

