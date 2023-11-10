function [ConfigData,INIWriteFilePath,OutFileName] = SolFix(ObsPath,JapSolPath,ConfigPath,SolSinglePath,SaveFixFilePath)
% load('D:\Desktop\程序\解算配置文件\MYGI_ConfigData.mat')
%% 获取数据存放位置
% 指定数据所在目录
Wildcard = '\*';
% 观测文件目录
ObsTag   = '-obs.csv';
IndexTag = [Wildcard,ObsTag];
FileStruct = FileExtract(ObsPath,IndexTag);
SvpTag  = '-svp.csv';
FileStruct = nTypeFileLink(FileStruct,ObsTag,ObsPath,SvpTag);
% 解算结果文件目录
JapSolTag  = '-res.dat';
FileStruct = nTypeFileLink(FileStruct,ObsTag,JapSolPath,JapSolTag);
% 配置文件目录
ConfigTag  = '-initcfg.ini';
FileStruct = nTypeFileLink(FileStruct,ObsTag,ConfigPath,ConfigTag);

% [Japtime] = ReadJapTime(FileStruct,1);
%%  获取每个观测历元解算坐标
PostionNameList=[];
ncamp = 0;ndata = zeros(1,FileStruct.FileNum);

Data           = load(SolSinglePath);
Val_name       = fieldnames(Data);
ModelData      = getfield(Data,Val_name{2});

for DataNum = 1:FileStruct.FileNum
    %% 数据格式转化
    %----------------观测文件绝对路径-----------------
    OBSFilePath = FileStruct.SubFileList{1,DataNum};
    %----------------声速剖面绝对路径-----------------
    SVPFilePath = FileStruct.SubFileList{2,DataNum};
    %----------------配置参数设置文件-----------------
    INIFilePath = FileStruct.SubFileList{3,DataNum};

    ConfigData = ReadNSinex(INIFilePath);
    
%     [OBSData,SVP,INIData,MP1] = ReadData2Struct(OBSFilePath,SVPFilePath,INIFilePath);
%     MPList(DataNum).MP = MP1;

    Net = [];
    for len = 1:length(ModelData{DataNum})
        Net = [Net,ModelData{DataNum}(len,:)];
    end

    MPList(DataNum).MP = Net;  % (1:MPNum(1))
    StationsList{DataNum} = ConfigData.Site_parameter.Stations;
    PostionName = regexp(StationsList{DataNum},'\s+','split');
    ndata(DataNum)=length(PostionName);
    PostionNameList = unique([PostionNameList,PostionName]);
    
    
    ncamp = ncamp + 1;
    
end
pdata = 1:ncamp;DeletList = [];IteMaxLoop = 20;
%% 矩阵构建
for i = 1:IteMaxLoop
    % 1.判断行数、列数，构建H矩阵
    allMT = length(PostionNameList);
    H  = zeros(sum(ndata(pdata))+1,allMT+length(pdata));
    data = zeros(sum(ndata(pdata))+1,3);
    row = 1;
    
    % 观测历元数循环
    for Num = 1:length(pdata)
        CampNum = pdata(Num);
        % 单历元站点数循环
        for allNum = 1:allMT
            PostionNameLable = PostionNameList{allNum};
            PosNameSegList = regexp(StationsList{CampNum},'\s+','split');
            PosNameSegIndex = find(contains(PosNameSegList,PostionNameLable)==1);
            if ~isempty(PosNameSegIndex)
                H_Sta_Index = find(contains(PostionNameList,PostionNameLable)==1);
                H(row,H_Sta_Index) = 1;H(row,allMT+Num) = 1;
                % 2.data矩阵构建
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
    DeletList =unique(DeletList);
    pdata(unique(DelList))=[];
    if rl-length(unique(DeletList))==0
        break;
    end
end

% % 文件
% ConfPath = [StnPath,'\initcfg\',StnName];
% ConfTag  = '-initcfg.ini';
% FileStruct = nTypeFileLink(FileStruct,ObsTag,ConfPath,ConfTag);

SegOutFile  = split(SolSinglePath,'\');
OutFileName = split(SegOutFile(end),'.');

for DataNum = 1: FileStruct.FileNum
    
    INIReadFilePath = FileStruct.SubFileList{4,DataNum};
    IniWriteFilePath = ReplaceStr(INIReadFilePath,'initcfg',[OutFileName{1},'-fix']);
    SegIniWriteFilePath = split(IniWriteFilePath,'\');
    INIWriteFilePath = [SaveFixFilePath,'\FixArrayCoor\',SegIniWriteFilePath{end-2},'\',SegIniWriteFilePath{end-1},'\',SegIniWriteFilePath{end}];
%     INIWriteFilePath = strrep(INIReadFilePath,'initcfg','fix');
    RWNSinex(INIReadFilePath,INIWriteFilePath,para,PostionNameList);
end





