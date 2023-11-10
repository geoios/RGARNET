function [detalT] = CompensateModelT(T,MP,MPNum,spdeg,knots,Ves_EN,Sta_EN,INIData,SetModelMP)
BSplineModel = 2;
%% SSF Time 
switch SetModelMP.Inv_model.TModel
    case 0
        detalT_T = 0;
    case 1
        [detalT_T] = Bspline_Function(T,MP(MPNum(1)+1:MPNum(2)),knots{1},spdeg,INIData.nchoosekList,BSplineModel);
end
detalT = detalT_T;
%% SSF Sea Surface EN 
switch SetModelMP.Inv_model.SurENModel
    case 0
        detal_Sur = 0;
    case 1
        [GradE_T_Sur] = Bspline_Function(T,MP(MPNum(2)+1:MPNum(3)),knots{2},spdeg,INIData.nchoosekList,BSplineModel);
        [GradN_T_Sur] = Bspline_Function(T,MP(MPNum(3)+1:MPNum(4)),knots{3},spdeg,INIData.nchoosekList,BSplineModel);
        detal_Sur = GradE_T_Sur * (Ves_EN(1)/1000) + GradN_T_Sur * (Ves_EN(2)/1000);
end
detalT = detalT + detal_Sur;
%% SSF Seafloor EN
switch SetModelMP.Inv_model.FloorENModel 
    case 0
        detal_Floor = 0;
    case 1
        [GradE_T_Floor] = Bspline_Function(T,MP(MPNum(4)+1:MPNum(5)),knots{4},spdeg,INIData.nchoosekList,BSplineModel);
        [GradN_T_Floor] = Bspline_Function(T,MP(MPNum(5)+1:MPNum(6)),knots{5},spdeg,INIData.nchoosekList,BSplineModel);
        detal_Floor = GradE_T_Floor * (Sta_EN(1)/1000) + GradN_T_Floor * (Sta_EN(2)/1000);
end
detalT = detalT + detal_Floor;

end

