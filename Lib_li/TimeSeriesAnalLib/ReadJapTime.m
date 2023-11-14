function [Japtime] = ReadJapTime(timeflag,FileStruct)
switch timeflag
    case 0
        for i = 1:FileStruct.FileNum
            timeFile     = FileStruct.SubFileList{3,i}; 
            TimeData     = ReadNSinex(timeFile);            
            timedata     = TimeData.Obs_parameter.DateUTC;  
            ymd          = split(timedata,'-');             
            Japtime(i,:) = [str2num(cell2mat(ymd(1))),...   
                            str2num(cell2mat(ymd(2))),...
                            str2num(cell2mat(ymd(3)))];
        end
    case 1
        for i = 1:FileStruct.FileNum
            timeFile     = FileStruct.SubFileList{3,i};   
            TimeData     = ReadNSinex(timeFile);          
            timedata     = TimeData.Obs_parameter.Campaign; 
            ymd          = split(timedata,'.'); 
            Japtime(i,:) = str2num(cell2mat(ymd(1)));
        end
end