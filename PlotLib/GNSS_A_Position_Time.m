function GNSS_A_Position_Time(SetINIPath)
if ~exist('FigRes\TimeList.mat','file')
    SetModelMP = ReadSetINI(SetINIPath);
    %% File reads
    [FileStruct] = FilePathFun(SetModelMP);
    %% Solve the strategy and locate the results
    ModelList = SetModelMP.Inv_model.AdjGuiModelList;ModelNum = length(ModelList);
    TimeList = zeros(FileStruct.FileNum-1,ModelNum);
    
    for TimeIndex = 2:FileStruct.FileNum
        
        for ModelIndex = 1:ModelNum
            SetModelMP.Inv_model.AdjGuiModel = ModelList(ModelIndex);
            t = tic;
            for DataNum = 1:TimeIndex
                [OBSData,RESData(DataNum).SVP,INIData,MP_ENU] = FileInFun(FileStruct,DataNum);
                %1.B-spline knots construction
                [RESData(DataNum).knots,MPNum,INIData] = Make_Bspline_knots(OBSData,SetModelMP,INIData);%
                %2.Coordinate conversion
                [RESData(DataNum).OBSData,RESData(DataNum).INIData,RESData(DataNum).MP,RESData(DataNum).MPNum] = ...
                    Ant_ATD_Transducer(OBSData,SetModelMP,INIData,MP_ENU,MPNum,RESData(DataNum).SVP,RESData(DataNum).knots);
            end
            % 3.Solve
            [ModelT_MP_T,RESData,Qxx] = FixTCalModelT(RESData,SetModelMP);
            TimeList(TimeIndex-1,ModelIndex) = toc(t);
            save(['FigRes\TimeListRes\AdjGuiModel_',num2str(SetModelMP.Inv_model.AdjGuiModel),'_CumsumStaNum_',num2str(TimeIndex),'.mat']);
        end
    end
    save('FigRes\TimeList.mat',"TimeList");
else
    deltaX = zeros(28-2,1);
    for TimeIndex = 2:28
        MPPos = [];
        for ModelIndx = 1:3:4
            load(['FigRes\TimeListRes\AdjGuiModel_',num2str(ModelIndx),'_CumsumStaNum_',num2str(TimeIndex),'.mat'])
            % Gain Position
            Num_tmp = 0;MPNumPosList = [];
            for Index = 1:TimeIndex
                MPNum = RESData(Index).MPNum;
                MPNumPosList = [MPNumPosList,Num_tmp + 1:Num_tmp + MPNum(1)];
                Num_tmp = Num_tmp + MPNum(end);
            end
            MPPos = [MPPos;ModelT_MP_T(MPNumPosList)];
        end
        deltaX(TimeIndex - 1) = norm(MPPos(1,:) - MPPos(2,:));
    end
    load('FigRes\TimeList.mat','TimeList');
end
%% Plot the computational efficiency curve
[FigSet] = PlotFig7_Data(TimeList,deltaX);
[FigSet] = PlotFig_ini(FigSet);
PlotFig_res(FigSet);
end

