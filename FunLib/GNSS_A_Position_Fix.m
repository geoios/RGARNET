function GNSS_A_Position_Fix(StnName)

% Specify the directory where the data is located
Wildcard = '\*';
% StnName  = 'MYGI';
StnPath  = '.';

% Observation File Directory
ObsPath  = [StnPath,'\obsdata\',StnName];
ObsTag   = '-obs.csv';
IndexTag = [Wildcard,ObsTag];
FileStruct = FileExtract(ObsPath,IndexTag);
SvpTag  = '-svp.csv';
FileStruct = nTypeFileLink(FileStruct,ObsTag,ObsPath,SvpTag);
% Solution Result File Directory
ConfPath = [StnPath,'\demo_prep\',StnName];
ConfTag  = '-res.dat';
FileStruct = nTypeFileLink(FileStruct,ObsTag,ConfPath,ConfTag);

%%  Obtain the calculation coordinates of each observation epoch
PostionNameList=[];
ncamp = 0;ndata = zeros(1,FileStruct.FileNum);
for DataNum = 1: FileStruct.FileNum
    
    % Absolute path of observation file
    OBSFilePath = FileStruct.SubFileList{1,DataNum};
    % Absolute path of sound velocity profile
    SVPFilePath = FileStruct.SubFileList{2,DataNum};
    % Absolute path to configuration file
    INIFilePath = FileStruct.SubFileList{3,DataNum};
    
    [OBSData,SVP,INIData,MP1] = ReadData2Struct(OBSFilePath,SVPFilePath,INIFilePath);
    MPList(DataNum).MP = MP1;
    
    StationsList{DataNum} = INIData.Site_parameter.Stations;
    PostionName = regexp(StationsList{DataNum},'\s+','split');
    ndata(DataNum)=length(PostionName);
    PostionNameList = unique([PostionNameList,PostionName]);

    ncamp = ncamp + 1; 
end
pdata = 1:ncamp;DeletList = [];IteMaxLoop = 20;
%% Matrix construction
for i = 1:IteMaxLoop
    % 1.Determine the number of rows and columns, and construct the H-matrix
    allMT = length(PostionNameList);
    H  = zeros(sum(ndata(pdata))+1,allMT+length(pdata));
    data = zeros(sum(ndata(pdata))+1,3);
    row = 1;
    
    % Observing Epoch Cycles
    for Num = 1:length(pdata)
        CampNum = pdata(Num);
        % Single epoch station count cycle
        for allNum = 1:allMT
            PostionNameLable = PostionNameList{allNum};
            PosNameSegList = regexp(StationsList{CampNum},'\s+','split');
            PosNameSegIndex = find(contains(PosNameSegList,PostionNameLable)==1);
            if ~isempty(PosNameSegIndex)
                H_Sta_Index = find(contains(PostionNameList,PostionNameLable)==1);
                H(row,H_Sta_Index) = 1;H(row,allMT+Num) = 1;
                % 2.data matrix construction
                data_Sta_Index = find(contains(PosNameSegList,PostionNameLable)==1);
                data(row,:) = MPList(CampNum).MP((data_Sta_Index-1)*3+1:data_Sta_Index*3);
                row = row + 1;
            end
        end
    end
    
    H(end,allMT+1:end) =ones(1,length(pdata));
    
    
    para = inv(H'*H)*H'*data;
    
    calc = H * para;
    calc = calc(1:end-1,:);
    obsd = data(1:end-1,:);
    depth = mean(obsd(:,3));
    base = obsd/abs(depth);
    
    oc = obsd-calc;
    
    erms = sqrt(sum(oc(:,1).^2)/length(oc(:,1)));
    nrms = sqrt(sum(oc(:,2).^2)/length(oc(:,2)));
    urms = sqrt(sum(oc(:,3).^2)/length(oc(:,3)));
    
    rmcri = 4;
    rl = length(DeletList);
    AllNum = 1;LocalNum = 1;
    DelList=[];
    for j = 1:ncamp
        if ismember(j,DeletList)
            continue;
        end
        for k = 1:ndata(pdata(LocalNum))
            if abs(oc(AllNum,1))>rmcri*erms||abs(oc(AllNum,2))>rmcri*nrms||abs(oc(AllNum,3))>rmcri*urms
                DelList = [DelList,LocalNum];
                DeletList =[DeletList,j];
            end
            AllNum = AllNum + 1;
        end
        LocalNum = LocalNum +1;
    end
    DeletList = unique(DeletList);
    pdata(unique(DelList))=[];
    if rl-length(unique(DeletList))==0
        break;
    end
end
para_fix = para(1:allMT,:);dpara = para(allMT+1:end,:);

ConfPath = [StnPath,'\initcfg\',StnName];
ConfTag  = '-initcfg.ini';
FileStruct = nTypeFileLink(FileStruct,ObsTag,ConfPath,ConfTag);

for DataNum = 1: FileStruct.FileNum
    INIReadFilePath = FileStruct.SubFileList{4,DataNum};
    INIWriteFilePath = strrep(INIReadFilePath,'initcfg.ini','fix.ini');
    INIWriteFilePath = strrep(INIWriteFilePath,'initcfg','cfgfix');
    RWNSinex(INIReadFilePath,INIWriteFilePath,para_fix,PostionNameList);
end

end

