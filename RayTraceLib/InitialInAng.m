function p = InitialInAng(Var)
%% InitialInAng(Var)->intial values for tangent method ���߷���ʼֵ
F0  = Var.F0;
if Var.idx0 == 3
    %%��ֵ
    if Var.PriTheta == 0
        dis = norm([F0(2),F0(3)]);
        sin_theta0 = F0(2)/dis;
        
        theta0 = asin(sin_theta0)*180/pi;  %%��������ǳ�ֵ
        theta0 = abs(theta0);
        dtheta = 1;
    else
        theta0 = Var.PriTheta;
        dtheta = 0.1;
    end
    
    theta1=(theta0 - dtheta);   %��һ������Ƿ�Χ����
    theta2=(theta0 + dtheta);   %��һ������Ƿ�Χ����
    
    % �߶ȽǽǶ�����
    if theta1 < 0
        theta1 = 0.05;
    end
    if theta2 > 90
        theta2 = 89.9;
    end
    
    theta1 = theta1*pi/180;   %��һ������Ƿ�Χ����
    theta2 = theta2*pi/180;   %��һ������Ƿ�Χ����
    
    p(1) = theta1;
    p(2) = theta2;
    
elseif Var.idx0 == 2
    %[TODO]
elseif Var.idx0 == 1
    %[TODO]
end