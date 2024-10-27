function [K,dK] = Cal_Earth_adhere_dK(Mu3,TabList_eff,StnName,StationTime,K_Ref_mean,Base_S_H)

% 根据最小索引序列重新解算确定超参数
if ~exist(['.\',StnName],'dir')
	mkdir(['.\',StnName]);
end
% 判断保存文件是否存在
savefile = ['.\',StnName,'\',StnName,'_',num2str(10^Mu3),'.mat'];
if exist(savefile)
    load(savefile);
else
    
    RESData = struct();
    SetINIPath = ['.\PlotLib\Settings-prep_TimeSqe_Loose.ini'];
    SetModelMP = ReadSetINI(SetINIPath);
    
    SetModelMP.HyperParameters.Mu3 = 10^Mu3;
    % 文件读取
    [FileStruct] = FilePathFun(SetModelMP);
    % 解算策略及定位结果
    for DataNum = 1:length(TabList_eff)
        DataNum1 = TabList_eff(DataNum);
        [OBSData,RESData(DataNum).SVP,INIData,MP_ENU] = FileInFun(FileStruct,DataNum1);
        %1.B样条节点构造
        [RESData(DataNum).knots,MPNum,INIData] = Make_Bspline_knots(OBSData,SetModelMP,INIData);%
        %2.臂长转化
        [RESData(DataNum).OBSData,RESData(DataNum).INIData,RESData(DataNum).MP,RESData(DataNum).MPNum] = ...
            Ant_ATD_Transducer(OBSData,SetModelMP,INIData,MP_ENU,MPNum,RESData(DataNum).SVP,RESData(DataNum).knots);
        
    end
    % 3.解算
    [~,RESData_tmp] = FixTCalModelT(RESData,SetModelMP);
    save(savefile);
end

[S,H,ObsTime_decYear] = deal(NaN(length(TabList_eff),1));StationList = cell(length(TabList_eff),1);
for DataNum = 1:length(TabList_eff)
    MP_tmp = RESData_tmp(DataNum).MP;
    MPNum_tmp = RESData_tmp(DataNum).MPNum;
    EachPos = MP_tmp(1:MPNum_tmp(1));
    EachPos = reshape(EachPos,[3,length(EachPos)/3])';

    % 计算相应阵列水平面积
    S(DataNum) = polyarea(EachPos(:,1),EachPos(:,2));

    % 计算相应高程变化
    H(DataNum) = mean(EachPos(:,3));

    % 观测时间标签
    ObsTime_ymd = datetime(RESData(DataNum).INIData.Obs_parameter.DateUTC,'InputFormat','yyyy-MM-dd');
    ObsTime_y = year(ObsTime_ymd);
    ObsTime_day = day(ObsTime_ymd, 'dayofyear');
    ObsTime_decYear(DataNum) = ObsTime_y + ObsTime_day / yeardays(ObsTime_y);
end


% % 选取StationTime时间段内
index_eff = find( (ObsTime_decYear>StationTime(1) & ObsTime_decYear<StationTime(2)) == 1);
% 拟合  dH 线性变化
dH_PolyMP = polyfit(ObsTime_decYear(index_eff), H(index_eff) - Base_S_H(2), 1);
% 拟合  dS 线性变化
dS_PolyMP = polyfit(ObsTime_decYear(index_eff), S(index_eff) - Base_S_H(1), 1);

K = dS_PolyMP(1)/dH_PolyMP(1);

% 拟合值与参考插值
dK = abs(K_Ref_mean - K);



end

