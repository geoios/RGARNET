function [Japtime] = ReadJapTime(timeflag,FileStruct)
%% 作用：读取时间信息作为绘制时序图的x�?
% case0：作为x轴的时间标签，用来绘制时序图，形式如"Month/Day/Year"
% case1：形式如"1104"
switch timeflag
    case 0
        for i = 1:FileStruct.FileNum
            timeFile     = FileStruct.SubFileList{3,i};     % 配置文件路径
            TimeData     = ReadNSinex(timeFile);            % 配置文件中的数据
            timedata     = TimeData.Obs_parameter.DateUTC;  % 配置文件中的时间数据
            ymd          = split(timedata,'-');             % 将时间的年月日分�?组成1*3的矩�?
            Japtime(i,:) = [str2num(cell2mat(ymd(1))),...   % 得到某个站所有年份的时间信息
                            str2num(cell2mat(ymd(2))),...
                            str2num(cell2mat(ymd(3)))];
        end
    case 1
        for i = 1:FileStruct.FileNum
            timeFile     = FileStruct.SubFileList{3,i};     % 配置文件路径
            TimeData     = ReadNSinex(timeFile);            % 配置文件中的数据
            timedata     = TimeData.Obs_parameter.Campaign; % 配置文件中的时间和船只信�?
            ymd          = split(timedata,'.');             % 将时间和船只信息分开
            Japtime(i,:) = str2num(cell2mat(ymd(1)));       % 得到某个站所有年份的时间信息
        end
end