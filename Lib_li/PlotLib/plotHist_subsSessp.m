function [stats,y,x] = plotHist_subsSessp(diffProf)
%% Functional codes
% Vectorization
[m,n] = size(diffProf);
array = reshape(diffProf,[1,m*n]);
% drawing
[y,x] = hist(array,10);
stats = [mean(array') std(array')];

