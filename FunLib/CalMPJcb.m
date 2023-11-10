function [JCB,P,dX,dY,Qxx,Qyx,detalTOri,VirObs,slvidx,JCBLine] = CalMPJcb(OBSData,INIData,SetModelMP,SVP,MP,MPNum,knots)
spdeg = 3;
N_shot = INIData.Data_file.N_shot;
Jcb = sparse(N_shot,MPNum(end));
C = MeanVel(SVP);
%% Coordinate Jacobian matrix
e = -(OBSData.e0 + OBSData.e1) ./C;
Jcb(sub2ind([N_shot,MPNum(1)],1:N_shot,OBSData.MTPSign')) = e(:,1);
Jcb(sub2ind([N_shot,MPNum(1)],1:N_shot,OBSData.MTPSign'+1)) = e(:,2);
Jcb(sub2ind([N_shot,MPNum(1)],1:N_shot,OBSData.MTPSign'+2)) = e(:,3);

%% B-spline Jacobian matrix
BaseA_ST = INIData.BaseA_ST;
BaseA_RT = INIData.BaseA_RT;

alpha0_Ray = OBSData.alpha0_Ray;alpha1_Ray = OBSData.alpha1_Ray;
Z0_Ray = OBSData.Z0_Ray ; Z1_Ray = OBSData.Z1_Ray;
alpha0_Vessel = OBSData.alpha0_Vessel; alpha1_Vessel = OBSData.alpha1_Vessel;
Z0_Vessel = OBSData.Z0_Vessel; Z1_Vessel = OBSData.Z1_Vessel;

alfae0 = OBSData.alfae0; alfae1 = OBSData.alfae1;
Lambda0 = OBSData.Lambda0; Lambda1 = OBSData.Lambda1;
gammar10 = OBSData.gammar10; gammar20 = OBSData.gammar20;
gammar11 = OBSData.gammar11; gammar21 = OBSData.gammar21;
H0 = OBSData.H0;H1 = OBSData.H1;

[SubJcb0] = GradJcb(SetModelMP,BaseA_ST,MPNum,Lambda0,Z0_Ray,alpha0_Ray,Z0_Vessel,alpha0_Vessel,gammar10,gammar20,H0);
[SubJcb1] = GradJcb(SetModelMP,BaseA_RT,MPNum,Lambda1,Z1_Ray,alpha1_Ray,Z1_Vessel,alpha1_Vessel,gammar11,gammar21,H1);
Jcb(:,MPNum(1)+1:MPNum(end)) = - (SubJcb0 + SubJcb1);
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
    case 1
        Phi = zeros(N_shot,1);
        for DataNum = 1:N_shot
            index = OBSData.MTPSign(DataNum);
            Transducer_ENU_ST = [OBSData.transducer_e0(DataNum),OBSData.transducer_n0(DataNum),OBSData.transducer_u0(DataNum)];
            Transducer_ENU_RT = [OBSData.transducer_e1(DataNum),OBSData.transducer_n1(DataNum),OBSData.transducer_u1(DataNum)];
            SinPhi0 = (OBSData.transducer_u0(DataNum) - MP(index+2))/norm(MP(index:index+2) - Transducer_ENU_ST);
            SinPhi1 = (OBSData.transducer_u1(DataNum) - MP(index+2))/norm(MP(index:index+2) - Transducer_ENU_RT);
            Phi(DataNum) = (SinPhi0 + SinPhi1)/2;
        end
        Phi(TrueIndex,:) = [];
end
%% Solve model
dX = zeros(MPNum(end),1);
DeteleList = [];
slvidx = 1:MPNum(end);slvidx(DeteleList)= [];
JCB = Jcb(:,slvidx);
VirObs = sparse(MPNum(1)-3,length(slvidx));

for i = 1:MPNum(1)-3
    VirObs(i,i) = 1;VirObs(i,i+3) = -1;
end

R = INIData.H(MPNum(1)+1:MPNum(end),MPNum(1)+1:MPNum(end));
VirObs1  = sparse(MPNum(end)-MPNum(1),MPNum(end));
VirObs1(1:MPNum(end)-MPNum(1),MPNum(1)+1:MPNum(end)) = R;
VirObs1(:,DeteleList)=[];
JCB = [JCB;VirObs1];
JCBLine = size(JCB,1);
P = spdiags(Phi.^2,0,N_shot_Num,N_shot_Num);
sigma0 = sqrt(detalTOri'* P *detalTOri)/(N_shot_Num - MPNum(end));
P = blkdiag(P,spdiags(ones(MPNum(end)-MPNum(1),1),0,MPNum(end)-MPNum(1),MPNum(end)-MPNum(1)));
detalT_tmp = - R * MP(MPNum(1)+1:MPNum(end))';
detalTOri     = [detalTOri; detalT_tmp];

switch SetModelMP.Inv_model.AdjGuiModel
    case {1,2,3,5}
        dX=[];dY=[];Qxx=[];Qyx=[];
    case 4
        QXX = inv(JCB'*P*JCB);Dxx = QXX * sigma0^2;
        dx = QXX*JCB'*P*detalTOri;
        dX = dx(1:MPNum(1));dY = dx(MPNum(1)+1:length(slvidx));
        Qxx = QXX(1:MPNum(1),1:MPNum(1));Qyx = QXX(MPNum(1)+1:length(slvidx),1:MPNum(1));
end
end

