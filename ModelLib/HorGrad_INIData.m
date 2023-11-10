function [FigSet] = HorGrad_INIData(FileName)
load(FileName);
if length(MPNum)>4
    Model = 2;
else
    Model = 1;
end
if MPNum(2)~=0
    Model2 = 3;
end
FileStruct.FileNum = 3;
%% 原始水平梯度
HorGridE = 0.1;HorGridN = 0;
GridT = ModelT_MP_T(MPNum(1)+1:MPNum(2));
GridE_MP_Ray = ModelT_MP_T(MPNum(2)+1:MPNum(3));
GridN_MP_Ray = ModelT_MP_T(MPNum(3)+1:MPNum(4));
if Model == 2
    GridE_MP_Vessel = ModelT_MP_T(MPNum(4)+1:MPNum(5));
    GridN_MP_Vessel = ModelT_MP_T(MPNum(5)+1:MPNum(6));
end
X = OBSData.ST;
Num = length(X);GradT = zeros(Num,1);
GradE_T_Ray = zeros(Num,1);GradN_T_Ray = zeros(Num,1);
GradE_T_Vessel = zeros(Num,1);GradN_T_Vessel = zeros(Num,1);
for i = 1:Num
    if Model2 ==3
        [GradT(i)] = Bspline_Function(X(i),GridT,knots{1},3,[1,4,6,4],2);
    end
    [GradE_T_Ray(i)] = Bspline_Function(X(i),GridE_MP_Ray,knots{2},3,[1,4,6,4],2);
    [GradN_T_Ray(i)] = Bspline_Function(X(i),GridN_MP_Ray,knots{3},3,[1,4,6,4],2);
    if Model == 2
        [GradE_T_Vessel(i)] = Bspline_Function(X(i),GridE_MP_Vessel,knots{4},3,[1,4,6,4],2);
        [GradN_T_Vessel(i)] = Bspline_Function(X(i),GridN_MP_Vessel,knots{5},3,[1,4,6,4],2);
    end
end

%% 绘制数据
FigSet.PlotModel = 'line';FigSet.SubplotModel = 'subplot';FigSet.SubComb  = [3,1];
switch SetModelMP.Inv_model.GradModel
    case 1
        switch FigSet.SubplotModel
            case 'solo'
                FigSet.Data{1} = [X,HorGridE*ones(Num,1)];
                FigSet.Data{2} = [X,HorGridN*ones(Num,1)];
                FigSet.Data{3} = [X,GradE_T_Ray*INIData.scale*INIData.V0];
                FigSet.Data{4} = [X,GradN_T_Ray*INIData.scale*INIData.V0];
                if Model == 2
                    FigSet.Data{5} = [X,GradE_T_Vessel*INIData.scale*INIData.V0];
                    FigSet.Data{6} = [X,GradN_T_Vessel*INIData.scale*INIData.V0];
                end
                if Model == 2 && Model2 == 3
                    FigSet.Data{7} = [X,GradT*INIData.scale*INIData.V0];
                elseif Model == 1 && Model2 == 3
                    FigSet.Data{5} = [X,GradT*INIData.scale*INIData.V0];
                end
            case 'subplot'
                FigSet.Data{1,1} = [X,GradT*INIData.scale*INIData.V0];
                FigSet.Data{2,1} = [X,GradE_T_Ray*INIData.scale*INIData.V0];
                FigSet.Data{2,2} = [X,GradN_T_Ray*INIData.scale*INIData.V0];
                if Model == 2
                    FigSet.Data{3,1} = [X,GradE_T_Vessel*INIData.scale*INIData.V0];
                    FigSet.Data{3,2} = [X,GradN_T_Vessel*INIData.scale*INIData.V0];
                end
        end
        
                % 点型
        switch FigSet.SubplotModel
            case 'solo'
                if Model == 2 && Model2 ~= 3
                    FigSet.LineType = {'-r','-b','--r','--b','-.r','-.b'};
                elseif Model == 2 && Model2 == 3
                    FigSet.LineType = {'-r','-b','--r','--b','-.r','-.b','--g'};
                elseif Model == 1 && Model2 == 3
                    FigSet.LineType = {'-r','-b','--r','--b','--g'};
                else
                    FigSet.LineType = {'-r','-b','--r','--b'};
                end
            case 'subplot'
                switch FileStruct.FileNum
                    case 1
                        if Model == 2
                            FigSet.LineType = {'-g','-r','--r','-.r','-b','--b','-.b'};
                        else
                            FigSet.LineType = {'-g','-r','--r','-b','--b'};
                        end
                    case 35
                        FigSet.LineType = {'-g','-r','-b'};
                end
        end
        
        switch FigSet.SubplotModel
            case 'solo'
                % 坐标轴
                FigSet.xlabelName = '观测历元';
                FigSet.ylabelName = '水平梯度（m/s/m）';
                FigSet.Label.FontSize = 12;
            case 'subplot'
                switch FileStruct.FileNum
                    case 1
                        FigSet.xlabelName ={'观测历元','观测历元','观测历元'};
                        FigSet.ylabelName = {'/fT变化（m/s）','E水平（m/s/m）','N水平（m/s/m）'};
                        FigSet.Label.FontSize = 12;
                    case 35
                        FigSet.xlabelName ={'观测历元','观测历元','观测历元'};
                        FigSet.ylabelName = {'\fontname{Times new roman}{\itK_t(m/s)}','\fontname{Times new roman}{\itK_e(m/s/km)}','\fontname{Times new roman}{\itK_n(m/s/km)}'};
                        FigSet.Label.FontSize = 15;
                end
        end
        % 图例
        switch FigSet.SubplotModel
            case 'solo'
                if Model == 2 && Model2 ~= 3
                    FigSet.legendName = {'仿真梯度E','仿真梯度N','解算梯度E-Ray','解算梯度N-Ray','解算梯度E-Vel','解算梯度N-Vel'};
                elseif Model == 2 && Model2 == 3
                    FigSet.legendName = {'仿真梯度E','仿真梯度N','解算梯度E-Ray','解算梯度N-Ray','解算梯度E-Vel','解算梯度N-Vel','计算梯度T'};
                elseif Model == 1 && Model2 == 3
                    FigSet.legendName = {'仿真梯度E','仿真梯度N','解算梯度E','解算梯度N','计算梯度T'};
                else
                    FigSet.legendName = {'仿真梯度E','仿真梯度N','解算梯度E','解算梯度N'};
                end
            case 'subplot'
                switch FileStruct.FileNum
                    case 1
                        if Model == 2
                            FigSet.legendName = {'T','';'P_E','P_N';'X_E','X_N'};
                        else
                            FigSet.legendName = {'计算梯度T','';'仿真梯度E','解算梯度E-Ray';'仿真梯度N','解算梯度N-Ray'};
                        end
                    case 35
                        
                end
        end
        FigSet.Frame = 'grid';
        
        
    case 2
        switch FigSet.SubplotModel
            case 'solo'
                FigSet.Data{1} = [X,HorGridE*ones(Num,1)];
                FigSet.Data{2} = [X,HorGridN*ones(Num,1)];
                FigSet.Data{3} = [X,GradE_T_Ray*10^3];
                FigSet.Data{4} = [X,GradN_T_Ray*10^3];
                if Model == 2 && Model2 == 3
                    FigSet.Data{7} = [X,GradT];
                elseif Model == 1 && Model2 == 3
                    FigSet.Data{5} = [X,GradT];
                end
                
            case 'subplot'
                switch FileStruct.FileNum
                    case 1
                        FigSet.Data{1,1} = [X,GradT];
                        FigSet.Data{2,1} = [X,HorGridE*ones(Num,1)];
                        FigSet.Data{2,2} = [X,GradE_T_Ray*10^3];
                        
                        FigSet.Data{3,1} = [X,HorGridN*ones(Num,1)];
                        FigSet.Data{3,2} = [X,GradN_T_Ray*10^3];
                    case 3
                        FigSet.Data{1,1} = [X,GradT];
                        FigSet.Data{2,1} = [X,GradE_T_Ray*10^3];
                        FigSet.Data{2,2} = [X,GradN_T_Ray*10^3];
                        FigSet.Data{3,1} = [X,GradE_T_Vessel*10^3];
                        FigSet.Data{3,2} = [X,GradN_T_Vessel*10^3];
                    case 35
                        FigSet.Data{1,1} = [X,GradT];
                        FigSet.Data{2,1} = [X,GradE_T_Ray*10^3];
                        FigSet.Data{3,1} = [X,GradN_T_Ray*10^3];
                end
        end
        
        % 点型
        switch FigSet.SubplotModel
            case 'solo'
                if Model == 2 && Model2 ~= 3
                    FigSet.LineType = {'-r','-b','--r','--b','-.r','-.b'};
                elseif Model == 2 && Model2 == 3
                    FigSet.LineType = {'-r','-b','--r','--b','-.r','-.b','--g'};
                elseif Model == 1 && Model2 == 3
                    FigSet.LineType = {'-r','-b','--r','--b','--g'};
                else
                    FigSet.LineType = {'-r','-b','--r','--b'};
                end
            case 'subplot'
                switch FileStruct.FileNum
                    case 1
                        if Model == 2
                            FigSet.LineType = {'-g','-r','--r','-.r','-b','--b','-.b'};
                        else
                            FigSet.LineType = {'-g','-r','--r','-b','--b'};
                        end
                    case 3
                        FigSet.LineType = {'-g','-r','-b','--r','--b','-.r','-.b'};
                        
                    case 35
                        FigSet.LineType = {'-g','-r','-b'};
                end
        end
        
        switch FigSet.SubplotModel
            case 'solo'
                % 坐标轴
                FigSet.xlabelName = '观测历元';
                FigSet.ylabelName = '水平梯度（m/s/m）';
                FigSet.Label.FontSize = 12;
            case 'subplot'
                switch FileStruct.FileNum
                    case 1
                        FigSet.xlabelName ={'观测历元','观测历元','观测历元'};
                        FigSet.ylabelName = {'T变化（m/s）','E水平（m/s/m）','N水平（m/s/m）'};
                        FigSet.Label.FontSize = 12;
                    case 3
                        FigSet.xlabelName ={'\fontname{宋体}观测历元','\fontname{宋体}观测历元','\fontname{宋体}观测历元'};
                        FigSet.ylabelName = {'\fontname{宋体}{时间}\fontname{Times new roman}{(m/s)}',...
                            '\fontname{宋体}{船-应}\fontname{Times new roman}{(m/s/km)}','\fontname{宋体}{船-原点}\fontname{Times new roman}{(m/s/km)}'};
                        FigSet.Label.FontSize = 12;
                        
                    case 35
                        FigSet.xlabelName ={'观测历元','观测历元','观测历元'};
                        FigSet.ylabelName = {'\fontname{Times new roman}{\itK_t(m/s)}','\fontname{Times new roman}{\itK_e(m/s/km)}','\fontname{Times new roman}{\itK_n(m/s/km)}'};
                        FigSet.Label.FontSize = 15;
                end
        end
        % 图例
        switch FigSet.SubplotModel
            case 'solo'
                if Model == 2 && Model2 ~= 3
                    FigSet.legendName = {'仿真梯度E','仿真梯度N','解算梯度E-Ray','解算梯度N-Ray','解算梯度E-Vel','解算梯度N-Vel'};
                elseif Model == 2 && Model2 == 3
                    FigSet.legendName = {'仿真梯度E','仿真梯度N','解算梯度E-Ray','解算梯度N-Ray','解算梯度E-Vel','解算梯度N-Vel','计算梯度T'};
                elseif Model == 1 && Model2 == 3
                    FigSet.legendName = {'仿真梯度E','仿真梯度N','解算梯度E','解算梯度N','计算梯度T'};
                else
                    FigSet.legendName = {'仿真梯度E','仿真梯度N','解算梯度E','解算梯度N'};
                end
            case 'subplot'
                switch FileStruct.FileNum
                    case 1
                        if Model == 2
                            FigSet.legendName = {'计算梯度T','','';'仿真梯度E','解算梯度E-Ray','解算梯度E-Vel';'仿真梯度N','解算梯度N-Ray','解算梯度N-Vel'};
                        else
                            FigSet.legendName = {'计算梯度T','';'仿真梯度E','解算梯度E-Ray';'仿真梯度N','解算梯度N-Ray'};
                        end
                    case 3
                        FigSet.legendName = {'T','';'G_E','G_N';'G_E','G_N'};
                    case 35
                        
                end
        end
        FigSet.Frame = 'grid';
end

