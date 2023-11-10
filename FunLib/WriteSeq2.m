function WriteSeq2(TimSqeList,FileStruct,SetModelMP,RESData,ResComPath)
for DataNum = 1:FileStruct.FileNum
    PosNamesplit = split(RESData(DataNum).INIData.Obs_parameter.Campaign, '.');
    PosNameList{DataNum} = PosNamesplit{1};
end
INIData = RESData(DataNum).INIData;
ResPath = [ResComPath,'\',INIData.FixSave];
SavePath = [ResPath,'\',INIData.Obs_parameter.Site_name,'_TimeSqeRes.png'];
[FigSet] = TimeSqe_Plotini(TimSqeList,PosNameList,SavePath);
[FigSet] = PlotFig_ini(FigSet);
PlotFig_res(FigSet);

RWNSinex3(FileStruct,RESData,SetModelMP,INIData,TimSqeList,ResComPath);

end

