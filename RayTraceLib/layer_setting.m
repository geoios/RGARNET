function [sv,layer_n] = layer_setting(nlyr, depth, l_depth, l_sv, l_sv_trend)
for i=2:1:nlyr
    if l_depth(i)>=depth
        layer_n=i;
        break;
    end
end
if i==nlyr+1
    disp('b %d\t%d',depth,l_depth);
end

sv=l_sv(layer_n)+(depth-l_depth(layer_n))*l_sv_trend(layer_n-1);

end

