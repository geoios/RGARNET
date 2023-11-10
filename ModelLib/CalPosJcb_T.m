function [OBSData] = CalPosJcb_T(OBSData,SetModelMP,INIData,SVP,MP,MPNum)
N_shot = INIData.Data_file.N_shot;
PF = PFGrad(SVP,2,1);
[TT1,TT2,detalT1,detalT2] = deal(zeros(N_shot,1));
switch SetModelMP.Inv_model.DirOffset
    case 0
        [EachPos,dCenPos] = deal(MP(1:MPNum(1)-3),MP(MPNum(1)-2:MPNum(1)));
        EachPos = EachPos + repmat(dCenPos,1,MPNum(1)/3-1);
    case 1
        EachPos = MP(1:MPNum(1));
end
BaseA_ST = INIData.BaseA_ST;
BaseA_RT = INIData.BaseA_RT;
%% Calculate Travel time
switch SetModelMP.Inv_model.GradModel
    case 1
        Transducer_ENU_ST = [OBSData.transducer_e0,OBSData.transducer_n0,OBSData.transducer_u0];
        Transducer_ENU_RT = [OBSData.transducer_e1,OBSData.transducer_n1,OBSData.transducer_u1];
        for ShotNum = 1:N_shot
            index = OBSData.MTPSign(ShotNum);
            [TT1(ShotNum),OBSData.PriTheta0(ShotNum)] = RayJcb_CalT(Transducer_ENU_ST(ShotNum,:),EachPos(index:index+2),PF,OBSData.PriTheta0(ShotNum));
            [TT2(ShotNum),OBSData.PriTheta1(ShotNum)] = RayJcb_CalT(Transducer_ENU_RT(ShotNum,:),EachPos(index:index+2),PF,OBSData.PriTheta1(ShotNum));
        end
        Vessel_EN_ST = [OBSData.atde0,OBSData.atdn0];
        Vessel_EN_RT = [OBSData.atde1,OBSData.atdn1];
        
        Station_EN_ST = [OBSData.mtde,OBSData.mtdn];
        Station_EN_RT = [OBSData.mtde,OBSData.mtdn];
        
        [detalT1,Grad1]= CompensateModeldT(SetModelMP,BaseA_ST,MP,MPNum,Vessel_EN_ST,Station_EN_ST);
        [detalT2,Grad2]= CompensateModeldT(SetModelMP,BaseA_RT,MP,MPNum,Vessel_EN_RT,Station_EN_RT);
        
    case 2
        [alpha0_Ray,alpha1_Ray,Z0_Ray,Z1_Ray,alpha0_Vessel,alpha1_Vessel,Z0_Vessel,Z1_Vessel] = deal(zeros(N_shot,1));
        [gammar10,gammar11,gammar20,gammar21,alfae0,alfae1,Lambda0,Lambda1,H0,H1] = deal(zeros(N_shot,1));
        [e0,e1] = deal(zeros(N_shot,3));
        for ShotNum = 1:N_shot
            index = OBSData.MTPSign(ShotNum);
            
            Transducer_ENU_ST = [OBSData.transducer_e0(ShotNum),OBSData.transducer_n0(ShotNum),OBSData.transducer_u0(ShotNum)];
            Transducer_ENU_RT = [OBSData.transducer_e1(ShotNum),OBSData.transducer_n1(ShotNum),OBSData.transducer_u1(ShotNum)];
            
            H0(ShotNum) = abs(EachPos(index+2)-Transducer_ENU_ST(3));
            H1(ShotNum) = abs(EachPos(index+2)-Transducer_ENU_RT(3));
            
            alpha0_Ray(ShotNum) = GetAzimuth(Transducer_ENU_ST(1:2), EachPos(index:index+1));
            alpha1_Ray(ShotNum) = GetAzimuth(Transducer_ENU_RT(1:2), EachPos(index:index+1));
            Z0_Ray(ShotNum) = norm(Transducer_ENU_ST(1:2) - EachPos(index:index+1))/H0(ShotNum);
            Z1_Ray(ShotNum) = norm(Transducer_ENU_RT(1:2) - EachPos(index:index+1))/H1(ShotNum);
            
            alpha0_Vessel(ShotNum)   = GetAzimuth(INIData.SeaCentre0(1:2), Transducer_ENU_ST(1:2));
            alpha1_Vessel(ShotNum)   = GetAzimuth(INIData.SeaCentre1(1:2), Transducer_ENU_RT(1:2));
            Z0_Vessel(ShotNum) = norm([OBSData.atde0(ShotNum),OBSData.atdn0(ShotNum)])/H0(ShotNum);
            Z1_Vessel(ShotNum) = norm([OBSData.atde1(ShotNum),OBSData.atdn1(ShotNum)])/H1(ShotNum);
            
            
            [e0(ShotNum,:),TT1(ShotNum),RayInf0,OBSData.PriTheta0(ShotNum)] = RayJac_Num_CalGra(Transducer_ENU_ST,EachPos(index:index+2),PF,OBSData.PriTheta0(ShotNum));
            [e1(ShotNum,:),TT2(ShotNum),RayInf1,OBSData.PriTheta1(ShotNum)] = RayJac_Num_CalGra(Transducer_ENU_RT,EachPos(index:index+2),PF,OBSData.PriTheta1(ShotNum));
            
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
        
        OBSData.e0 = e0;OBSData.e1 = e1;OBSData.H0 = H0;OBSData.H1 = H1;
        
        OBSData.gammar10 = gammar10;OBSData.gammar11 = gammar11;
        OBSData.gammar20 = gammar20;OBSData.gammar21 = gammar21;
        OBSData.alfae0 = alfae0 ; OBSData.alfae1 = alfae1;
        OBSData.Lambda0 = Lambda0; OBSData.Lambda1 = Lambda1;
        
        Vessel_EN_ST = [OBSData.atde0,OBSData.atdn0];
        Vessel_EN_RT = [OBSData.atde1,OBSData.atdn1];
        
        Station_EN_ST = [OBSData.mtde,OBSData.mtdn];
        Station_EN_RT = [OBSData.mtde,OBSData.mtdn];
        
        [detalT1,Grad1] = GradModel2(SetModelMP,BaseA_ST,MP,MPNum,Lambda0,Z0_Ray,alpha0_Ray,Z0_Vessel,alpha0_Vessel,gammar10,gammar20,H0,Vessel_EN_ST,Station_EN_ST);
        [detalT2,Grad2] = GradModel2(SetModelMP,BaseA_RT,MP,MPNum,Lambda1,Z1_Ray,alpha1_Ray,Z1_Vessel,alpha1_Vessel,gammar11,gammar21,H1,Vessel_EN_RT,Station_EN_RT);
        
        
end
switch SetModelMP.Inv_model.ObsEqModel
    case 0
        OBSData.CompensateT = (detalT1 + detalT2);
        OBSData.GeoDisInf = TT1 + TT2;
        OBSData.ModelT = TT1 + TT2 - OBSData.CompensateT;
        OBSData.detalT = OBSData.TT - OBSData.ModelT;
        [OBSData.GradT,OBSData.GradVe,OBSData.GradVn,OBSData.GradRe,OBSData.GradRn] = ...
            deal((Grad1(:,1) + Grad2(:,1))/2,(Grad1(:,2) + Grad2(:,2))/2 * 1000,(Grad1(:,3) + Grad2(:,3))/ 2* 1000,...
            (Grad1(:,4) + Grad2(:,4))/2 * 1000,(Grad1(:,5) + Grad2(:,5))/2 * 1000);    % Unit: 1m/s/m => 1000m/s/km
        OBSData.ResiTT = OBSData.detalT;
        OBSData.TakeOff = (OBSData.PriTheta0 + OBSData.PriTheta1)/2;
        OBSData.gamma = OBSData.CompensateT;
    case 1
        scale  = INIData.scale; T0 = INIData.T0; V0 = INIData.V0;
        OBSData.gammar = (detalT1 + detalT2)/2 * scale;
        OBSData.GeoDisInf = TT1 + TT2;
        OBSData.LogModelT = log((TT1 + TT2)/ T0 ) - OBSData.gammar;
        OBSData.detalT = OBSData.logTT - OBSData.LogModelT;
        OBSData.dV = OBSData.gammar * V0;Grad1_av = Grad1 * scale * V0;Grad2_av = Grad2 * scale * V0;
        [OBSData.dV0,OBSData.gradV1e,OBSData.gradV1n,OBSData.gradV2e,OBSData.gradV2n] = ...
            deal((Grad1_av(:,1) + Grad2_av(:,1))/2,(Grad1_av(:,2) + Grad2_av(:,2))/2,(Grad1_av(:,3) + Grad2_av(:,3))/2,...
            (Grad1_av(:,4) + Grad2_av(:,4))/2,(Grad1_av(:,5) + Grad2_av(:,5))/2); % Unit: m/s/km
        
end
%% Residual screening
FalseIndex = find(strcmp(OBSData.flag,'False')==1);
dTmean = mean(OBSData.detalT(FalseIndex));
dTstd = std(OBSData.detalT(FalseIndex));
Uplimit = dTmean + SetModelMP.Inv_parameter.RejectCriteria * dTstd;
DownLimit = dTmean - SetModelMP.Inv_parameter.RejectCriteria * dTstd;
for j = 1:N_shot
    if OBSData.detalT(j) < DownLimit
        OBSData.flag{j} = 'True';
    elseif OBSData.detalT(j) > Uplimit
        OBSData.flag{j} = 'True';
    else
        OBSData.flag{j} = 'False';
    end
end
end

