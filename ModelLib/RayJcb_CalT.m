function [TT,theta] = RayJcb_CalT(S,R,PF,PriTheta)
RayMethod = 2;
switch RayMethod
    case 1
        [TT,~,~,~,theta]= P2PInvRayTrace(S,R,PF,PriTheta);
    case 2
        YY = norm(S(1:2)-R(1:2));
        [~,TT]=calc_ray_path(YY,-R(3),-S(3),PF(:,1),PF(:,2),size(PF,1));
        theta = 0;
        
end
end

