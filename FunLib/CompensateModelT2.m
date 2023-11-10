function [SubJcb] = CompensateModelT2(SetModelMP,BaseA,MPNum,Ves_EN,Sta_EN)

%% SSF Time 
switch SetModelMP.Inv_model.TModel
    case 0
        SubJcb1 = [];
    case 1
        SubJcb1 =  BaseA(:,1:MPNum(2) - MPNum(1));
end
SubJcb = SubJcb1;
%% SSF Sea Surface EN 
switch SetModelMP.Inv_model.SurENModel
    case 0
        SubJcb2 = [];SubJcb3=[];
    case 1
        SubJcb2 = BaseA(:,MPNum(2)- MPNum(1)+1:MPNum(3)- MPNum(1)).* (Ves_EN(:,1)./1000);
        SubJcb3 = BaseA(:,MPNum(3)- MPNum(1)+1:MPNum(4)- MPNum(1)).* (Ves_EN(:,2)./1000);
end
SubJcb = [SubJcb,SubJcb2,SubJcb3];
%% SSF Seafloor EN
switch SetModelMP.Inv_model.FloorENModel 
    case 0
        SubJcb4 =[];SubJcb5=[];
    case 1
        SubJcb4 = BaseA(:,MPNum(4)- MPNum(1)+1:MPNum(5)- MPNum(1)).* (Sta_EN(:,1)./1000);
        SubJcb5 = BaseA(:,MPNum(5)- MPNum(1)+1:MPNum(6)- MPNum(1)).* (Sta_EN(:,2)./1000);
end
SubJcb = [SubJcb,SubJcb4,SubJcb5];

end

