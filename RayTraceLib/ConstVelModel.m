function [t1, x1, z1,L1,cos_alfa1,c0] = ConstVelModel(cos_alfa0,c0,a,t,x,z)
%% ConstVelModel(cos_alfa0,c0,a,t,x,z)
%% Function£ºconstant velocity tracing model

alfa0 = acos(cos_alfa0);      
if x < +inf
    tan_alfa0 = tan(alfa0);
    z1 = x*tan_alfa0 ;
    t1 = x/cos_alfa0/c0;
    x1 = x;
    L1 = sqrt(x1^2 + z1^2);
    cos_alfa1 = cos_alfa0;
    return;
elseif t < +inf
    sin_alfa0 = sin(alfa0);         
    t1 = t;                         
    z1 = sin_alfa0*t1*c0;   
    x1 = z1/tan(alfa0);             
    L1 = sqrt(x1^2 + z1^2);
    cos_alfa1 = cos_alfa0;
    return;
elseif z < +inf
    sin_alfa0 = sin(alfa0);       
    temp = z/sin_alfa0;
    t1 = temp/c0;                
    x1 = temp*cos_alfa0;  
    z1 = z;
    cos_alfa1 = cos_alfa0;
    L1 = sqrt(x1^2 + z1^2);
end