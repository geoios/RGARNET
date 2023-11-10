clear;clc

%% 按照字段提取
name='D:\GARPOS(用于GNSS声学海底定位的分析工具)\data_b311\initcfg\MYGI';
fileFolder=fullfile(name);
dirOutput=dir(fullfile(fileFolder,'*-initcfg.ini'));
fileNames={dirOutput.name};

for i=1:1:length(fileNames)
FilePath=[name,'\',fileNames{i}];
key={['Date(UTC)'],['M01_dPos'],['M03_dPos'],['M04_dPos'],['M05_dPos'],['M11_dPos'],['M12_dPos'],['M13_dPos'],['M14_dPos'],['ATDoffset']};
[value]=Read_Ini_File(FilePath,key);
Par(i).Time=value(1,:);
Par(i).SeafloorPoint=value(2:end-1,:);
Par(i).ATD=value(end,:);
end