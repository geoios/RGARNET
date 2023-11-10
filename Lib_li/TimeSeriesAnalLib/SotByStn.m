function StnPosSeries = SotByStn(DataStruct)
StnNum = 0;
Data = struct;
for i = 1:DataStruct.FileNum
    iFileData  = DataStruct.Data{i};
    iStnNoStr  = iFileData.Site_parameter.Stations;
    iStnPos    = iFileData.Model_parameter.MT_Pos;
    iStnNos    = strsplit(iStnNoStr);
    %% Obs date
    doy     = strsplit(iFileData.Obs_parameter.Datejday,'-');
    year    = str2num(doy{1});
    day     = str2num(doy{2});
    iJD     = doy2jd(year,day);
    JDs(i)  = iJD;
    StnNam  = iFileData.Obs_parameter.Site_name;
    for j=1:length(iStnNos)
       StnNo    = iStnNos{j};
       jFldName = [StnNo '_dPos'];
       jiPos    = getfield(iStnPos,jFldName);
       jiPos    = [jiPos year day iJD];
       if isfield(Data,StnNo)
          jPos  = getfield(Data,StnNo);
          jPos  = [jPos; jiPos];
          Data  = setfield(Data,StnNo,jPos);
       else
          StnNum = StnNum + 1;
          Data   = setfield(Data,StnNo,jiPos);
       end
    end
end
StnPosSeries.StnNum = StnNum;
StnPosSeries.Data   = Data;
StnPosSeries.JDs    = JDs;
StnPosSeries.MidDay = mean(JDs);
StnPosSeries.StnName = StnNam;