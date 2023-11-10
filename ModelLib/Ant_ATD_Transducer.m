function [OBSData,INIData,MP,MPNum] = Ant_ATD_Transducer(OBSData,SetModelMP,INIData,MP_ENU,MPNum,SVP,knots)
spdeg = 3;
%%
switch SetModelMP.Inv_model.DirOffset
    case 0
        switch SetModelMP.Other_functions.MPINI
            case 0 % 'zeros'
                MPNum = [length(MP_ENU),MPNum];
                MPNum = cumsum(MPNum);
                MP = zeros(1,MPNum(end));
                MP(1:MPNum(1)) = MP_ENU;
        end
    case 1
        MPNum = [length(MP_ENU)-3,MPNum];
        MPNum = cumsum(MPNum);
        MP = zeros(1,MPNum(end));
        MP(1:MPNum(1)) = MP_ENU(1:MPNum(1));
        INIData.FixSave = 'demo_timeSeq';
end
%% 0.ATD offset
N_shot = INIData.Data_file.N_shot;
ATD = INIData.PriorMP(end-2:end);
[st_de,st_dn,st_du,rt_de,rt_dn,rt_du] = deal(zeros(N_shot,1));
for i=1:N_shot
    [ st_de(i),st_dn(i),st_du(i)] = Transform(OBSData.head0(i),OBSData.pitch0(i),OBSData.roll0(i),ATD(1),ATD(2),ATD(3));
    [ rt_de(i),rt_dn(i),rt_du(i)] = Transform(OBSData.head1(i),OBSData.pitch1(i),OBSData.roll1(i),ATD(1),ATD(2),ATD(3));
end
[OBSData.transducer_e0,OBSData.transducer_n0,OBSData.transducer_u0] = ...
    deal(OBSData.ant_e0 + st_de,OBSData.ant_n0 + st_dn,OBSData.ant_u0 + st_du);
[OBSData.transducer_e1,OBSData.transducer_n1,OBSData.transducer_u1] = ...
    deal(OBSData.ant_e1 + rt_de,OBSData.ant_n1 + rt_dn,OBSData.ant_u1 + rt_du);

%% Relative coordinate position of the reference center
switch SetModelMP.Other_functions.DatumENU
    case 1  % 1.Center position of sea surface antenna
        [SurE0Mean,SurN0Mean,SurU0Mean,SurE1Mean,SurN1Mean,SurU1Mean] = deal(mean(OBSData.ant_e0),...
            mean(OBSData.ant_n0),mean(OBSData.ant_u0),mean(OBSData.ant_e1),mean(OBSData.ant_n1),mean(OBSData.ant_u1));
        INIData.SeaCentre0 = [(SurE0Mean+SurE1Mean)/2,(SurN0Mean+SurN1Mean)/2,(SurU0Mean+SurU1Mean)/2];
        INIData.SeaCentre1 = [(SurE0Mean+SurE1Mean)/2,(SurN0Mean+SurN1Mean)/2,(SurU0Mean+SurU1Mean)/2];
        
        OBSData.atde0 = OBSData.ant_e0 - INIData.SeaCentre0(1);
        OBSData.atdn0 = OBSData.ant_n0 - INIData.SeaCentre0(2);
        OBSData.atde1 = OBSData.ant_e1 - INIData.SeaCentre1(1);
        OBSData.atdn1 = OBSData.ant_n1 - INIData.SeaCentre1(2);
        
        
        OBSData.mtde =   MP(OBSData.MTPSign)' - (INIData.SeaCentre0(1)+INIData.SeaCentre1(1))/2;
        OBSData.mtdn =   MP(OBSData.MTPSign+1)' - (INIData.SeaCentre0(2)+INIData.SeaCentre1(2))/2;
        
    case 2  % Relative position of seafloor station center
        INIData.SeaCentre = [mean(MP_ENU(1:3:end-3)),mean(MP_ENU(2:3:end-3)),mean(MP_ENU(3:3:end-3))];
        OBSData.mtde =   MP(OBSData.MTPSign)' - INIData.SeaCentre(1);
        OBSData.mtdn =   MP(OBSData.MTPSign+1)' - INIData.SeaCentre(2);
    case 3
        [SurE0Mean,SurN0Mean,SurU0Mean,SurE1Mean,SurN1Mean,SurU1Mean] = deal(mean(OBSData.ant_e0),...
            mean(OBSData.ant_n0),mean(OBSData.ant_u0),mean(OBSData.ant_e1),mean(OBSData.ant_n1),mean(OBSData.ant_u1));
        INIData.SeaCentre0 = [SurE0Mean,SurN0Mean,SurU0Mean];
        INIData.SeaCentre1 = [SurE1Mean,SurN1Mean,SurU1Mean];
        OBSData.atde0 = OBSData.transducer_e0 - INIData.SeaCentre0(1);
        OBSData.atdn0 = OBSData.transducer_n0 - INIData.SeaCentre0(2);
        OBSData.atde1 = OBSData.transducer_e1 - INIData.SeaCentre1(1);
        OBSData.atdn1 = OBSData.transducer_n1 - INIData.SeaCentre1(2);
    case 4
        [SurE0Mean,SurN0Mean,SurU0Mean,SurE1Mean,SurN1Mean,SurU1Mean] = deal(mean(OBSData.ant_e0),...
            mean(OBSData.ant_n0),mean(OBSData.ant_u0),mean(OBSData.ant_e1),mean(OBSData.ant_n1),mean(OBSData.ant_u1));
        INIData.SeaCentre0 = [(SurE0Mean+SurE1Mean)/2,(SurN0Mean+SurN1Mean)/2,(SurU0Mean+SurU1Mean)/2];
        INIData.SeaCentre1 = [(SurE0Mean+SurE1Mean)/2,(SurN0Mean+SurN1Mean)/2,(SurU0Mean+SurU1Mean)/2];
        OBSData.atde0 = OBSData.ant_e0 - INIData.SeaCentre0(1);
        OBSData.atdn0 = OBSData.ant_n0 - INIData.SeaCentre0(2);
        OBSData.atde1 = OBSData.ant_e1 - INIData.SeaCentre1(1);
        OBSData.atdn1 = OBSData.ant_n1 - INIData.SeaCentre1(2);
        INIData.FloorCentre = [mean(MP_ENU(1:3:end-3)),mean(MP_ENU(2:3:end-3)),mean(MP_ENU(3:3:end-3))];
        OBSData.mtde =   MP(OBSData.MTPSign)' - INIData.FloorCentre(1);
        OBSData.mtdn =   MP(OBSData.MTPSign+1)' - INIData.FloorCentre(2);
end

switch SetModelMP.Inv_model.ObsEqModel
    case 1
        %% 1.Calculate characteristic time
        L0                  = mean(MP_ENU(3:3:end-3));
        [INIData.V0,V0]     = deal(MeanVel(SVP));
        [INIData.T0,T0]     = deal(abs(2 * L0) / V0);
        OBSData.logTT       = log(OBSData.TT / T0);
        INIData.scale       = 10^-4 / T0;
end
%% 平滑矩阵
switch SetModelMP.Inv_model.DirOffset
    case 0
        switch SetModelMP.Inv_model.AdjGuiModel
            case 3
                Mu1 = SetModelMP.HyperParameters.Mu1;
                [ H ] = BS_base_2_derivative(MPNum,spdeg,knots,1,3,Mu1);
                INIData.H = H;
            case 6
                Mu1 = SetModelMP.HyperParameters.Mu1;
                [ H ] = BS_base_2_derivative2(MPNum,spdeg,knots,Mu1);
                H(1:MPNum(1),1:MPNum(1)) = pinv(INIData.ProCov);
                INIData.H = H;
        end
    case 1
        Mu1 = SetModelMP.HyperParameters.Mu1;
        [ H ] = BS_base_2_derivative(MPNum,spdeg,knots,1,3,Mu1);
        INIData.H = H;
end
%% Prior observation incidence angle, 
OBSData.PriTheta0 = zeros(N_shot,1);
OBSData.PriTheta1 = zeros(N_shot,1);

%% 
[INIData.PriorMP(MPNum(1)+1:MPNum(end)),INIData.PosteriMP(MPNum(1)+1:MPNum(end))] = deal(zeros(1,MPNum(end)-MPNum(1)));
end

