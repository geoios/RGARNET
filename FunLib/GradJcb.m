function [SubJcb] = GradJcb(SetModelMP,BaseA,MPNum,Lambda,Z_Ray,alpha_Ray,Z_Vessel,alpha_Vessel,gammar1,gammar2,H,Ves_EN,Sta_EN)
SubJcb =[];
switch SetModelMP.Inv_model.TModel
    case 0
        SubJcb1 = [];
    case 1
        SubJcb1 =  BaseA(:,1:MPNum(2) - MPNum(1));
    case 2
        SubJcb1 =  BaseA(:,1:MPNum(2) - MPNum(1)).* gammar1;
    case 6
        SubJcb1 = BaseA(:,1:MPNum(2) - MPNum(1))./ Lambda;
end
SubJcb = [SubJcb,SubJcb1];

%% 
switch SetModelMP.Inv_model.FloorENModel  
    case 0
        SubJcb2 =[];SubJcb3 =[];
        
    case 2
       SubJcb2 = BaseA(:,MPNum(2)+1- MPNum(1):MPNum(3)- MPNum(1)).*(gammar2.* Z_Ray.*sin(alpha_Ray) + gammar1 .* H .* Z_Vessel .* sin(alpha_Vessel));
       SubJcb3 = BaseA(:,MPNum(3)- MPNum(1)+1:MPNum(4)- MPNum(1)).*(gammar2.* Z_Ray.*cos(alpha_Ray) + gammar1 .* H .* Z_Vessel .* cos(alpha_Vessel));
    case 7
        SubJcb2 = BaseA(:,MPNum(2)+1- MPNum(1):MPNum(3)- MPNum(1)) .* Z_Ray .*sin(alpha_Ray)./Lambda;
        SubJcb3 = BaseA(:,MPNum(3)- MPNum(1)+1:MPNum(4)- MPNum(1)) .* Z_Ray .*cos(alpha_Ray)./Lambda;
        
    case 8
        SubJcb2 = BaseA(:,MPNum(2)+1- MPNum(1):MPNum(3)- MPNum(1)) .* (H.* gammar1 - gammar2).* Ves_EN(:,1)./H;
        SubJcb3 = BaseA(:,MPNum(3)- MPNum(1)+1:MPNum(4)- MPNum(1)) .* (H.* gammar1 - gammar2).* Ves_EN(:,2)./H;
end
SubJcb = [SubJcb,SubJcb2,SubJcb3];
%% 
switch SetModelMP.Inv_model.SurENModel
    case 0
        SubJcb4 = [];SubJcb5 =[];
    case 7
        SubJcb4 = BaseA(:,MPNum(4)- MPNum(1)+1:MPNum(5)- MPNum(1)).* Z_Vessel.*sin(alpha_Vessel)./Lambda;
        SubJcb5 = BaseA(:,MPNum(5)+1- MPNum(1):MPNum(6)- MPNum(1)).* Z_Vessel.*cos(alpha_Vessel)./Lambda;
        
    case 8
        SubJcb4 = BaseA(:,MPNum(4)- MPNum(1)+1:MPNum(5)- MPNum(1)).* gammar2 .* Sta_EN(:,1).* H;
        SubJcb5 = BaseA(:,MPNum(5)+1- MPNum(1):MPNum(6)- MPNum(1)).* gammar2 .* Sta_EN(:,2).* H;
end
SubJcb = [SubJcb,SubJcb4,SubJcb5];
%% 
switch SetModelMP.Inv_model.RayObePro
    case 1
       SubJcb = SubJcb./cos(atan(Z_Ray));
end


end

