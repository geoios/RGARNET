function StnPosSeries = File2StnPos(DataFilePath,Tag)
%% From the given file path, filter out the list of files that contain tag identifiers in the file hit %%
DataStruct = FileExtract(DataFilePath,Tag);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Read the files filtered out of the above data 
%% @ReadNSinex is a function that reads a specific file 
DataStruct = FileRead(DataStruct,@ReadNSinex);
%% The data is categorized by station name
StnPosSeries = SotByStn(DataStruct);