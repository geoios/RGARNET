function p=IGG8_w(k1,k2,v,c)
%% IGG8 Weight functions
V = abs(v);
if V > k1
   p = 0;
elseif V < k2 
   p = 1;
else
   p = c^(k2-V); 
end