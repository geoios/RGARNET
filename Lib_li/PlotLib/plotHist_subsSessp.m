function [stats,y,x] = plotHist_subsSessp(diffProf)
%% ����˵��
%���ܣ������������ֱ��ͼ��ͼ

%% ���ܴ���
%������
[m,n] = size(diffProf);
array = reshape(diffProf,[1,m*n]);%1��
%��ͼ
[y,x] = hist(array,10);
stats = [mean(array') std(array')];

