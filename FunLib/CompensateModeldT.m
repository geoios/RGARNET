function [detalT,Grad] = CompensateModeldT(SetModelMP,BaseA,MP,MPNum,Ves_EN,Sta_EN)

switch SetModelMP.Inv_model.TModel
    case 0
        detalT_T = zeros(size(Sta_EN,1),1);GradT = [];
    case 1
        BMP0 = MP(MPNum(1)+1:MPNum(2));
        GradT = BaseA(:,1:MPNum(2) - MPNum(1)) * BMP0';
        detalT_T =  GradT;
end

%% SSF Sea Surface EN 
switch SetModelMP.Inv_model.SurENModel
    case 0
        detalT_Ray = zeros(size(Sta_EN,1),1);GradSurE=[];GradSurN= [];
    case 1
        BMP1 = MP(MPNum(2)+1:MPNum(3));BMP2 = MP(MPNum(3)+1:MPNum(4));
        GradSurE = BaseA(:,MPNum(2)+1- MPNum(1):MPNum(3)- MPNum(1)) * BMP1';
        GradSurN = BaseA(:,MPNum(3)- MPNum(1)+1:MPNum(4)- MPNum(1)) * BMP2';
        detalT_Ray = GradSurE .* (Ves_EN(:,1)./1000) + GradSurN .* (Ves_EN(:,2)./1000);
end

%% SSF Seafloor EN
switch SetModelMP.Inv_model.FloorENModel 
    case 0
        detalT_Vel = zeros(size(Sta_EN,1),1);GradStaE = []; GradStaN= [];
    case 1
        BMP3 = MP(MPNum(4)+1:MPNum(5));BMP4 = MP(MPNum(5)+1:MPNum(6));
        GradStaE = BaseA(:,MPNum(4)- MPNum(1)+1:MPNum(5)- MPNum(1)) * BMP3';
        GradStaN = BaseA(:,MPNum(5)+1- MPNum(1):MPNum(6)- MPNum(1)) * BMP4';
        detalT_Vel = GradStaE .* (Sta_EN(:,1)./1000) + GradStaN .* (Sta_EN(:,2)./1000);
end
%% 
detalT = (detalT_T + detalT_Ray + detalT_Vel);
Grad = [GradT,GradSurE,GradSurN,GradStaE,GradStaN];
end

