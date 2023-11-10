function [MP,OBSData,Qxx,sigma0] = TCalModelT(OBSData,SetModelMP,INIData,SVP,MP,MPNum,knots)
iconv = 0;
for MAXLoop2 = 1:SetModelMP.Inv_parameter.maxloop
    OBSData         =   CalPosJcb_T(OBSData,SetModelMP,INIData,SVP,MP,MPNum);
    [dX,Qxx,sigma0]            =   CalMPJcb_MTJcb_T_ModelT(OBSData,SetModelMP,INIData,SVP,MP,MPNum,knots);
    
    [dposmax(MAXLoop2),index]  =  max(abs(dX(1:MPNum(1))))
    switch SetModelMP.Inv_model.GradModel
        case 1
            dxmax = max(abs(dX));
            if dxmax > 10
                alpha = 10/ dxmax;
                dX = alpha * dX;
                dxmax = max(abs(dX));
            end
            MP              =	MP  + dX';
            if dposmax(MAXLoop2) < 5*10^- 6 || dxmax<5*10^-5
                break;
            elseif dxmax < 0.005
                iconv = iconv + 1;
                if iconv == 2;break;end
            else
                iconv = 0;
            end
        case 2
            MP              =	MP  + dX';
            if dposmax(MAXLoop2)<5*10^-4
                break;
            end
    end
    
    INIData.PosteriMP = MP;
end

OBSData         =   CalPosJcb_T(OBSData,SetModelMP,INIData,SVP,MP,MPNum);

end

