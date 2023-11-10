function GNSS_A_Position_Time(SetINIPath)
SetModelMP = ReadSetINI(SetINIPath);
%% 文件读取
[FileStruct] = FilePathFun(SetModelMP);
%% 解算策略及定位结果
ModelList = SetModelMP.Inv_model.AdjGuiModelList;ModelNum = length(ModelList);
TimeList = zeros(FileStruct.FileNum-1,ModelNum);

for TimeIndex = 2:FileStruct.FileNum
    
    for ModelIndex = 1:ModelNum
        SetModelMP.Inv_model.AdjGuiModel = ModelList(ModelIndex);
        t = tic;
        for DataNum = 1:TimeIndex
            [OBSData,RESData(DataNum).SVP,INIData,MP_ENU] = FileInFun(FileStruct,DataNum);
            %1.B样条节点构造
            [RESData(DataNum).knots,MPNum,INIData] = Make_Bspline_knots(OBSData,SetModelMP,INIData);%
            %2.臂长转化
            [RESData(DataNum).OBSData,RESData(DataNum).INIData,RESData(DataNum).MP,RESData(DataNum).MPNum] = ...
                Ant_ATD_Transducer(OBSData,SetModelMP,INIData,MP_ENU,MPNum,RESData(DataNum).SVP,RESData(DataNum).knots);
        end
        % 3.解算
        [ModelT_MP_T,RESData,Qxx] = FixTCalModelT(RESData,SetModelMP);
        TimeList(TimeIndex-1,ModelIndex) = toc(t);
    end
end
save('FigRes\TimeList.mat',"TimeList");
%% 绘制计算效率曲线
[FigSet] = PlotFig6_Data(TimeList);
[FigSet] = PlotFig_ini(FigSet);
PlotFig_res(FigSet);
end

