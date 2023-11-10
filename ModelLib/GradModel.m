function [detalT] = GradModel(T,knots,spdeg,MP,MPNum,index,ENU,AR,AV,ZR,ZV,G1,G2,L,INIData,SetModelMP)
BSplineModel = 2;
if isempty(knots)
    detalT = 0;return;
end
%% 时间变化部分
switch SetModelMP.Inv_model.TModel 
    case 0
        detalT = 0;
    case 1
        [GradT] = Bspline_Function(T,MP(MPNum(1)+1:MPNum(2)),knots{1},spdeg,INIData.nchoosekList,BSplineModel);
        detalT = GradT;
    case 2
        [GradT] = Bspline_Function(T,MP(MPNum(1)+1:MPNum(2)),knots{1},spdeg,INIData.nchoosekList,BSplineModel);
        detalT  =  GradT * gammar(1);
    case 3
        BSNum = (index +2)/3;
        [GradT] = Bspline_Function(T,MP(MPNum(BSNum)+1:MPNum(BSNum+1)),knots{BSNum},spdeg,INIData.nchoosekList,BSplineModel);
        detalT  =  GradT * 1;
    case 5
        [GradT] = Bspline_Function(T,MP(MPNum(1)+1:MPNum(2)),knots{1},spdeg,INIData.nchoosekList,BSplineModel);
        detalT  =  GradT * INIData.gammar1 ;
    case 6
        [GradT] = Bspline_Function(T,MP(MPNum(1)+1:MPNum(2)),knots{1},spdeg,INIData.nchoosekList,BSplineModel);
        detalT  =  GradT * L^-1;
    case 7
        [GradT_Common] = Bspline_Function(T,MP(MPNum(1)+1:MPNum(2)),knots{1},spdeg,INIData.nchoosekList,BSplineModel);
        detalT  =  GradT_Common;
        BSNum = (index +2)/3;
        [GradT_Local] = Bspline_Function(T,MP(MPNum(BSNum+1)+1:MPNum(BSNum+2)),knots{1+BSNum},spdeg,INIData.nchoosekList,BSplineModel);
        detalT  =  detalT + GradT_Local;
        
end


%% 空间变化部分（船-站）
switch SetModelMP.Inv_model.FloorENModel  
    case 0
        detalT_Ray = 0;
    case 1
        [GradE_T_Ray] = Bspline_Function(T,MP(MPNum(2)+1:MPNum(3)),knots{2},spdeg,INIData.nchoosekList,BSplineModel);
        [GradN_T_Ray] = Bspline_Function(T,MP(MPNum(3)+1:MPNum(4)),knots{3},spdeg,INIData.nchoosekList,BSplineModel);
        detalT_Ray = GradE_T_Ray * ZR * sin(AR) + GradN_T_Ray * ZR * cos(AR);
    case 2
        [GradE_T_Ray] = Bspline_Function(T,MP(MPNum(2)+1:MPNum(3)),knots{2},spdeg,INIData.nchoosekList,BSplineModel);
        [GradN_T_Ray] = Bspline_Function(T,MP(MPNum(3)+1:MPNum(4)),knots{3},spdeg,INIData.nchoosekList,BSplineModel);
        detalT_Ray1 = GradN_T_Ray * (G2 * ZR * cos(AR) + G1 *  abs(ENU(3) - MP(index+2)) * ZV * cos(AV));
        detalT_Ray2 = GradE_T_Ray * (G2 * ZR * sin(AR) + G1 *  abs(ENU(3) - MP(index+2)) * ZV * sin(AV));
        detalT_Ray = detalT_Ray1 + detalT_Ray2;
    case 3
        [GradE_T_Ray] = Bspline_Function(T,MP(MPNum(end-4)+1:MPNum(end-3)),knots{end-3},spdeg,INIData.nchoosekList,BSplineModel);
        [GradN_T_Ray] = Bspline_Function(T,MP(MPNum(end-3)+1:MPNum(end-2)),knots{end-2},spdeg,INIData.nchoosekList,BSplineModel);
        detalT_Ray = GradE_T_Ray * ZR * sin(AR) + GradN_T_Ray * ZR * cos(AR);
    case 4
        BSNum = (index +2)/3;
        [GradE_T_Ray] = Bspline_Function(T,MP(MPNum(1+(BSNum-1)*2+1)+1:MPNum(1+BSNum*2)),knots{1+(BSNum-1)*2+1},spdeg,INIData.nchoosekList,BSplineModel);
        [GradN_T_Ray] = Bspline_Function(T,MP(MPNum(1+BSNum*2)+1:MPNum(1+BSNum*2+1)),knots{1+BSNum*2},spdeg,INIData.nchoosekList,BSplineModel);
        detalT_Ray = GradE_T_Ray * ZR * sin(AR) + GradN_T_Ray * ZR * cos(AR);
    case 5
        [GradE_T_Ray] = Bspline_Function(T,MP(MPNum(2)+1:MPNum(3)),knots{2},spdeg,INIData.nchoosekList,BSplineModel);
        [GradN_T_Ray] = Bspline_Function(T,MP(MPNum(3)+1:MPNum(4)),knots{3},spdeg,INIData.nchoosekList,BSplineModel);
        detalT_Ray1 = GradN_T_Ray * (INIData.gammar2 * ZR * cos(AR) + INIData.gammar1 *  abs(ENU(3) - MP(index+2)) * ZV * cos(AV));
        detalT_Ray2 = GradE_T_Ray * (INIData.gammar2 * ZR * sin(AR) + INIData.gammar1 *  abs(ENU(3) - MP(index+2)) * ZV * sin(AV));
        detalT_Ray = detalT_Ray1 + detalT_Ray2;
    case 6
        [GradE_T_Ray] = Bspline_Function(T,MP(MPNum(2)+1:MPNum(3)),knots{2},spdeg,INIData.nchoosekList,BSplineModel);
        [GradN_T_Ray] = Bspline_Function(T,MP(MPNum(3)+1:MPNum(4)),knots{3},spdeg,INIData.nchoosekList,BSplineModel);
        detalT_Ray = (GradN_T_Ray * ZR * cos(AR) + GradE_T_Ray * ZR * sin(AR))*(INIData.gammar2 + abs(ENU(3) - MP(index+2)) * INIData.gammar1);
    case 7
        [GradE_T_Ray] = Bspline_Function(T,MP(MPNum(2)+1:MPNum(3)),knots{2},spdeg,INIData.nchoosekList,BSplineModel);
        [GradN_T_Ray] = Bspline_Function(T,MP(MPNum(3)+1:MPNum(4)),knots{3},spdeg,INIData.nchoosekList,BSplineModel);
        detalT_Ray = (GradN_T_Ray * ZR * cos(AR) + GradE_T_Ray * ZR * sin(AR)) * L^-1;
    case 8
        BSNum = (index +2)/3;ENindex = MPNum(1)/3;
        [GradE_T_Ray] = Bspline_Function(T,MP(MPNum(1+(BSNum-1)*2+ENindex)+1:MPNum(BSNum*2+ENindex)),knots{1+(BSNum-1)*2+ENindex},spdeg,INIData.nchoosekList,BSplineModel);
        [GradN_T_Ray] = Bspline_Function(T,MP(MPNum(BSNum*2+ENindex)+1:MPNum(BSNum*2+ENindex+1)),knots{ENindex+BSNum*2},spdeg,INIData.nchoosekList,BSplineModel);
        detalT_Ray = GradE_T_Ray * ZR * sin(AR) + GradN_T_Ray * ZR * cos(AR);
    case 9
        [GradE_T_Ray] = Bspline_Function(T,MP(MPNum(2)+1:MPNum(3)),knots{2},spdeg,INIData.nchoosekList,BSplineModel);
        [GradN_T_Ray] = Bspline_Function(T,MP(MPNum(3)+1:MPNum(4)),knots{3},spdeg,INIData.nchoosekList,BSplineModel);
        detalT_Ray1 = GradN_T_Ray * (G2 * ZR * cos(AR));
        detalT_Ray2 = GradE_T_Ray * (G2 * ZR * sin(AR));
        detalT_Ray = detalT_Ray1 + detalT_Ray2;
    case 10
        [GradE_T_Ray] = Bspline_Function(T,MP(MPNum(2)+1:MPNum(3)),knots{2},spdeg,INIData.nchoosekList,BSplineModel);
        [GradN_T_Ray] = Bspline_Function(T,MP(MPNum(3)+1:MPNum(4)),knots{3},spdeg,INIData.nchoosekList,BSplineModel);
        detalT_Ray1 = GradN_T_Ray * (MP(index+1) + ENU(2))/2;
        detalT_Ray2 = GradE_T_Ray * (MP(index) + ENU(1))/2;
        detalT_Ray = detalT_Ray1 + detalT_Ray2;
end
detalT = detalT + detalT_Ray;

%% 空间变化部分（船-基准）
switch SetModelMP.Inv_model.SurENModel
    case 0
        detalT_Vessel = 0;
    case 1
        [GradE_T_Vessel] = Bspline_Function(T,MP(MPNum(4)+1:MPNum(5)),knots{4},spdeg,INIData.nchoosekList,BSplineModel);
        [GradN_T_Vessel] = Bspline_Function(T,MP(MPNum(5)+1:MPNum(6)),knots{5},spdeg,INIData.nchoosekList,BSplineModel);
        detalT_Vessel =  GradN_T_Vessel * ZV * cos(AV) + GradE_T_Vessel * ZV * sin(AV);
    case 2
        BSNum = (index +2)/3;
        [GradE_T_Vessel] = Bspline_Function(T,MP(MPNum(3+(BSNum-1)*2+1)+1:MPNum(3+BSNum*2)),knots{3+(BSNum-1)*2+1},spdeg,INIData.nchoosekList,BSplineModel);
        [GradN_T_Vessel] = Bspline_Function(T,MP(MPNum(3+BSNum*2)+1:MPNum(3+BSNum*2+1)),knots{3+BSNum*2},spdeg,INIData.nchoosekList,BSplineModel);
        detalT_Vessel =  GradN_T_Vessel * ZV * cos(AV) + GradE_T_Vessel * ZV * sin(AV);
    case 3
        [GradE_T_Vessel] = Bspline_Function(T,MP(MPNum(end-2)+1:MPNum(end-1)),knots{end-1},spdeg,INIData.nchoosekList,BSplineModel);
        [GradN_T_Vessel] = Bspline_Function(T,MP(MPNum(end-1)+1:MPNum(end)),knots{end},spdeg,INIData.nchoosekList,BSplineModel);
        detalT_Vessel =  GradN_T_Vessel * ZV * cos(AV) + GradE_T_Vessel * ZV * sin(AV);
    case 7
        [GradE_T_Vessel] = Bspline_Function(T,MP(MPNum(4)+1:MPNum(5)),knots{4},spdeg,INIData.nchoosekList,BSplineModel);
        [GradN_T_Vessel] = Bspline_Function(T,MP(MPNum(5)+1:MPNum(6)),knots{5},spdeg,INIData.nchoosekList,BSplineModel);
        detalT_Vessel =  (GradN_T_Vessel * ZV * cos(AV) + GradE_T_Vessel * ZV * sin(AV)) * L^-1;
    case 9
        [GradE_T_Vessel] = Bspline_Function(T,MP(MPNum(4)+1:MPNum(5)),knots{4},spdeg,INIData.nchoosekList,BSplineModel);
        [GradN_T_Vessel] = Bspline_Function(T,MP(MPNum(5)+1:MPNum(6)),knots{5},spdeg,INIData.nchoosekList,BSplineModel);
        detalT_Vessel1 = GradN_T_Vessel * (G1 *  abs(ENU(3) - MP(index+2)) * ZV * cos(AV));
        detalT_Vessel2 = GradE_T_Vessel * (G1 *  abs(ENU(3) - MP(index+2)) * ZV * sin(AV));
        detalT_Vessel = detalT_Vessel1 + detalT_Vessel2;
        
end
detalT = detalT + detalT_Vessel;

%% 
switch SetModelMP.Inv_model.RayObePro
    case 1
        detalT =  detalT * cos(atan(ZR))^-1;
end
end

