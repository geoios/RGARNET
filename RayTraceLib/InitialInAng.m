function p = InitialInAng(Var)
%% InitialInAng(Var)->intial values for tangent method 
F0  = Var.F0;
if Var.idx0 == 3
    %%初值
    if Var.PriTheta == 0
        dis = norm([F0(2),F0(3)]);
        sin_theta0 = F0(2)/dis;
        
        theta0 = asin(sin_theta0)*180/pi;  %% The initial value of the angle of incidence is reversed
        theta0 = abs(theta0);
        dtheta = 1;
    else
        theta0 = Var.PriTheta;
        dtheta = 0.1;
    end
    
    theta1=(theta0 - dtheta);   % Give a lower limit of the range of incidence
    theta2=(theta0 + dtheta);   % Gives an upper limit to the range of incidence
    
    % 高度角角度限制
    if theta1 < 0
        theta1 = 0.05;
    end
    if theta2 > 90
        theta2 = 89.9;
    end
    
    theta1 = theta1*pi/180;   % Give a lower limit of the range of incidence
    theta2 = theta2*pi/180;   % Gives an upper limit to the range of incidence
    
    p(1) = theta1;
    p(2) = theta2;
    
elseif Var.idx0 == 2
    %[TODO]
elseif Var.idx0 == 1
    %[TODO]
end
