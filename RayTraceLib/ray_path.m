function [x,ray_length] = ray_path(t_angle,nlyr,layer_d,layer_s,sv_d,sv_s,y_d,y_s,l_dep,l_sv)

%   Calculation for ray path 
x=0;ray_length=0;
% PP = sin(theta)/SV_D  
pp=sin(t_angle)/sv_d; 

if(y_d==y_s)
    x=-1.0;
    disp("Warning A in ray_path");
    error('Warning A in ray_path');
end

k1=layer_s-1;
% layer for the deeper end             
lm=layer_d;

sn(k1:layer_d)=pp*l_sv(k1:layer_d); 
yd(k1:layer_d)=l_dep(k1:layer_d);

yd(k1) = y_s;    
sn(k1) = pp*sv_s;  
yd(layer_d) = y_d;    
sn(layer_d) = pp*sv_d;     

if max(sn(k1:layer_d)) >1.0||min(sn(k1:layer_d))<-1.0
    x=-1.0;
    error('Wraning B');
end

scn(k1:layer_d)=sqrt(1.0-sn(k1:layer_d).^2); 
rn(k1:layer_d-1)=scn(lm)./scn(k1:layer_d-1); 
rn(layer_d)=1.0;

for i=layer_s:layer_d
    j=i-1;
    dx=(yd(i)-yd(j))*(sn(i)+sn(j))/(scn(i)+scn(j));
    x=x+dx;
    ray_length=ray_length+rn(i)*dx/scn(j);
end
ray_length=ray_length/sn(lm);


end

