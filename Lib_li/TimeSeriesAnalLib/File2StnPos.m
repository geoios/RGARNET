function StnPosSeries = File2StnPos(DataFilePath,Tag)
%% �Ӹ������ļ�·���У�ɸѡ���ļ����к���Tag��ʶ���ļ��б� %%
DataStruct = FileExtract(DataFilePath,Tag);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%��ȡ��������ɸѡ�����ļ� 
%% @ReadNSinex Ϊ��ȡ�ض��ļ��ĺ��� 
DataStruct = FileRead(DataStruct,@ReadNSinex);
%% ���ݰ���վ������
StnPosSeries = SotByStn(DataStruct);