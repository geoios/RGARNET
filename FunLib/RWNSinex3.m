function RWNSinex3(FileStruct,RESData,SetModelMP,INIData,para,ResComPath)
StnName = SetModelMP.FilePath.StnName;
WritePath = [ResComPath,'\',INIData.FixSave,'\','res.',StnName,'.dat'];

% create folder
indexList = strfind(WritePath,'\');
FilePath = WritePath(1:indexList(end));
if ~exist(FilePath,'dir')
    mkdir (FilePath)
end
% Read the formulated configuration file
FidWrite = fopen(WritePath,'w');
% Input
fprintf(FidWrite,['#SITE: ',StnName,'\n']);
fprintf(FidWrite,'#Year          EW[m]      NS[m]      UD[m]   sgmEW[m]   sgmNS[m]   sgmUD[m]\n');
for DataNum = 1:FileStruct.FileNum
    MP = para(DataNum,:);
    YearDay = regexp(RESData(DataNum).INIData.Obs_parameter.Datejday,'-','split');
    tline = [' ',num2str(str2num(YearDay{1}) + str2num(YearDay{2})/day(datetime(str2num(YearDay{1}),12,31),'dayofyear'),'% 10.4f'),'\t'];
    tline = [tline,sprintf('% 10.4f',MP),];
    fprintf(FidWrite,[tline,'\n']);
end
fclose(FidWrite);
end

