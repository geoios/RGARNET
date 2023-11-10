function [OBSData] = CalPosJcb_T2(OBSData,SetModelMP,INIData,SVP,MP,MPNum)
N_shot=str2double(INIData.Data_file.N_shot);
PF= PFGrad(SVP,2,1);
OBSData.CompensateT = zeros(N_shot,1);
OBSData.GeoDisInf = zeros(N_shot,1);
OBSData.ModelT = zeros(N_shot,1);
%% 计算传波时间
[alpha0_Ray,alpha1_Ray,Z0_Ray,Z1_Ray,alpha0_Vessel,alpha1_Vessel,Z0_Vessel,Z1_Vessel] = deal(zeros(N_shot,1));
[gammar10,gammar11,gammar20,gammar21,alfae0,alfae1,Lambda0,Lambda1,t0,t1,H0,H1] = deal(zeros(N_shot,1));
[e0,e1] = deal(zeros(N_shot,3));
for ShotNum = 1:N_shot
    index = OBSData.MTPSign(ShotNum);
    
    Transducer_ENU_ST = [OBSData.transducer_e0(ShotNum),OBSData.transducer_n0(ShotNum),OBSData.transducer_u0(ShotNum)];
    Transducer_ENU_RT = [OBSData.transducer_e1(ShotNum),OBSData.transducer_n1(ShotNum),OBSData.transducer_u1(ShotNum)];
    
    alpha0_Ray(ShotNum) = GetAzimuth(Transducer_ENU_ST(1:2), MP(index:index+1));
    alpha1_Ray(ShotNum) = GetAzimuth(Transducer_ENU_RT(1:2), MP(index:index+1));
    
    Z0_Ray(ShotNum) = norm(Transducer_ENU_ST(1:2) - MP(index:index+1))/-(MP(index+2)-Transducer_ENU_ST(3));
    Z1_Ray(ShotNum) = norm(Transducer_ENU_RT(1:2) - MP(index:index+1))/-(MP(index+2)-Transducer_ENU_RT(3));
    
    H0(ShotNum) = abs(MP(index+2)-Transducer_ENU_ST(3));
    H1(ShotNum) = abs(MP(index+2)-Transducer_ENU_RT(3));
    
    alpha0_Vessel(ShotNum)   = GetAzimuth(INIData.SeaCentre0(1:2), Transducer_ENU_ST(1:2));
    alpha1_Vessel(ShotNum)   = GetAzimuth(INIData.SeaCentre1(1:2), Transducer_ENU_RT(1:2));
    Z0_Vessel(ShotNum) = norm([OBSData.atde0(ShotNum),OBSData.atdn0(ShotNum)])/H0(ShotNum);
    Z1_Vessel(ShotNum) = norm([OBSData.atde1(ShotNum),OBSData.atdn1(ShotNum)])/H1(ShotNum);
    
    [e0(ShotNum,:),t0(ShotNum),RayInf0,OBSData.PriTheta0(ShotNum)] = RayJac_Num_CalGra(Transducer_ENU_ST,MP(index:index+2),PF,OBSData.PriTheta0(ShotNum));
    [e1(ShotNum,:),t1(ShotNum),RayInf1,OBSData.PriTheta1(ShotNum)] = RayJac_Num_CalGra(Transducer_ENU_RT,MP(index:index+2),PF,OBSData.PriTheta1(ShotNum));
    
    [gammar10(ShotNum),gammar20(ShotNum)] = deal(RayInf0.gammar1,RayInf0.gammar2);
    [gammar11(ShotNum),gammar21(ShotNum)] = deal(RayInf1.gammar1,RayInf1.gammar2);
    
    [alfae0(ShotNum),alfae1(ShotNum)] = deal(RayInf0.alfae,RayInf1.alfae);
    
    Lambda0(ShotNum) = cos(atan(Z0_Ray(ShotNum)))^-1 * RayInf0.cos_AvgBeta;
    Lambda1(ShotNum) = cos(atan(Z1_Ray(ShotNum)))^-1 * RayInf1.cos_AvgBeta;
end
OBSData.alpha0_Ray = alpha0_Ray;OBSData.alpha1_Ray = alpha1_Ray;
OBSData.Z0_Ray = Z0_Ray ; OBSData.Z1_Ray = Z1_Ray;
OBSData.alpha0_Vessel = alpha0_Vessel; OBSData.alpha1_Vessel = alpha1_Vessel;
OBSData.Z0_Vessel = Z0_Vessel; OBSData.Z1_Vessel = Z1_Vessel;

OBSData.e0 = e0;OBSData.e1 = e1;

OBSData.gammar10 = gammar10;OBSData.gammar11 = gammar11;
OBSData.gammar20 = gammar20;OBSData.gammar21 = gammar21;
OBSData.alfae0 = alfae0 ; OBSData.alfae1 = alfae1;
OBSData.Lambda0 = Lambda0; OBSData.Lambda1 = Lambda1;

OBSData.e0 = e0;OBSData.e1 = e1;OBSData.H0 = H0;OBSData.H1 = H1;

BaseA_ST = INIData.BaseA_ST;
BaseA_RT = INIData.BaseA_RT;

[detalT1] = GradModel2(SetModelMP,BaseA_ST,MP,MPNum,Lambda0,Z0_Ray,alpha0_Ray,Z0_Vessel,alpha0_Vessel,gammar10,gammar20,H0);
[detalT2] = GradModel2(SetModelMP,BaseA_RT,MP,MPNum,Lambda1,Z1_Ray,alpha1_Ray,Z1_Vessel,alpha1_Vessel,gammar11,gammar21,H1);

OBSData.CompensateT = detalT1 + detalT2;OBSData.GeoDisInf = t0 + t1;
OBSData.ModelT = (t0 + t1) - OBSData.CompensateT;
OBSData.detalT = OBSData.TT - OBSData.ModelT;
%% 残差剔除
FalseIndex = find(strcmp(OBSData.flag,'False')==1);
dTmean = mean(OBSData.detalT(FalseIndex));
dTstd = std(OBSData.detalT(FalseIndex));
Uplimit = dTmean + 3.5 * dTstd;
DownLimit = dTmean - 3.5 * dTstd;
for j=1:N_shot
    if OBSData.detalT(j) < DownLimit
        OBSData.flag{j} = 'True';
    elseif OBSData.detalT(j) > Uplimit
        OBSData.flag{j} = 'True';
    else
        OBSData.flag{j} = 'False';
    end
end
end

