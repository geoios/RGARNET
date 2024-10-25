function GNSS_A_Position_Cal_Tab2(SetINIPath,Mu)

for MuIndex = 1:length(Mu)
    ResComPath = ['TimeSqe_Loose_constrained',num2str(Mu(MuIndex),'%6.2e')];
    SetModelMP = ReadSetINI(SetINIPath);
    SetModelMP.HyperParameters.Mu3 = Mu(MuIndex);
    % File Reading
    [FileStruct] = FilePathFun(SetModelMP);
    % Solution strategy and positioning results
    for DataNum = 1:FileStruct.FileNum
        [OBSData,RESData(DataNum).SVP,INIData,MP_ENU] = FileInFun(FileStruct,DataNum);
        %1.B-spline knote Interval Generation
        [RESData(DataNum).knots,MPNum,INIData] = Make_Bspline_knots(OBSData,SetModelMP,INIData);%
        %2.Coordinate System Conversion(ATD offset)
        [RESData(DataNum).OBSData,RESData(DataNum).INIData,RESData(DataNum).MP,RESData(DataNum).MPNum] = ...
            Ant_ATD_Transducer(OBSData,SetModelMP,INIData,MP_ENU,MPNum,RESData(DataNum).SVP,RESData(DataNum).knots);
    end
    switch SetModelMP.Inv_model.DirOffset
        case 0
            TimSqeList = zeros(FileStruct.FileNum,6);
            for DataNum = 1:FileStruct.FileNum
                % 3. Solving
                [ModelT_MP_T,ModelT_MP_T_OBSData,Qxx,sigma0] = TCalModelT(RESData(DataNum).OBSData,SetModelMP,RESData(DataNum).INIData,...
                    RESData(DataNum).SVP,RESData(DataNum).MP,RESData(DataNum).MPNum,RESData(DataNum).knots);
                % 4.Output Result Files
                TimSqeList(DataNum,:) = WriteRes(FileStruct,ModelT_MP_T,ModelT_MP_T_OBSData,RESData(DataNum).INIData,...
                    RESData(DataNum).MPNum,Qxx,sigma0,RESData(DataNum).SVP,DataNum,SetModelMP,ResComPath);
            end
            if INIData.FixModel && DataNum ~= 1
                % Output Seafloor Station Offset
                WriteSeq2(TimSqeList,FileStruct,SetModelMP,RESData,ResComPath);
            end
        case 1
            % 3.Solving
            [ModelT_MP_T,RESData,Qxx] = FixTCalModelT(RESData,SetModelMP);
            % 4.Output Result Files
            WriteRes2(FileStruct,ModelT_MP_T,RESData,SetModelMP,ResComPath,Qxx);
            % 5.Output Seafloor Station Offset
            WriteSeq(FileStruct,ModelT_MP_T,RESData,SetModelMP,ResComPath);
    end
end

end