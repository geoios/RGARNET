function [SubJcb] = ZTDJcb(BaseA,MPNum,SetModelMP,Lambda,Z_Ray,alpha_Ray,Z_Vessel,alpha_Vessel)
%% 
SubJcb =[];
switch SetModelMP.Inv_model.TModel
    case 6
        SubJcb1 = BaseA(:,1:MPNum(2) - MPNum(1))./ Lambda./cos(atan(Z_Ray));
end
SubJcb = [SubJcb,SubJcb1];

%% 
switch SetModelMP.Inv_model.FloorENModel  
    case 7
        SubJcb2 = BaseA(:,MPNum(2)+1- MPNum(1):MPNum(3)- MPNum(1)) .* Z_Ray.*sin(alpha_Ray)./Lambda./cos(atan(Z_Ray));
        SubJcb3 = BaseA(:,MPNum(3)- MPNum(1)+1:MPNum(4)- MPNum(1)) .* Z_Ray.*cos(alpha_Ray)./Lambda./cos(atan(Z_Ray));
end
SubJcb = [SubJcb,SubJcb2,SubJcb3];
%% 
switch SetModelMP.Inv_model.SurENModel
    case 7
        SubJcb4 = BaseA(:,MPNum(4)- MPNum(1)+1:MPNum(5)- MPNum(1)).* Z_Vessel.*sin(alpha_Vessel)./Lambda./cos(atan(Z_Ray));
        SubJcb5 = BaseA(:,MPNum(5)+1- MPNum(1):MPNum(6)- MPNum(1)).* Z_Vessel.*cos(alpha_Vessel)./Lambda./cos(atan(Z_Ray));
end
SubJcb = [SubJcb,SubJcb4,SubJcb5];
end

