%%������������ձ�����ת�����Ŷӱ�׼��ʽ
clear all;close all;clc
%% ��ȡ��ǰ�ļ�·��
ScriptPath = mfilename('C:\Users\asus\Desktop\standard');      % �ű�λ��
[FilePath] = fileparts(ScriptPath);      % �ļ���λ��

%% ��ȡ�ļ����������ļ���
Path = FilePath;                                    % �������ݴ�ŵ��ļ���·��
File = dir(fullfile(Path,'D:\GARPOS(����GNSS��ѧ���׶�λ�ķ�������)\garpos-master\sample\demo_prep\SAGA\*-obs.csv'));          % ��ʾ�ļ��������з���׺��Ϊ-obs.csv�ļ���������Ϣ
FileNames = {File.name};
filenames=FileNames';                               % ��ȡ����׺��Ϊ-obs.csv�������ļ����ļ�����ת��Ϊn��1��
FileFolder={File.folder};
filefolder=FileFolder';                             % ��ȡ����׺��Ϊ-obs.csv�������ļ���·����ת��Ϊn��1��

Length_Names = size(File,1);                        % ��ȡ����ȡ�����ļ��ĸ���

%%���ζ�ȡcsv���ݽ��з���
%%���㷢��ʱ�̵�UTC
for M=1:1:Length_Names
    filename=FileNames{M};
    pathname=FileFolder{M};
    name=fullfile(FileFolder{M},'\',FileNames{M});%��ȡcsv�ļ�·��������
    data=readtable(name);%��ȡcsv�ļ�
    ResiTT=data.ResiTT;
    figure
    plot(1:length(ResiTT),ResiTT);
    xlabel('��Ԫ��');
    ylabel('ʱ��в�/s');  
end