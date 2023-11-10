function [detalT,Grad] = GradModel2(SetModelMP,BaseA,MP,MPNum,Lambda,Z_Ray,alpha_Ray,Z_Vessel,alpha_Vessel,gammar1,gammar2,H,Ves_EN,Sta_EN)
%% Time variation section
switch SetModelMP.Inv_model.TModel
    case 0
        detalT_T = zeros(length(H),1);GradT = zeros(length(H),1);
    case 1
        BMP0 = MP(MPNum(1)+1:MPNum(2));
        GradT = BaseA(:,1:MPNum(2) - MPNum(1)) * BMP0';
        detalT_T =  GradT;
    case 2
        BMP0 = MP(MPNum(1)+1:MPNum(2));
        GradT = BaseA(:,1:MPNum(2) - MPNum(1)) * BMP0';
        detalT_T =  GradT .* gammar1;
    case 6
        BMP0 = MP(MPNum(1)+1:MPNum(2));
        GradT = BaseA(:,1:MPNum(2) - MPNum(1)) * BMP0';
        detalT_T =  GradT ./ Lambda;
end


%% Spatial variation part (ship & station)
switch SetModelMP.Inv_model.FloorENModel
    case 0
        detalT_Ray = zeros(length(H),1);GradVe=zeros(length(H),1);GradVn= zeros(length(H),1);
    case 2
        BMP1 = MP(MPNum(2)+1:MPNum(3));BMP2 = MP(MPNum(3)+1:MPNum(4));
        GradVe = BaseA(:,MPNum(2)+1- MPNum(1):MPNum(3)- MPNum(1)) * BMP1';
        GradVn = BaseA(:,MPNum(3)- MPNum(1)+1:MPNum(4)- MPNum(1)) * BMP2';
        detalT_Ray = GradVe .*(gammar2.* Z_Ray.*sin(alpha_Ray) + gammar1 .* H .* Z_Vessel.*sin(alpha_Vessel))+...
            GradVn .*(gammar2.* Z_Ray.*cos(alpha_Ray) + gammar1 .* H .* Z_Vessel .* cos(alpha_Vessel));
        
    case 7
        BMP1 = MP(MPNum(2)+1:MPNum(3));BMP2 = MP(MPNum(3)+1:MPNum(4));
        GradVe = BaseA(:,MPNum(2)+1- MPNum(1):MPNum(3)- MPNum(1)) * BMP1';
        GradVn = BaseA(:,MPNum(3)- MPNum(1)+1:MPNum(4)- MPNum(1)) * BMP2';
        detalT_Ray = (GradVe .* Z_Ray.*sin(alpha_Ray) + GradVn .* Z_Ray.*cos(alpha_Ray))./Lambda;
    case 8
        BMP1 = MP(MPNum(2)+1:MPNum(3));BMP2 = MP(MPNum(3)+1:MPNum(4));
        GradVe = BaseA(:,MPNum(2)+1- MPNum(1):MPNum(3)- MPNum(1)) * BMP1';
        GradVn = BaseA(:,MPNum(3)- MPNum(1)+1:MPNum(4)- MPNum(1)) * BMP2';
        detalT_Ray = GradVe .* (H.* gammar1 - gammar2).* Ves_EN(:,1)./H + GradVn .*(H.* gammar1 - gammar2).* Ves_EN(:,2)./H;
        
        
end

%% Spatial variation part (ship & center)
switch SetModelMP.Inv_model.SurENModel
    case 0
        detalT_Vel = zeros(length(H),1);GradRe = zeros(length(H),1); GradRn= zeros(length(H),1);
    case 7
        BMP3 = MP(MPNum(4)+1:MPNum(5));BMP4 = MP(MPNum(5)+1:MPNum(6));
        GradRe = BaseA(:,MPNum(4)- MPNum(1)+1:MPNum(5)- MPNum(1)) * BMP3';
        GradRn = BaseA(:,MPNum(5)+1- MPNum(1):MPNum(6)- MPNum(1)) * BMP4';
        detalT_Vel = (GradRe .* Z_Vessel.*sin(alpha_Vessel) + GradRn .* Z_Vessel.*cos(alpha_Vessel))./Lambda;
    case 8
        BMP3 = MP(MPNum(4)+1:MPNum(5));BMP4 = MP(MPNum(5)+1:MPNum(6));
        GradRe = BaseA(:,MPNum(4)- MPNum(1)+1:MPNum(5)- MPNum(1)) * BMP3';
        GradRn = BaseA(:,MPNum(5)+1- MPNum(1):MPNum(6)- MPNum(1)) * BMP4';
        detalT_Vel = GradRe .* gammar2 .* Sta_EN(:,1).* H + GradRn .* gammar2 .* Sta_EN(:,2).* H;
end

%% mapping function
switch SetModelMP.Inv_model.RayObePro
    case 0
        detalT = detalT_T + detalT_Ray + detalT_Vel;
    case 1
        detalT = (detalT_T + detalT_Ray + detalT_Vel)./cos(atan(Z_Ray));
end
Grad = [GradT,GradVe,GradVn,GradRe,GradRn];
end

