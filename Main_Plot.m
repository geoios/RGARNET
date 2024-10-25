clear;clc;close all;FilePath = mfilename('fullpath');cd(fileparts(FilePath));
%% Fig.5 Results of the two-step rigid-array solution, strict rigid-array solution and free-array solution.
clear;clc;close all
[FigSet] = PlotFig4_Data();
[FigSet] = PlotFig_ini(FigSet);

% 【指定数据所在目录】
Wildcard = '\*';
StnName  = 'MYGI';
StnPath  = '.';
% 【观测文件目录】
ObsPath  = [StnPath,'\obsdata\',StnName];  %
ObsTag   = '-obs.csv';
IndexTag = [Wildcard,ObsTag];
FileStruct = FileExtract(ObsPath,IndexTag);
SvpTag  = '-svp.csv';
FileStruct = nTypeFileLink(FileStruct,ObsTag,ObsPath,SvpTag);
% 【配置文件目录】
ConfPath = [StnPath,'\initcfg\',StnName];
ConfTag  = '-initcfg.ini';
FileStruct = nTypeFileLink(FileStruct,ObsTag,ConfPath,ConfTag);
for DataNum = 1:FileStruct.FileNum
    % 【数据准备】
    % 【日本数据文件路径】
    IniFile     = FileStruct.SubFileList{3,DataNum};
    IniData     = ReadNSinex(IniFile);
    % 【获取时间数据】
    TimeData    = IniData.Obs_parameter.DateUTC;
    yymmdd      = split(TimeData,'-');
    time        = [str2num(cell2mat(yymmdd(1))),str2num(cell2mat(yymmdd(2))),str2num(cell2mat(yymmdd(3)))];
    t(DataNum,1)  = datenum(time(1),time(2),time(3));
end
FigSet.t = t;
PlotFig1_res(FigSet)


%% Table 3 Array solution series analysis result
clear;clc;close all
[FigSet] = Table3_Data();
ObsPath = 'obsdata\MYGI';
ConPath = 'initcfg\MYGI';
aEnu = [FigSet.Data{1,1}(:,2) FigSet.Data{2,1}(:,2) FigSet.Data{3,1}(:,2)];
bEnu = [FigSet.Data{1,2}(:,2) FigSet.Data{2,2}(:,2) FigSet.Data{3,2}(:,2)];
cEnu = [FigSet.Data{1,3}(:,2) FigSet.Data{2,3}(:,2) FigSet.Data{3,3}(:,2)];
[V(1,:),Sig(1,:)] = TimeSeriesAnalysis(aEnu,ObsPath,ConPath);
[V(2,:),Sig(2,:)] = TimeSeriesAnalysis(bEnu,ObsPath,ConPath);
[V(3,:),Sig(3,:)] = TimeSeriesAnalysis(cEnu,ObsPath,ConPath);
OutTable3(V,Sig,FigSet.StorgePath);

%% Fig.6. Difference between the two-step rigid-array solution and the strict rigid-array solution.
clear;clc;close all
[FigSet] = PlotFig6_Data();
E_resi = FigSet.Data{1,1}(:,2);
N_resi = FigSet.Data{2,1}(:,2);
U_resi = FigSet.Data{3,1}(:,2);
subplot(1,3,1);
plotHist(E_resi);
xlabel('\fontname{Times new roman}{E(cm)}');
subplot(1,3,2);
plotHist(N_resi);
xlabel('\fontname{Times new roman}{N(cm)}');ylabel('');
subplot(1,3,3);
plotHist(U_resi);
xlabel('\fontname{Times new roman}{U(cm)}');ylabel('');
set(gcf,'Units','centimeter','Position',[5 5 25 10])
print(gcf,'-dpng','-r600',FigSet.StorgePath);

%% Figure.7  Runtime increasing with the remeasurement period number N（Comparison of additional examples）
clear;clc;close all
SetINIPath = 'PlotLib\Settings-prep_TimeCompare.ini';
GNSS_A_Position_Time(SetINIPath)

%% Figure.9 ~ 10
clear;clc;close all
% 
SetINIPath = '.\PlotLib\Settings-prep_TimeSqe_Loose1.ini';
GNSS_A_Position_Cal(SetINIPath,'TimeSqe_Loose_1e-1');
% 
SetINIPath = '.\PlotLib\Settings-prep_TimeSqe_Loose2.ini';
GNSS_A_Position_Cal(SetINIPath,'TimeSqe_Loose_1e-2');
% 
SetINIPath = '.\PlotLib\Settings-prep_TimeSqe_Loose3.ini';
GNSS_A_Position_Cal(SetINIPath,'TimeSqe_Loose_1e-3');


colorlib = {'ob','^m','pc','sg'};
Filename = {'1e-1','1e-2','1e-3'};savename = {'d','c','b'};
fig_size = [0,0,15,5];
StationTime = [2012,2021];
for StaIndex = 1:length(Filename)
    StnName = 'MYGI';
    % plot free-array
    Wildcard = '\*';
    StnPath  = '.';
    % 【观测文件目录】
    ObsPath  = [StnPath,'\obsdata\',StnName];  %
    ObsTag   = '-obs.csv';
    IndexTag = [Wildcard,ObsTag];
    FileStruct = FileExtract(ObsPath,IndexTag);
    SvpTag  = '-svp.csv';
    FileStruct = nTypeFileLink(FileStruct,ObsTag,ObsPath,SvpTag);
    % 【结果文件目录】
    ConfPath = [StnPath,'\initcfg\',StnName];
    ConfTag  = '-initcfg.ini';
    FileStruct = nTypeFileLink(FileStruct,ObsTag,ConfPath,ConfTag);
    % 【结果文件目录】
    ResPath = [StnPath,'\TimeSqe_Loose_',Filename{StaIndex},'\demo_timeSeq\',StnName];
    ResTag  = '-res.dat';
    FileStruct = nTypeFileLink(FileStruct,ObsTag,ResPath,ResTag);

    [S,H,ObsTime_decYear] = deal(NaN(FileStruct.FileNum,1));[StationDate,StationList] = deal(cell(FileStruct.FileNum,1));
    for DataNum = 1:FileStruct.FileNum
        % 【数据准备】
        INIFile     = FileStruct.SubFileList{3,DataNum};
        INIData     = ReadNSinex(INIFile);
        % 【获取阵列类型】
        StationList{DataNum} = INIData.Site_parameter.Stations;
        StationDate{DataNum} = INIData.Obs_parameter.Campaign(1:4);

        % 【日本数据文件路径】
        ResFile     = FileStruct.SubFileList{4,DataNum};
        if isempty(ResFile)
            continue;
        end
        ResData     = ReadNSinex(ResFile);
        % 【获取水平坐标数据】
        PosNameTips = fieldnames(ResData.Model_parameter.MT_Pos);
        PosNum = length(PosNameTips);EachPos = [];
        for i=1:PosNum
            if ~isempty(strfind(PosNameTips{i},'_dPos'))
                mp = getfield(ResData.Model_parameter.MT_Pos,PosNameTips{i});
                EachPos = [EachPos;mp(1:3)];
            end
        end

        % 获取全序列坐标
        EachPosList{DataNum} = EachPos;

        % 计算相应阵列水平面积
        S(DataNum) = polyarea(EachPos(:,1),EachPos(:,2));

        % 计算相应高程变化
        H(DataNum) = mean(EachPos(:,3));

        % 观测时间标签
        ObsTime_ymd = datetime(INIData.Obs_parameter.DateUTC,'InputFormat','yyyy-MM-dd');
        ObsTime_y = year(ObsTime_ymd);
        ObsTime_day = day(ObsTime_ymd, 'dayofyear');
        ObsTime_decYear(DataNum) = ObsTime_y + ObsTime_day / yeardays(ObsTime_y);
    end

    if StaIndex == 1
        Base_S_H = [mean(S),mean(H)];
    end
    %
    index_eff = find( (ObsTime_decYear>StationTime(1) & ObsTime_decYear<StationTime(2)) == 1);

    figure(900+StaIndex)
    AA(StaIndex) = plot(ObsTime_decYear(index_eff),S(index_eff) - Base_S_H(1),colorlib{StaIndex},'MarkerSize',6,'MarkerFaceColor',colorlib{StaIndex}(end));
    FigSet.FontSize = 15;hold on
    set(gca,'FontSize',12,'FontName','Times new roman');
    hXLabel = xlabel('\fontname{Times new roman}{Year}','FontSize',FigSet.FontSize);hold on
    hYLabel = ylabel('\fontname{Times new roman}{area change (m^2)}','FontSize',FigSet.FontSize);
    set(gca, 'FontName', 'Times new roman','FontWeight','bold','tickdir','in','linewidth',1)
    set(gcf,'PaperPositionMode','auto')
    set(gcf, 'PaperPosition', fig_size);
    set(gcf,'unit','centimeters','position',fig_size);
    print(gcf,'-dpng','-r600',['FigRes\Figure_9(',savename{StaIndex},').png']);

    figure(10)
    plot(ObsTime_decYear(index_eff),H(index_eff) - Base_S_H(2),colorlib{StaIndex},'MarkerSize',6,'MarkerFaceColor',colorlib{StaIndex}(end));
    set(gca,'FontSize',12,'FontName','Times new roman');FigSet.FontSize = 15;
    hXLabel = xlabel('\fontname{Times new roman}{Year}','FontSize',FigSet.FontSize);hold on
    hYLabel = ylabel('\fontname{Times new roman}{hight change (m)}','FontSize',FigSet.FontSize);
    set(gca, 'FontName', 'Times new roman','FontWeight','bold','tickdir','in','linewidth',1)
    set(gcf,'PaperPositionMode','auto')
end


% plot free-array
Wildcard = '\*';
StnPath  = '.';
% 【观测文件目录】
ObsPath  = [StnPath,'\obsdata\',StnName];  %
ObsTag   = '-obs.csv';
IndexTag = [Wildcard,ObsTag];
FileStruct = FileExtract(ObsPath,IndexTag);
SvpTag  = '-svp.csv';
FileStruct = nTypeFileLink(FileStruct,ObsTag,ObsPath,SvpTag);
% 【结果文件目录】
ConfPath = [StnPath,'\initcfg\',StnName];
ConfTag  = '-initcfg.ini';
FileStruct = nTypeFileLink(FileStruct,ObsTag,ConfPath,ConfTag);
% 【结果文件目录】
ResPath = [StnPath,'\demo_prep\',StnName];
ResTag  = '-res.dat';
FileStruct = nTypeFileLink(FileStruct,ObsTag,ResPath,ResTag);

[S,H,ObsTime_decYear] = deal(NaN(FileStruct.FileNum,1));[StationDate,StationList] = deal(cell(FileStruct.FileNum,1));
for DataNum = 1:FileStruct.FileNum
    % 【数据准备】
    INIFile     = FileStruct.SubFileList{3,DataNum};
    INIData     = ReadNSinex(INIFile);
    % 【获取阵列类型】
    StationList{DataNum} = INIData.Site_parameter.Stations;
    StationDate{DataNum} = INIData.Obs_parameter.Campaign(1:4);

    % 【日本数据文件路径】
    ResFile     = FileStruct.SubFileList{4,DataNum};
    if isempty(ResFile)
        continue;
    end
    ResData     = ReadNSinex(ResFile);
    % 【获取水平坐标数据】
    PosNameTips = fieldnames(ResData.Model_parameter.MT_Pos);
    PosNum = length(PosNameTips);EachPos = [];
    for i=1:PosNum
        if ~isempty(strfind(PosNameTips{i},'_dPos'))
            mp = getfield(ResData.Model_parameter.MT_Pos,PosNameTips{i});
            EachPos = [EachPos;mp(1:3)];
        end
    end

    % 获取全序列坐标
    EachPosList{DataNum} = EachPos;

    % 计算相应阵列水平面积
    S(DataNum) = polyarea(EachPos(:,1),EachPos(:,2));

    % 计算相应高程变化
    H(DataNum) = mean(EachPos(:,3));

    % 观测时间标签
    ObsTime_ymd = datetime(INIData.Obs_parameter.DateUTC,'InputFormat','yyyy-MM-dd');
    ObsTime_y = year(ObsTime_ymd);
    ObsTime_day = day(ObsTime_ymd, 'dayofyear');
    ObsTime_decYear(DataNum) = ObsTime_y + ObsTime_day / yeardays(ObsTime_y);
end

index_eff = find( (ObsTime_decYear>StationTime(1) & ObsTime_decYear<StationTime(2)) == 1);


figure(904)
AA(StaIndex) = plot(ObsTime_decYear(index_eff),S(index_eff) - Base_S_H(1),colorlib{4},'MarkerSize',6,'MarkerFaceColor',colorlib{4}(end));
FigSet.FontSize = 15;hold on
set(gca,'FontSize',12,'FontName','Times new roman');
hXLabel = xlabel('\fontname{Times new roman}{Year}','FontSize',FigSet.FontSize);hold on
hYLabel = ylabel('\fontname{Times new roman}{area change (m^2)}','FontSize',FigSet.FontSize);
set(gca, 'FontName', 'Times new roman','FontWeight','bold','tickdir','in','linewidth',1)
set(gcf,'PaperPositionMode','auto')
set(gcf, 'PaperPosition', fig_size);
set(gcf,'unit','centimeters','position',fig_size);
print(gcf,'-dpng','-r600','FigRes\Figure_9(a).png');
xlim([2012,2021]);

figure(10)
plot(ObsTime_decYear(index_eff),H(index_eff) - Base_S_H(2),colorlib{4},'MarkerSize',6,'MarkerFaceColor',colorlib{4}(end));

legend('\fontname{Times new roman}{\mu_0^2 = 10^{-1}}','\fontname{Times new roman}{\mu_0^2 = 10^{-2}}',...
    '\fontname{Times new roman}{\mu_0^2 = 10^{-3}}','\fontname{Times new roman}{free-array}',...
    'Box','off','Location','NorthOutside','NumColumns',4,'Position',[0.1261,0.9190,0.7690,0.0941]);
xlim([2012,2021]);
% 设定图幅尺寸
set(gcf, 'PaperPosition', [0,0,15,10]);
set(gcf,'unit','centimeters','position',[0,0,15,10]);
print(gcf,'-dpng','-r600','FigRes\Figure_10_Height_time_series_for_the_free-array_solution_and_resilient_solutions_with_mu_1e-1_1e-2_1e-3.png');

%% Figure.11 The area-height change ratio curve about the logarithmic resilient factor /mu_0^2
% 
SetINIPath = '.\PlotLib\Settings-prep_TimeSqe_Loose.ini';
GNSS_A_Position_Cal(SetINIPath,'TimeSqe_Loose');
%
StationName = 'MYGI';
Wildcard = '\*';
StnPath  = '.';
colorList = {'-^b','-^r'};
StationTime = [2014,2020];
% 【观测文件目录】
ObsPath  = [StnPath,'\obsdata\',StnName];  %
ObsTag   = '-obs.csv';
IndexTag = [Wildcard,ObsTag];
FileStruct = FileExtract(ObsPath,IndexTag);
SvpTag  = '-svp.csv';
FileStruct = nTypeFileLink(FileStruct,ObsTag,ObsPath,SvpTag);
% 【结果文件目录】
ConfPath = [StnPath,'\initcfg\',StnName];
ConfTag  = '-initcfg.ini';
FileStruct = nTypeFileLink(FileStruct,ObsTag,ConfPath,ConfTag);
% 【结果文件目录】
ResPath = [StnPath,'\TimeSqe_Loose\demo_timeSeq\',StnName];
ResTag  = '-res.dat';
FileStruct = nTypeFileLink(FileStruct,ObsTag,ResPath,ResTag);

[S,H,ObsTime_decYear] = deal(NaN(FileStruct.FileNum,1));[StationDate,StationList] = deal(cell(FileStruct.FileNum,1));
for DataNum = 1:FileStruct.FileNum
    % 【数据准备】
    INIFile     = FileStruct.SubFileList{3,DataNum};
    INIData     = ReadNSinex(INIFile);
    % 【获取阵列类型】
    StationList{DataNum} = INIData.Site_parameter.Stations;
    StationDate{DataNum} = INIData.Obs_parameter.Campaign(1:4);

    % 【日本数据文件路径】
    ResFile     = FileStruct.SubFileList{4,DataNum};
    if isempty(ResFile)
        continue;
    end
    ResData     = ReadNSinex(ResFile);
    % 【获取水平坐标数据】
    PosNameTips = fieldnames(ResData.Model_parameter.MT_Pos);
    PosNum = length(PosNameTips);EachPos = [];
    for i=1:PosNum
        if ~isempty(strfind(PosNameTips{i},'_dPos'))
            mp = getfield(ResData.Model_parameter.MT_Pos,PosNameTips{i});
            EachPos = [EachPos;mp(1:3)];
        end
    end

    % 获取全序列坐标
    EachPosList{DataNum} = EachPos;

    % 计算相应阵列水平面积
    S(DataNum) = polyarea(EachPos(:,1),EachPos(:,2));

    % 计算相应高程变化
    H(DataNum) = mean(EachPos(:,3));

    % 观测时间标签
    ObsTime_ymd = datetime(INIData.Obs_parameter.DateUTC,'InputFormat','yyyy-MM-dd');
    ObsTime_y = year(ObsTime_ymd);
    ObsTime_day = day(ObsTime_ymd, 'dayofyear');
    ObsTime_decYear(DataNum) = ObsTime_y + ObsTime_day / yeardays(ObsTime_y);
end

StaionTab = tabulate(StationList);
StaEpochIndex = cumsum([0,StaionTab{:,2}]);

% 筛选非零元素
index = find(isnan(S));
UseIndex = 1:FileStruct.FileNum;UseIndex(index)=[];
TabList_eff = [];
for i = 1:size(StaionTab,1)
    TabList = find(strcmp(StaionTab{i,1},StationList)==1);
    TabList = TabList(~isnan(S(TabList)));
    [~,index_min] = min(S(TabList));
    % 筛选数据
    TabList_win_area = find((ObsTime_decYear(TabList)> StationTime(1) & ObsTime_decYear(TabList)<StationTime(2))==1);
    % 有效保存
    TabList_eff = [TabList_eff;TabList(TabList_win_area)];
end

% 参考值、
Rg = 6378140;
K_Ref_mean = 2/Rg * S(TabList(index_min));

Base_S_H = [S(TabList(index_min)),H(TabList(index_min))];

Mu3 = [0.001,0.005,0.01,0.05,0.1,1,3.0104,5,10,50,100,500,1000]; %
[Value_Min2,Value_Min3] = deal(zeros(1,length(Mu3)));
for Loop = 1:length(Mu3)
    % 根据最小索引序列重新解算确定超 参数
    [Value_Min2(Loop),Value_Min3(Loop)] = Cal_Earth_adhere_dK(log10(Mu3(Loop)),TabList_eff,StnName,StationTime,K_Ref_mean,Base_S_H); % ,Value_Min4{Loop}
end

% 绘制因子变化结果
figure(234)
loglog(Mu3,abs(Value_Min2),colorList{1},'MarkerSize',6,'MarkerFaceColor',colorList{1}(3));hold on
grid on
FigSet.FontSize = 15;
set(gca,'FontSize',FigSet.FontSize,'FontName','Times new roman');
hXLabel = xlabel('\fontname{Times new roman}{HyperParameters \mu_0^2}','FontSize',FigSet.FontSize);
hYLabel = ylabel('\fontname{Times new roman}{dS/dU}','FontSize',FigSet.FontSize);
set(gca, 'FontName', 'Times new roman','FontWeight','bold','tickdir','in','linewidth',1)
set(gcf,'PaperPositionMode','auto')

plot([Mu3(1),Mu3(end)],[0.4733,0.4733],'-m','LineWidth',2);
text(10^2,1,['y = 0.4733'],'Color','m','FontSize',10,'FontName','Times new roman');
legend('\fontname{Times new roman}{area-height change ratio}','\fontname{Times new roman}{y = \itK_0·\itS_0}',...
    'Box','on','Location','NorthOutside','NumColumns',3);
print(gcf,'-dpng','-r600','FigRes\Figure_11_The_area-height_change_ratio_curve_about_the_logarithmic_resilient_factor_mu2_0.png');


%% Fig.12 The area and height changes of the seafloor geodetic array with /mu^2_0 = 3.0104

MuList = 3.0104;
StnName = 'MYGI';
savefile = ['.\',StnName,'\',StnName,'_',num2str(MuList),'.mat'];

load(savefile,'TabList_eff','RESData_tmp','RESData','StationTime','Base_S_H','K_Ref_mean');

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
index_eff = find( (ObsTime_decYear>StationTime(1) & ObsTime_decYear<StationTime(2)) == 1);
dH_PolyMP = polyfit(ObsTime_decYear, H - Base_S_H(2), 1);
dS_PolyMP = polyfit(ObsTime_decYear(index_eff), S(index_eff) - Base_S_H(1), 1);


% 绘制双轴图 左边蓝色为面积变化，右边红色为高程变化
figure(365)
colororder({'b','r'})
yyaxis left
a = plot(ObsTime_decYear(index_eff), S(index_eff)- Base_S_H(1),'ob','MarkerSize',6,'MarkerFaceColor','b');hold on
% 时间散点
S_interp_time = ObsTime_decYear(index_eff);
S_line_2point = polyval(dS_PolyMP,S_interp_time);
plot(S_interp_time,S_line_2point,'-b','LineWidth',1);
set(gca,'FontSize',12,'FontName','Times new roman');FigSet.FontSize = 15;
hYLabel = ylabel('\fontname{Times new roman}{area change (m^2)}','FontSize',FigSet.FontSize);
set(gca, 'FontName', 'Times new roman','FontWeight','bold','tickdir','in','linewidth',1)
set(gcf,'PaperPositionMode','auto');

yyaxis right
plot(ObsTime_decYear, H - Base_S_H(2),'^r','MarkerSize',6,'MarkerFaceColor','r');hold on
H_interp_time = ObsTime_decYear;
H_line_2point = polyval(dH_PolyMP,H_interp_time);
b = plot(H_interp_time,H_line_2point,'-r','LineWidth',1);
set(gca,'FontSize',12,'FontName','Times new roman');FigSet.FontSize = 15;
hXLabel = xlabel('\fontname{Times new roman}{Year}','FontSize',FigSet.FontSize);hold on
hYLabel = ylabel('\fontname{Times new roman}{hight change (m)}','FontSize',FigSet.FontSize);
set(gca, 'FontName', 'Times new roman','FontWeight','bold','tickdir','in','linewidth',1)
set(gcf,'PaperPositionMode','auto');
% K 值
K = dS_PolyMP(1)/dH_PolyMP(1);

figure(365)
yyaxis left
text(2015,116.9,['\it{dS} = ',num2str(dS_PolyMP(1),'%4.4f'),'t + ',num2str(dS_PolyMP(2),'%4.2f')],'Color','blue','FontSize',10,'FontName','Times new roman');
yyaxis right
text(2018,-0.15,['\it{dU} = ',num2str(dH_PolyMP(1),'%4.4f'),'t + ',num2str(dH_PolyMP(2),'%4.2f')],'Color','red','FontSize',10,'FontName','Times new roman');

dS_PolyMP(1)/dH_PolyMP(1)
print(gcf,'-dpng','-r600','FigRes\Figure_12_The_area_and_height_changes_of_the_seafloor_geodetic_array_with_mu2_3.0104.png');



%% Table 4 Array solution series analysis result
clear;clc;close all
[FigSet] = Table4_Data();
ObsPath = 'obsdata\MYGI';
ConPath = 'initcfg\MYGI';
aEnu = [FigSet.Data{1,1}(:,2) FigSet.Data{2,1}(:,2) FigSet.Data{3,1}(:,2)];
bEnu = [FigSet.Data{1,2}(:,2) FigSet.Data{2,2}(:,2) FigSet.Data{3,2}(:,2)];
[V(1,:),Sig(1,:)] = TimeSeriesAnalysis(aEnu,ObsPath,ConPath);
[V(2,:),Sig(2,:)] = TimeSeriesAnalysis(bEnu,ObsPath,ConPath);
OutTable4(V,Sig,FigSet.StorgePath);