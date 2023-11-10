function [A L t] = LinJac(StnPosSeries,idx)
% idx = 1-->N; 2-->E
%% 所有测站数据合并
Data     = StnPosSeries.Data;
StnNames = fieldnames(Data);
StnNum   = StnPosSeries.StnNum; %% station number
MidDay   = StnPosSeries.MidDay;

A = [];      % x0 
TimTag = []; %% dt 
L = [];
for i=1:StnNum
    iName   = StnNames{i};
    iData   = Data.(iName);% 方式三
    iPotNum = size(iData,1); %% point number
    
    %% x0
    iA      = [zeros(iPotNum,i-1) ones(iPotNum,1) zeros(iPotNum,StnNum-i)];
    A       = [A;iA];
    %% dt
    iTimTag = iData(:,end) - MidDay;
    TimTag  = [TimTag ; iTimTag];
    %% obs
    iL      = iData(:,idx); %% idx = 1-->N; 2-->E
    L       = [L; iL];
    %% 绘图
    %iL_mean = mean(iL)
end
%% 转化为年
TimTag = TimTag/365;
B = [TimTag A L];
B = sortrows(B,'ascend');

A = B(:,1:end-1);
L = B(:,end);
t = B(:,1);