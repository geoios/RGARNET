function [dX,Qxx,sigma0] = CalMPJcb_MTJcb_T_ModelT(OBSData,SetModelMP,INIData,SVP,MP,MPNum,knots)
N_shot = INIData.Data_file.N_shot;
Jcb = zeros(N_shot,MPNum(end));
C = MeanVel(SVP);spdeg = 3;
[EachPos,dCenPos] = deal(MP(1:MPNum(1)-3),MP(MPNum(1)-2:MPNum(1)));
EachPos = EachPos + repmat(dCenPos,1,length(EachPos)/3);
BaseA_ST = INIData.BaseA_ST;
BaseA_RT = INIData.BaseA_RT;
%% Coordinate Jacobian matrix
switch SetModelMP.Inv_model.JcbMoodel
    case 0
        Jcb(:,1:MPNum(1)) = 0;
    case 1
        deltap = SetModelMP.Inv_parameter.deltap;EachPos_tmp = EachPos;PF= PFGrad(SVP,2,1);
        [TT1,TT2,detalT1,detalT2] = deal(zeros(N_shot,1));
        Transducer_ENU_ST = [OBSData.transducer_e0,OBSData.transducer_n0,OBSData.transducer_u0];
        Transducer_ENU_RT = [OBSData.transducer_e1,OBSData.transducer_n1,OBSData.transducer_u1];
        
        for MPEpoch = 1:3
            EachPos_tmp(MPEpoch:3:MPNum(1)-3) = EachPos_tmp(MPEpoch:3:MPNum(1)-3) + deltap;
            switch SetModelMP.Inv_model.GradModel
                case 1
                    for ShotNum = 1:N_shot
                        index = OBSData.MTPSign(ShotNum);
                        [TT1(ShotNum),OBSData.PriTheta0(ShotNum)] = RayJcb_CalT(Transducer_ENU_ST(ShotNum,:),EachPos_tmp(index:index+2),PF,OBSData.PriTheta0(ShotNum));
                        [TT2(ShotNum),OBSData.PriTheta1(ShotNum)] = RayJcb_CalT(Transducer_ENU_RT(ShotNum,:),EachPos_tmp(index:index+2),PF,OBSData.PriTheta1(ShotNum));
                    end
                    Vessel_EN_ST = [OBSData.atde0,OBSData.atdn0];
                    Vessel_EN_RT = [OBSData.atde1,OBSData.atdn1];
                    Station_EN_ST = [OBSData.mtde,OBSData.mtdn];
                    Station_EN_RT = [OBSData.mtde,OBSData.mtdn];
                    
                    detalT1 = CompensateModeldT(SetModelMP,BaseA_ST,MP,MPNum,Vessel_EN_ST,Station_EN_ST);
                    detalT2 = CompensateModeldT(SetModelMP,BaseA_RT,MP,MPNum,Vessel_EN_RT,Station_EN_RT);
                    
                case 2
                    for ShotNum = 1:N_shot
                        index = OBSData.MTPSign(ShotNum);
                        [TT1(ShotNum),OBSData.PriTheta0(ShotNum)] = RayJcb_CalT(Transducer_ENU_ST(ShotNum,:),EachPos_tmp(index:index+2),PF,OBSData.PriTheta0(ShotNum));
                        [TT2(ShotNum),OBSData.PriTheta1(ShotNum)] = RayJcb_CalT(Transducer_ENU_RT(ShotNum,:),EachPos_tmp(index:index+2),PF,OBSData.PriTheta1(ShotNum));
                    end
                    alpha0_Ray = OBSData.alpha0_Ray;alpha1_Ray = OBSData.alpha1_Ray;
                    Z0_Ray = OBSData.Z0_Ray ; Z1_Ray = OBSData.Z1_Ray;
                    alpha0_Vessel = OBSData.alpha0_Vessel; alpha1_Vessel = OBSData.alpha1_Vessel;
                    Z0_Vessel = OBSData.Z0_Vessel; Z1_Vessel = OBSData.Z1_Vessel;
                    Lambda0 = OBSData.Lambda0; Lambda1 = OBSData.Lambda1;
                    gammar10 = OBSData.gammar10; gammar20 = OBSData.gammar20;
                    gammar11 = OBSData.gammar11; gammar21 = OBSData.gammar21;
                    H0 = OBSData.H0;H1 = OBSData.H1;
                    
                    [detalT1] = GradModel2(SetModelMP,BaseA_ST,MP,MPNum,Lambda0,Z0_Ray,alpha0_Ray,Z0_Vessel,alpha0_Vessel,gammar10,gammar20,H0);
                    [detalT2] = GradModel2(SetModelMP,BaseA_RT,MP,MPNum,Lambda1,Z1_Ray,alpha1_Ray,Z1_Vessel,alpha1_Vessel,gammar11,gammar21,H1);
            end
            switch SetModelMP.Inv_model.ObsEqModel
                case 0
                    ModelT = TT1 + TT2 - (detalT1 + detalT2);
                    switch INIData.FixModel
                        case 0
                            Jcb(sub2ind([N_shot,MPNum(1)],1:N_shot,OBSData.MTPSign' + MPEpoch - 1)) = (ModelT - OBSData.ModelT)/deltap;
                        case 1
                            Jcb(:,MPNum(1) - 3 + MPEpoch) = (ModelT - OBSData.ModelT)/deltap;
                    end
                case 1
                    scale  = INIData.scale;T0 = INIData.T0;TT = TT1 + TT2;
                    ModelT = log(TT / T0) - (detalT1 + detalT2)/2 * scale;
                    switch INIData.FixModel
                        case 0
                            Jcb(sub2ind([N_shot,MPNum(end)],1:N_shot,OBSData.MTPSign' + MPEpoch - 1)) = (ModelT - OBSData.LogModelT)/deltap;
                        case 1
                            Jcb(:,MPNum(1) - 3 + MPEpoch) = (ModelT - OBSData.LogModelT)/deltap;
                    end
            end
            EachPos_tmp = EachPos;
        end
        
    case 2
        e = -(OBSData.e0 + OBSData.e1) ./C;
        switch SetModelMP.Inv_model.ObsEqModel
            case 0
                switch INIData.FixModel
                    case 0
                        Jcb(sub2ind([N_shot,MPNum(1)],1:N_shot,OBSData.MTPSign')) = e(:,1);
                        Jcb(sub2ind([N_shot,MPNum(1)],1:N_shot,OBSData.MTPSign'+1)) = e(:,2);
                        Jcb(sub2ind([N_shot,MPNum(1)],1:N_shot,OBSData.MTPSign'+2)) = e(:,3);
                    case 1
                        Jcb(:,MPNum(1)-2:MPNum(1)) = e;
                end
        end
        
end
%% B-spline Jacobian matrix
switch SetModelMP.Inv_model.GradModel
    case 1
        Vessel_EN_ST = [OBSData.atde0,OBSData.atdn0];
        Vessel_EN_RT = [OBSData.atde1,OBSData.atdn1];
        Station_EN_ST = [OBSData.mtde,OBSData.mtdn];
        Station_EN_RT = [OBSData.mtde,OBSData.mtdn];
        [SubJcb0] = CompensateModelT2(SetModelMP,BaseA_ST,MPNum,Vessel_EN_ST,Station_EN_ST);
        [SubJcb1] = CompensateModelT2(SetModelMP,BaseA_RT,MPNum,Vessel_EN_RT,Station_EN_RT);
        
        
    case 2
        alpha0_Ray = OBSData.alpha0_Ray;alpha1_Ray = OBSData.alpha1_Ray;
        Z0_Ray = OBSData.Z0_Ray ; Z1_Ray = OBSData.Z1_Ray;
        alpha0_Vessel = OBSData.alpha0_Vessel; alpha1_Vessel = OBSData.alpha1_Vessel;
        Z0_Vessel = OBSData.Z0_Vessel; Z1_Vessel = OBSData.Z1_Vessel;
        
        alfae0 = OBSData.alfae0; alfae1 = OBSData.alfae1;
        Lambda0 = OBSData.Lambda0; Lambda1 = OBSData.Lambda1;
        gammar10 = OBSData.gammar10; gammar20 = OBSData.gammar20;
        gammar11 = OBSData.gammar11; gammar21 = OBSData.gammar21;
        H0 = OBSData.H0;H1 = OBSData.H1;
        
        Vessel_EN_ST = [OBSData.atde0,OBSData.atdn0];
        Vessel_EN_RT = [OBSData.atde1,OBSData.atdn1];
        
        Station_EN_ST = [OBSData.mtde,OBSData.mtdn];
        Station_EN_RT = [OBSData.mtde,OBSData.mtdn];
        
        
        [SubJcb0] = GradJcb(SetModelMP,BaseA_ST,MPNum,Lambda0,Z0_Ray,alpha0_Ray,Z0_Vessel,alpha0_Vessel,gammar10,gammar20,H0,Vessel_EN_ST,Station_EN_ST);
        [SubJcb1] = GradJcb(SetModelMP,BaseA_RT,MPNum,Lambda1,Z1_Ray,alpha1_Ray,Z1_Vessel,alpha1_Vessel,gammar11,gammar21,H1,Vessel_EN_RT,Station_EN_RT);
        
end
switch SetModelMP.Inv_model.ObsEqModel
    case 0
        Jcb(:,MPNum(1)+1:MPNum(end)) = - (SubJcb0 + SubJcb1);
    case 1
        scale  = INIData.scale;
        Jcb(:,MPNum(1)+1:MPNum(end)) = - (SubJcb0 + SubJcb1)./2.* scale;
end

%% eliminate gross errors
TrueIndex = find(strcmp(OBSData.flag,'True')==1);
Jcb(TrueIndex,:)=[];
detalTOri = OBSData.detalT;
detalTOri(TrueIndex,:) = [];
N_shot_Num = length(detalTOri);
%% Weight
switch SetModelMP.Other_functions.ObsPModel
    case 0
        Phi = ones(N_shot,1);
        Phi(TrueIndex,:) = [];
        P  = diag(Phi);
    case 1
        Phi = zeros(N_shot,1);
        for DataNum = 1:N_shot
            index = OBSData.MTPSign(DataNum);
            Transducer_ENU_ST = [OBSData.transducer_e0(DataNum),OBSData.transducer_n0(DataNum),OBSData.transducer_u0(DataNum)];
            Transducer_ENU_RT = [OBSData.transducer_e1(DataNum),OBSData.transducer_n1(DataNum),OBSData.transducer_u1(DataNum)];
            SinPhi0 = (OBSData.transducer_u0(DataNum) - EachPos(index+2))/norm(EachPos(index:index+2) - Transducer_ENU_ST);
            SinPhi1 = (OBSData.transducer_u1(DataNum) - EachPos(index+2))/norm(EachPos(index:index+2) - Transducer_ENU_RT);
            Phi(DataNum) = (SinPhi0 + SinPhi1)/2;
        end
        Phi(TrueIndex,:) = [];
        P = diag(Phi.^2);
    case 2
        icorrE = SetModelMP.HyperParameters.icorrE;
        T0   = INIData.T0;scale  = INIData.scale;
        TT0 = OBSData.TT/T0;
        if icorrE
            mu_t  = SetModelMP.HyperParameters.mu_t * 60;
            ST = OBSData.ST;MTPSign = OBSData.MTPSign;
            iP = zeros(N_shot,N_shot);
            
            for DataNum = 1:N_shot
                iST =  ST(DataNum);iMT = MTPSign(DataNum);
                index = find((abs(ST - iST)<4*60)==1);
                dshot = abs(iST - ST(index))/mu_t;
                dcorr = exp(-dshot) .* (0.5 + (1 - 0.5)*(iMT == MTPSign(index)));
                iP(DataNum,index) = dcorr/TT0(DataNum)./TT0(index);
            end
            P = inv(iP);P = P/scale^2;
        else
            Phi = TT0.^2;Phi(TrueIndex,:) = [];
            P = diag(Phi)/scale^2;
        end
    case 3
        TT0 = OBSData.TT;
        Phi = TT0.^2;Phi(TrueIndex,:) = [];
        P = diag(Phi);
    case 4
        icorrE = SetModelMP.HyperParameters.icorrE;
        Phi = zeros(N_shot,1);
        for DataNum = 1:N_shot
            index = OBSData.MTPSign(DataNum);
            Transducer_ENU_ST = [OBSData.transducer_e0(DataNum),OBSData.transducer_n0(DataNum),OBSData.transducer_u0(DataNum)];
            Transducer_ENU_RT = [OBSData.transducer_e1(DataNum),OBSData.transducer_n1(DataNum),OBSData.transducer_u1(DataNum)];
            SinPhi0 = (OBSData.transducer_u0(DataNum) - EachPos(index+2))/norm(EachPos(index:index+2) - Transducer_ENU_ST);
            SinPhi1 = (OBSData.transducer_u1(DataNum) - EachPos(index+2))/norm(EachPos(index:index+2) - Transducer_ENU_RT);
            Phi(DataNum) = (SinPhi0 + SinPhi1)/2;
        end
        
        if icorrE
            mu_t  = SetModelMP.HyperParameters.mu_t * 60;
            ST = OBSData.ST;MTPSign = OBSData.MTPSign;
            iP = zeros(N_shot,N_shot);
            
            for DataNum = 1:N_shot
                
                iST =  ST(DataNum);iMT = MTPSign(DataNum);
                index = find((abs(ST - iST)<4*60)==1);
                dshot = abs(iST - ST(index))/mu_t;
                dcorr = exp(-dshot) .* (0.5 + (1 - 0.5)*(iMT == MTPSign(index)));
                iP(DataNum,index) = dcorr/Phi(DataNum)./Phi(index);
            end
            iP(TrueIndex,:) = [];iP(:,TrueIndex) = [];
            P = inv(iP);
        else
            Phi(TrueIndex,:) = [];
            P = diag(Phi.^2);
        end
end
%% Parameter elimination
dX = zeros(MPNum(end),1);
switch SetModelMP.Inv_model.AdjGuiModel
    case {1,2,4,5,7}
        DeteleList = [];
        for i = 1:length(knots)
            dknots = round(knots{i}(2:end)-knots{i}(1:end-1));
            index = find(dknots>mode(dknots));
            for j = 1 :length(index)
                DeteleIndex = index(j)-spdeg:index(j);
                DeteleList =[DeteleList, DeteleIndex + MPNum(i)];
            end
        end
        for i = 1:MPNum(end)
            if length(unique(Jcb(:,i)))<3
                DeteleList =[DeteleList, i];
            end
        end
        DeteleList = unique(DeteleList);
        slvidx = 1:MPNum(end);slvidx(DeteleList)= [];
        JCB = Jcb(:,slvidx);
    case {3,6}
        switch INIData.FixModel
            case 0
                slvidx = 1:MPNum(end);DeteleList = MPNum(1)-2:MPNum(1);
                slvidx(DeteleList)=[];
                JCB = Jcb(:,slvidx);
            case 1
                slvidx = 1:MPNum(end);DeteleList = 1:MPNum(1)-3;
                slvidx(DeteleList)=[];
                JCB = Jcb(:,slvidx);
        end
end
%% Solve model
switch SetModelMP.Inv_model.AdjGuiModel
    case 1  
        Qxx = inv(JCB' * P * JCB);
        sigma0 = sqrt(detalTOri'* P *detalTOri)/(N_shot_Num - MPNum(end));
        dx =  Qxx * JCB' * P * detalTOri;
        dX(slvidx) = dx;
        
    case 2 
        detalT_tmp=[];VirP= [];Mu1 = SetModelMP.HyperParameters.Mu1;
        Gam_Tmp = zeros(1,MPNum(end)-MPNum(1));
        GamLN = length(MPNum)-1;VirObs_Tmp=[];MiddleTNum = 0;
        for GamLNum = 1:GamLN
            VirObs_SubTmp = [];
            for GamNum = MPNum(GamLNum) + 1:MPNum(GamLNum + 1)
                Gam_Tmp(GamNum - MPNum(1)) = 1;
                MPList = MPNum - MPNum(1);
                KnotsIndex = interp1([MPList realmax],0:length(MPList),GamNum - MPNum(1),'next','extrap'); %左开右闭
                KnotsMiddleT = (knots{KnotsIndex}(spdeg+1:end-spdeg-1) + knots{KnotsIndex}(spdeg+2:end-spdeg))/2;
                Jcb_Bbase = zeros(length(KnotsMiddleT),1);MP_tmp = [EachPos,dCenPos,Gam_Tmp];
                for ShotNum = 1:length(KnotsMiddleT)
                    [Jcb_Bbase(ShotNum)] = Bspline_Function(KnotsMiddleT(ShotNum),MP_tmp(MPNum(KnotsIndex)+1:MPNum(KnotsIndex+1)),...
                        knots{KnotsIndex},spdeg,INIData.nchoosekList,2);
                end
                VirObs_SubTmp(:,GamNum - MPNum(GamLNum)) = Jcb_Bbase;
                Gam_Tmp(GamNum - MPNum(1)) = 0;
            end
            VirObs_Tmp = blkdiag(VirObs_Tmp,VirObs_SubTmp);
            MiddleTNum = [MiddleTNum,length(KnotsMiddleT)];
        end
        MiddleTNum = cumsum(MiddleTNum);
        VirObs_Tmp = [zeros(size(VirObs_Tmp,1),MPNum(1)),VirObs_Tmp];
        
        BlockRow = zeros(1,length(MPNum));
        for j = 1:GamLN
            KnotsMiddleT = (knots{j}(spdeg+1:end-spdeg-1) + knots{j}(spdeg+2:end-spdeg))/2;
            BlockRow(j+1) = length(KnotsMiddleT)-1;
            CumBlockRow = cumsum(BlockRow);
            Row = CumBlockRow(j) + 1:CumBlockRow(j+1);
            Low = MPNum(j)+1:MPNum(j+1);
            VirObs_Exc(Row,Low) = VirObs_Tmp(MiddleTNum(j) + 2:MiddleTNum(j + 1),Low) - VirObs_Tmp(MiddleTNum(j)+1:MiddleTNum(j+1)-1,Low);
            
            TMP = zeros(1,MPNum(end));
            TMP(Low) = MP(Low);tmp_detalT = zeros(length(KnotsMiddleT),1);
            for ShotNum = 1:length(KnotsMiddleT)
                [tmp_detalT(ShotNum)] = Bspline_Function(KnotsMiddleT(ShotNum),TMP(MPNum(KnotsIndex)+1:MPNum(KnotsIndex+1)),...
                    knots{KnotsIndex},spdeg,INIData.nchoosekList,2);
            end
            dknots = round(knots{j}(2:end)-knots{j}(1:end-1));
            P_sub = diag(mode(dknots)./(KnotsMiddleT(2:end)-KnotsMiddleT(1:end-1)));
            VirP = blkdiag(VirP,P_sub);
            detalT_tmp =[detalT_tmp;tmp_detalT(1:end-1,1) - tmp_detalT(2:end,1)];
        end
        VirObs = VirObs_Exc(:,slvidx);
        JCB = [JCB;VirObs];
        sigma0 = sqrt(detalTOri'* P *detalTOri)/(N_shot_Num - MPNum(end));
        detalT     = [detalTOri; detalT_tmp];
        P = blkdiag(P,Mu1*VirP);
        Qxx = inv(JCB' * P * JCB);
        dx = Qxx * JCB' * P * detalT;
        dX(slvidx) = dx;
        
    case 3   
        R = INIData.H(MPNum(1)+1:MPNum(end),MPNum(1)+1:MPNum(end));
        VirObs  = zeros(MPNum(end)-MPNum(1) ,MPNum(end)-length(DeteleList));
        VirObs(1:MPNum(end)-MPNum(1),MPNum(1)+1-length(DeteleList):MPNum(end)-length(DeteleList)) = R;
        sigma0 = sqrt(detalTOri'* P *detalTOri)/(N_shot_Num - MPNum(end));
        P = blkdiag(P,diag(ones(1,MPNum(end)-MPNum(1))));
        detalT_tmp = - R * MP(MPNum(1)+1:MPNum(end))';
        detalT     = [detalTOri; detalT_tmp];
        JCB  = [JCB;VirObs];
        Qxx = inv(JCB'*P*JCB);
        dx = Qxx * JCB' * P * detalT;
        dX(slvidx) = dx;
    case 4  
        Low = MPNum(1)-3;
        C = zeros(Low,MPNum(end));Wx = zeros(Low,1);
        for i = 1:Low
            C(i,i) = 1;
            C(i,i+3) = -1;
            Wx(i) = INIData.MP(i) - INIData.MP(i+3) + MP(i+3) - MP(i);
        end
        
        P1 = diag(Phi.^2);P2 = diag(ones(Low,1));
        NBB = JCB'*P1*JCB;Wl = JCB'*P1*detalTOri;
        NCC = C*inv(NBB)*C';Qxx = inv(NBB)-inv(NBB)*C'*inv(NCC)*C*inv(NBB);
        dx = Qxx * Wl + inv(NBB) * C' * inv(NCC) * (-Wx);
        dX(slvidx) = dx;
        
    case 5 
        Mu3 = SetModelMP.HyperParameters.Mu3;
        Low = MPNum(1) - 3;
        C = zeros(Low,MPNum(end));Wx = zeros(Low,1);
        for i = 1:Low
            C(i,i) = 1;
            C(i,i+3) = -1;
            Wx(i) = INIData.MP(i) - INIData.MP(i+3) + MP(i+3) - MP(i);
        end
        C(:,DeteleList)=[];
        P1 = diag(Phi.^2);P2 = diag(ones(Low,1));
        P = blkdiag(P1,Mu3*P2);
        JCB =[JCB;C];detalTOri = [detalTOri;Wx];
        Qxx = inv(JCB'*P*JCB);
        dx = Qxx*JCB'*P*detalTOri;
        dX(slvidx) = dx;
        
    case 6 
        R = INIData.H;R(DeteleList,:)=[];R(:,DeteleList)=[];
        sigma0 = sqrt(detalTOri'* P *detalTOri)/(N_shot_Num - MPNum(end));
        Qxx = inv(JCB'*P*JCB + R);
        rk = JCB' * P * detalTOri + R * (INIData.PriorMP(slvidx)' - INIData.PosteriMP(slvidx)');
        dx = Qxx * rk;
        dX(slvidx) = dx;
        
    case 7
        sigma0 = sqrt(detalTOri'* P *detalTOri)/(N_shot_Num - MPNum(end));
        Qxx = inv(JCB'*P*JCB);
        rk = JCB' * P * detalTOri;
        dx = Qxx * rk;
        dX(slvidx) = dx;
        
end
end