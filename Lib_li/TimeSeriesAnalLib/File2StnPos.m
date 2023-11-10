function StnPosSeries = File2StnPos(DataFilePath,Tag)
%% 从给定的文件路径中，筛选出文件命中含有Tag标识的文件列表 %%
DataStruct = FileExtract(DataFilePath,Tag);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%读取上述数据筛选出的文件 
%% @ReadNSinex 为读取特定文件的函数 
DataStruct = FileRead(DataStruct,@ReadNSinex);
%% 数据按测站名分类
StnPosSeries = SotByStn(DataStruct);