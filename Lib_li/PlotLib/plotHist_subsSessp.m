function [stats,y,x] = plotHist_subsSessp(diffProf)
%% 函数说明
%功能：声速剖面误差直方图绘图

%% 功能代码
%向量化
[m,n] = size(diffProf);
array = reshape(diffProf,[1,m*n]);%1行
%绘图
[y,x] = hist(array,10);
stats = [mean(array') std(array')];

