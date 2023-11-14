function [PP] = BS_base_2_derivative2(MPNum,spdeg,knots,Mu1)

%% B-spline second-order construction
for j=1:length(knots)
    S=MPNum(j+1)-MPNum(j);
    Q=zeros(S-2,S);
    R=zeros(S-2,S-2);
    for i=1:1:S-2
        
        knotslist = knots{j};
        dk0=(knotslist(i+spdeg+1)-knotslist(i+spdeg))/3600;
        dk1=(knotslist(i+spdeg+2)-knotslist(i+spdeg+1))/3600;
      
        Q(i,i)=1/dk0;
        Q(i,i+1)=-1/dk0-1/dk1;
        Q(i,i+1+1)=1/dk1;
        if i>=2
            R(i,i-1)=1/6*dk0;
            R(i-1,i)=1/6*dk0;
        end
        R(i,i)=1/3*(dk0+dk1);
    end
    subR = chol(R);
    K=Q'*(subR')*subR*Q;
    PP(MPNum(j)+1:MPNum(j+1),MPNum(j)+1:MPNum(j+1)) = K*Mu1(j);
end

end

