function [OBSDataStruct,SVP,INIDataStruct,MP] = ReadData2Struct(FilePath1,FilePath2,FilePath3)

OBSDataTable = rmmissing(readtable(FilePath1)); % Remove Nan value
OBSMT = OBSDataTable.MT;
%%
% 1.Read the data in ". csv" and display it in the form of table in Matlab
SVPDataTable = readtable(FilePath2);
% 2.Read the data in '. ini' and output it as a struct
INIDataStruct = ReadNSinex(FilePath3);

%% Data Struct
Stations = Read_Ini_File(FilePath3,'Stations');
for i=1:length(Stations)
    [index]=find(strcmp(OBSMT,{Stations{i}})==1);
    OBSDataTable.MTPSign(index)=(i-1)*3*ones(length(index),1)+1;
end

[OBSDataStruct] = DataTable2DataStruct(OBSDataTable);
[SVPDataStruct] = DataTable2DataStruct(SVPDataTable);
SVP(:,1) = SVPDataStruct.depth;
SVP(:,2) = SVPDataStruct.speed;
%% Update effective observations
INIDataStruct.Data_file.N_shot = length(OBSDataStruct.ant_e0);
%%  Generate parameter matrix
PosNameTips = fieldnames(INIDataStruct.Model_parameter.MT_Pos);
EachPos = [];CovXX = [];
PosNum = length(PosNameTips);
for i=1:PosNum
    if ~isempty(strfind(PosNameTips{i},'_dPos'))
        mp = getfield(INIDataStruct.Model_parameter.MT_Pos,PosNameTips{i});
        EachPos = [EachPos,mp(1:3)];
        CovXX  = [CovXX,mp(4:6)];
    end
end
% 2.Determine the coordinate parameters
dCentPos = str2num(INIDataStruct.Model_parameter.MT_Pos.dCentPos);
dCenPosCovXX = dCentPos(4:6);CovXX = [CovXX,dCenPosCovXX];
ATD = INIDataStruct.Model_parameter.MT_Pos.ANT_to_TD.ATDoffset;
INIDataStruct.FixModel = contains(FilePath3,'fix');
if INIDataStruct.FixModel
    INIDataStruct.FixSave = 'demo_res';
else
    INIDataStruct.FixSave = 'demo_prep';
end
MP = [EachPos,dCentPos(1:3)];
[INIDataStruct.PriorMP,INIDataStruct.PosteriMP]= deal([EachPos,dCentPos(1:3),ATD(1:3)]);
INIDataStruct.ProCov = diag(CovXX.^2);
end

