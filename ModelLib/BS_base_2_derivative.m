function [H] = BS_base_2_derivative(MPNum,spdeg,knots,smoothmodel,style,Mu1)
PP = zeros(MPNum(end),MPNum(end));
switch style
    case 1
        %% B-spline 0-order construction
        syms T
        BB{1} = 1/6 * T^3;
        BB{2} = 1/6*(-3*T^3+3*T^2+3*T+1);
        BB{3} = 1/6*(3*T^3-6*T^2+4);
        BB{4} = 1/6*(-T^3+3*T^2-3*T+1);
        
        for k = 1 : MPNum(end) - MPNum(1)
            for l = 1:MPNum(end) - MPNum(1)
                if abs(k-l)<4
                    for m=1:4 - abs(k - l)
                        y = BB{m} * BB{m + abs(k-l)};
                        PP(MPNum(1)+k,MPNum(1)+l) = PP(MPNum(1) + k,MPNum(1) + l) + int(y,T,0,1);
                    end
                else
                    PP(MPNum(1) + k,MPNum(1) + l) = 0;
                end
            end
        end
        
        H = PP;
    case 2
        %% B-spline 1-order construction
        syms T
        BB{1}=0.5 * (-T^2 + 2 * T - 1);
        BB{2}=0.5 * (3 * T^2 - 4 * T);
        BB{3}=0.5 * (-3 * T^2 + 2 * T + 1);
        BB{4}=0.5 * r^2;
        
        for k=1:MPNum(end)-MPNum(1)
            for l=1:MPNum(end)-MPNum(1)
                if abs(k-l)<4
                    for m=1:4-abs(k-l)
                        y=BB{m}*BB{m+abs(k-l)};
                        PP(MPNum(1)+k,MPNum(1)+l)=PP(MPNum(1)+k,MPNum(1)+l)+int(y,T,0,1);
                    end
                else
                    PP(MPNum(1)+k,MPNum(1)+l)=0;
                end
            end
        end
        switch smoothmodel
            case 1
                H = PP;
            case 2
                R = chol(PP(MPNum(1)+1:MPNum(end),MPNum(1)+1:MPNum(end)));
                H = R;
        end
        
        
    case 3
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
        
        switch smoothmodel
            case 1
                H = PP;
            case 2
                H= chol(PP(MPNum(1)+1:MPNum(end),MPNum(1)+1:MPNum(end)));
        end
        
    case 4
         %% B-spline 2-order construction
        BB{1} = T;
        BB{2} = -3 * T + 1;
        BB{3} = 3 * T - 2;
        BB{4} = - T + 1;
        
        for k=1:MPNum(end)-MPNum(1)
            for l=1:MPNum(end)-MPNum(1)
                if abs(k-l)<4
                    for m=1:4-abs(k-l)
                        Y=BB{m}*BB{m+abs(k-l)};
                        PP(MPNum(1)+k,MPNum(1)+l) = PP(MPNum(1)+k,MPNum(1)+l)+int(Y,T,0,1);
                    end
                else
                    PP(MPNum(1)+k,MPNum(1)+l) = 0;
                end
            end
        end
        
        switch smoothmodel
            case 1
                H = PP;
            case 2
                H = chol(PP(MPNum(1)+1:MPNum(end),MPNum(1)+1:MPNum(end)));
        end
end
end

