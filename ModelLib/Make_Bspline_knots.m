function [knots,MPNum,INIData] = Make_Bspline_knots(OBSData,SetModelMP,INIData)
BSpanModel  = 1;spdeg = 3;
BSpan = SetModelMP.Inv_parameter.nmp;
%% matrix is/isn't empty
if isempty(BSpan)
    knots=[];MPNum=[];INIData.BaseA_ST = [];INIData.BaseA_RT = [];
    return;
end
%% Time B-spline knote determination
% Calculate time related information for each section
sets = unique(OBSData.SET);
for i=1:length(sets)
    j=1;st0ss=[];stfss=[];
    for h=1:length(OBSData.SET)
        if strfind(OBSData.SET{h},sets{i})
            st0ss(j)=OBSData.ST(h);
            stfss(j)=OBSData.RT(h);
            j=j+1;
        end
        
    end
    st0s(i)=min(st0ss);
    stfs(i)=max(stfss);
end

%% 确定每个周期节点参数个数
% 1.Calculate the average duration of each session
setdurs = stfs-st0s;
setdur = mean(setdurs);
% 2. Two methods for determining the number of B-spline parameters
switch BSpanModel
    case 1   % (1)Specify the approximate segmentation time to segment the B-spline (in minutes)
        nestsum = fix(setdur./(BSpan*60));
    case 2  % (2)Directly specify the number of parameterizations
        nestsum = BSpan;
end
% 3.How many periods can the total observation duration be divided into
st0=min(OBSData.ST);stf=max(OBSData.RT);
obsdur=stf-st0;
nestdur=fix(obsdur/setdur);         % Total observation time/average period observation time


for i=1:length(BSpan)
    nknots(i)=nestsum(i)*nestdur;
end

for i=1:length(nknots)
    knots{i}=linspace(st0,stf,nknots(i)+1);
end
MPNum =zeros(1,length(BSpan));
for i=1:length(knots)
    if nknots(i)==0
        knots{i}=[];
        continue;
    end
    
    rmknot=[];
    
    % Determine whether there are long-term observation discontinuities in the observation data
    for m = 1:length(sets)-1
        index = find(knots{i}>stfs(m) & knots{i}<st0s(m+1));
        if length(index) > 2*(spdeg+2)
            rmknot = [rmknot,index(spdeg+2:end-spdeg-1)];
        end
    end
    if ~isempty(rmknot)
        knots{i} (rmknot)=[];
    end
    
    dkn=(stf-st0)/nknots(i);
    n=1;
    for j=-spdeg:1:-1
        addkn0(n)=st0+dkn*j;
        n=n+1;
    end
    for j=1:1:spdeg
        addknf(j)=stf+dkn*j;
    end
    knots{i}=[addkn0,knots{i},addknf];
    MPNum(i) = length(knots{i})-spdeg-1;
end
%% Constructing a Prior B-Spline Matrix
ST = OBSData.ST;RT = OBSData.RT;
N_shot = INIData.Data_file.N_shot;
BMPNum = cumsum(MPNum);BMPNum = [0,BMPNum];
BaseA_ST = zeros(N_shot,BMPNum(end));BaseA_RT = zeros(N_shot,BMPNum(end));

for knotsIndex = 1:length(MPNum)
    BMP = zeros(1,BMPNum(knotsIndex+1) - BMPNum(knotsIndex));
    for BMPindex = 1:BMPNum(knotsIndex+1) - BMPNum(knotsIndex)
        BMP(BMPindex) = 1;
        for ShotNum = 1:N_shot
            [BaseA_ST(ShotNum,BMPNum(knotsIndex) + BMPindex)] = Bspline_Function2(ST(ShotNum),BMP,knots{knotsIndex},spdeg);
            [BaseA_RT(ShotNum,BMPNum(knotsIndex) + BMPindex)] = Bspline_Function2(RT(ShotNum),BMP,knots{knotsIndex},spdeg);
        end
        BMP(BMPindex) = 0;
    end
end
INIData.BaseA_ST = BaseA_ST;INIData.BaseA_RT = BaseA_RT;
end

