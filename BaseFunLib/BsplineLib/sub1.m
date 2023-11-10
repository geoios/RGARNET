function [Value] = sub1(mp,Time,spdeg,knots)

Value=0;
for i=1:length(mp)
    Value=Value+mp(i)*Bbase(i,spdeg,Time,knots{1});
end


end

