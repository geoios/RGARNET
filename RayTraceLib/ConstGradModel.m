function [t1,x1,z1,L1,cos_alfa1,c1] = ConstGradModel(cos_alfa0,c0,a,t,x,z)
%% ConstGradModel(cos_alfa0,c0,a,t,x,z)->constant grandient tracing model
%alfa0     = acos(cos_alfa0);    
% sin_alfa0 = sin(alfa0); 
sin_alfa0 = sqrt(1 - cos_alfa0^2);
P  = cos_alfa0/c0;
IP = 1/P;
R  = -IP/a;

if z < inf
    c1        = a * z + c0;
    cos_alfa1 = P * c1;   
%   alfa1     = acos(cos_alfa1);   
%   sin_alfa1 = sin(alfa1);      
    sin_alfa1 = sqrt(1 - cos_alfa1^2);
    %
    x1 = R * (sin_alfa1 - sin_alfa0);
    %x1 = z/tan((alfa0+alfa1)/2);                                                      
    t1 = (log((1+sin_alfa0)/(1-sin_alfa0)) - log((1+sin_alfa1)/(1-sin_alfa1)))/(2*a);  
%   t1 = abs(t1);        
    z1 = z;       
    L1 = sqrt(x1^2 + z1^2);
    return;
end
if x < inf
    tan0 = sin_alfa0/cos_alfa0;
    %z=x*tan(alfa0);
    z  = x * tan0;
    c1 = c0 + a*z;
    cos_alfa1 = P*c1;  
    alfa1 = acos(cos_alfa1);      
    %sin_alfa1 = sin(alfa1);       
    sin_alfa1 = sqrt(1-cos_alfa1^2);
    % z1 = x*tan(alfa0);                       
    z1 = (c1 - c0)/a;   
    x1 = x;   
    % t1 = x/cos_alfa0/c0;
    t1 = (log((1+sin_alfa0)/(1-sin_alfa0)) - log((1+sin_alfa1)/(1-sin_alfa1)))/(2*a*c0);
    t1 = abs(t1);    
    L1 = x/cos((alfa0+alfa1)/2);
    return;
end
if t < inf
    t1 = t;     
    A = log((1+sin_alfa0)/(1-sin_alfa0)) - 2*a*t;
    sin_alfa1 = (exp(A) - 1)/(exp(A) + 1);      
    cos_alfa1 = sqrt(1-sin_alfa1^2);     
    c1 = cos_alfa1/cos_alfa0*c0;    

    z1 = (c1 - c0)/a;  
    x1 = R*(sin_alfa1 - sin_alfa0);
    %x1 = z1*(cos_alfa0+cos_alfa1)/(sin_alfa0 + sin_alfa1);  
    L1 = z1/sin_alfa0; 
end