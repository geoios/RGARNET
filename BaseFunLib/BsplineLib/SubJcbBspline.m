function [dmp] = SubJcbBspline(mp,tt,knots,spdeg,yy)

dmp=mp;
MMP=zeros(length(dmp),1);
for i=1:20
    
    for j=1:1:length(tt)
        [Value(j)] = sub1(dmp,tt(j),spdeg,knots);
         YY(j)=yy(j)-Value(j);
    end
    
    for m=1:length(dmp)
        MMP(m)=MMP(m)+1;
        for k=1:1:length(tt)
            [value(k)] = sub1(MMP,tt(k),spdeg,knots);
        end
        Jcb(:,m)=(Value-value);
         MMP(m)=MMP(m)-1;
        
    end
    dd0= inv(Jcb'*Jcb)*Jcb'*YY';
    dmp=dmp-dd0;
    max(dd0)
    if max(dd0)<1
        break;
    end
end
i
end

