%%将初步处理的日本数据转换成团队标准格式
clear all;close all;clc
%% 获取当前文件路径
ScriptPath = mfilename('C:\Users\asus\Desktop\standard');      % 脚本位置
[FilePath] = fileparts(ScriptPath);      % 文件夹位置

%% 获取文件夹下所有文件名
Path = FilePath;                                    % 设置数据存放的文件夹路径
File = dir(fullfile(Path,'D:\GARPOS(用于GNSS声学海底定位的分析工具)\garpos-master\sample\demo_prep\SAGA\*-obs.csv'));          % 显示文件夹下所有符合缀名为-obs.csv文件的完整信息
FileNames = {File.name};
filenames=FileNames';                               % 提取符合缀名为-obs.csv的所有文件的文件名，转换为n行1列
FileFolder={File.folder};
filefolder=FileFolder';                             % 提取符合缀名为-obs.csv的所有文件的路径，转换为n行1列

Length_Names = size(File,1);                        % 获取所提取数据文件的个数

%%依次读取csv数据进行分析
%%计算发射时刻的UTC
for M=1:1:Length_Names
    filename=FileNames{M};
    pathname=FileFolder{M};
    name=fullfile(FileFolder{M},'\',FileNames{M});%获取csv文件路径及名称
    data=readtable(name);%读取csv文件
    ResiTT=data.ResiTT;
    figure
    plot(1:length(ResiTT),ResiTT);
    xlabel('历元数');
    ylabel('时间残差/s');  
end