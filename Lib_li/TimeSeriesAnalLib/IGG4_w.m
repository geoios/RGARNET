function p=IGG4_w(k2,k1,v)
%% IGG4 Weight functions
v = abs(v);
if v > k2 || v == k2
  p = 0;
elseif v < k1 || v == k1
  p = 1;
else
  p = k1 / v * ( (k2 - v) / (k2 - k1) )^2;
end