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
        end
    end
    save('FigRes\TimeList.mat',"TimeList");
else
    load('FigRes\TimeList.mat','TimeList');
end
%% Plot the computational efficiency curve
[FigSet] = PlotFig7_Data(TimeList);
[FigSet] = PlotFig_ini(FigSet);
PlotFig_res(FigSet);
end

