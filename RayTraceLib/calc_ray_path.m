function [t_ag,t_tm] = calc_ray_path(distance,y_d,y_s,l_depth,l_sv,nlyr)
%%% This Function is GARPOS Ray Line tracking rewrite
loop1=200;loop2=20;
eps1=10^-7;eps2=10^-14;

%% 
layer_thickness=l_depth(2:nlyr)-l_depth(1:nlyr-1); 
layer_sv_trend=(l_sv(2:nlyr)-l_sv(1:nlyr-1))./layer_thickness;
%% 
[sv_d, layer_d]=layer_setting(nlyr,y_d,l_depth,l_sv,layer_sv_trend); 
[sv_s, layer_s]=layer_setting(nlyr,y_s,l_depth,l_sv,layer_sv_trend); 
%% 
x_hori=0;r_nm=0;
tadeg=[0,20,40,60,70,70];
ta_rough=pi*(180-tadeg)/180;
for i=1:5
    if i==5
        break;
    end
    j=i+1;
    %% 
    [x_hori(j),a0]=ray_path(ta_rough(j),nlyr,layer_d,layer_s,sv_d,sv_s,y_d,y_s,l_depth,l_sv); 
    % negative distance does not make sense  
    if x_hori(j)<0
        continue;
    end
    
    % Only if x_hori(i) <= distance <= x_hori(i+1), 
    % takeoff angle should be between ta_rough(i) and ta_rough(i+1) 
    diff1=distance-x_hori(i);
    diff2=x_hori(j)-distance;
    if diff1*diff2<0
        continue;
    end
    r_nm=1;
    x1=x_hori(i);x2=x_hori(j);
    t_angle1=ta_rough(i);t_angle2=ta_rough(j);
    % detailed search for takeoff angle (conv. criteria is "eps1")  
    for k=1:loop1
        x_diff=x1-x2; % horizontal diff. of 2 paths 
        if(abs(x_diff)<eps1)
            break;
        end       
        % calculate horizontal distance (x0) for averaged takeoff angle (t_angle0)  
        %  x0 should be x1 or x2 (depending on the sign of x0-distance)  
        t_angle0 = (t_angle1 + t_angle2)/2;
        [x0, a0]=ray_path(t_angle0, nlyr, layer_d, layer_s, sv_d, sv_s, y_d, y_s, l_depth, l_sv);
        a0 = -a0;
        t0 = distance - x0;
        if t0*diff1 > 0.0
            x1 = x0;
            t_angle1 = t_angle0;
        else
            x2 = x0;
            t_angle2 = t_angle0;
        end
    end
    
    diff_true0=abs((distance - x0)/distance);
    
    for k=1:loop2
        % delta_angle is the angle for arc-length of (x0-distance) delta_angle 
        delta_angle = (distance - x0)/a0 ; % 
        t_angle = t_angle0 + delta_angle; 
        % check convergence ("eps2") 
        
        if(abs(delta_angle) <eps2)
            break;
        end
        
        [x0, a0]=ray_path(t_angle, nlyr, layer_d, layer_s, sv_d, sv_s, y_d, y_s, l_depth,l_sv);
        a0 = -a0;
        
        diff_true1 = abs((distance - x0)/distance);
        if(diff_true0 <= diff_true1)
            t_angle = t_angle0;
            break;
        end
        % check convergence ("eps2")  
        if(diff_true1 < eps2)
            break;
        end
    end
    break;
end

if r_nm==0
    disp('Distance:%d\tX_hori:%d\t TA_rough:%d\tDepth,Sound Speed',distance,x_hori,ta_rough);
end
t_ag = t_angle;
t_tm=calc_travel_time(t_angle,nlyr,layer_d,layer_s,sv_d,sv_s,y_d,y_s,l_depth,l_sv,layer_sv_trend,layer_thickness);
end
