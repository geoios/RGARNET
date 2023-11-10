function [T,Y,Z,L,theta,Iteration,RayInf] = P2PInvRayTrace_CalGra(S,R,PF,PriTheta)

S(3) = S(3) + PF(1,1);
R(3) = R(3) + PF(1,1);
PF(:,1) = PF(:,1) - PF(1,1);

[S,R] = PreProcessingPoints(S,R);

% for sound ray tracing
Horizontal = norm(S(1:2) - R(1:2));
Depth      = R(3) - S(3);

% In most cases, the tracing is not started from the sea surface
if S(3) > 0
    PF = SplitPF(PF,S(3),PF(end,1));
end

[T,Y,Z,L,theta,Iteration,RayInf] = InvRayTrace(PF,+inf,Horizontal,Depth,PriTheta);

SVPLayerNum = size(PF,1);
gammar1 = 0;gammar2 = 0;BreakLoop = 0;Depth2 = 350;
for i = 1: SVPLayerNum -1
    C0 = PF(i,2);C1 = PF(i+1,2);G = PF(i,4);U0 = PF(i,1);U1 = PF(i+1,1);
    if U1 > Depth
        U1 = Depth;C1 = C0 + (Depth-U0)*G;
        BreakLoop = 1;
    elseif U1 > Depth2
        U1 = Depth2;C1 = C0 + (Depth2-U0)*G;
        BreakLoop = 1;
    end
    
    if G ==0
        SubGamma1 = (U1 - U0)/C0^2;
        SubGamma2 = (U1^2 - U0^2)/(2 * C0^2);
    else
        SubGamma1 = (U1 - U0)/(C0 * C1);
        SubGamma2 = G^-2 * log(C1/C0) - (C0/G - U0) * (U1 - U0) * (C0 * C1)^-1;
    end
    gammar1  = gammar1 + SubGamma1;
    gammar2  = gammar2 + SubGamma2;
    if BreakLoop == 1
        break;
    end
end
RayInf.gammar1 = gammar1;RayInf.gammar2 = gammar2;


%% Cal lambda value
snellC = RayInf.alfae/RayInf.ce;RayInf.snellC = snellC;
cos_betaList = cos(asin(snellC .* PF(:,2)));
RayInf.cos_AvgBeta = sum(cos_betaList.*PF(:,3))/sum(PF(:,3));

end