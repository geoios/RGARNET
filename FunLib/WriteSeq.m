function WriteSeq(FileStruct,ModelT_MP_T,RESData,SetModelMP,ResComPath)
%% Matrix construction
PostionNameList=[];MPTotal = 1;
ncamp = 0;ndata = zeros(1,FileStruct.FileNum);
for DataNum = 1:FileStruct.FileNum
    MPList(DataNum).MP = ModelT_MP_T(MPTotal:MPTotal+RESData(DataNum).MPNum-1);
    MPTotal = MPTotal + RESData(DataNum).MPNum(end);
    
    StationsList{DataNum} = RESData(DataNum).INIData.Site_parameter.Stations;
    PostionName = regexp(StationsList{DataNum},'\s+','split');
    ndata(DataNum)=length(PostionName);
    PostionNameList = unique([PostionNameList,PostionName]);
    ncamp = ncamp + 1;
    PosNamesplit = split(RESData(DataNum).INIData.Obs_parameter.Campaign, '.');
    PosNameList{DataNum} = PosNamesplit{1};
end
pdata = 1:ncamp;DeletList = [];IteMaxLoop = 20;
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
INIData = RESData(DataNum).INIData;
Outpara = [para(end-FileStruct.FileNum+1:end,:),zeros(FileStruct.FileNum,3)];
ResPath = [ResComPath,'\demo_timeSeq'];
SavePath = [ResPath,'\',INIData.Obs_parameter.Site_name,'_TimeSqeRes.png'];
[FigSet] = TimeSqe_Plotini(Outpara,PosNameList,SavePath);
[FigSet] = PlotFig_ini(FigSet);
PlotFig_res(FigSet);

RWNSinex3(FileStruct,RESData,SetModelMP,INIData,Outpara,ResComPath);
end

