function [y] = Bbase_Clark(k,spdeg,t,nchoosekList)
y=0;
for j=0:spdeg-k
y=y+(-1)^j*nchoosekList(j+1)*(t+spdeg-k-j)^spdeg;
end
y=y*prod([1:spdeg])^-1;
end

