function [H] = BS_base_2_derivative3(MPNum,spdeg,knots,smoothmodel,style)
%% 程序缺陷：假若参数给定中含有部分费B样条参数（需解决）(平滑因子的构建似乎出现问题)
% 参考以前的写的程序，平滑因子是当作虚拟观测用，还是当作先验信息用
% 我们将给出两种模式，一种是作为先验信息；一种是作为虚拟观测
PP = zeros(MPNum(end),MPNum(end));
switch style
    case 1
        %% B样条构建
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
        %% B样条一阶构建
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
        
        % 检验矩阵是否正定：1.是否为对称矩阵 2.特征值是否全为正数
        % issymmetric(RR(imp0(1)+1:imp0(end),imp0(1)+1:imp0(end)))
        % eig(RR(imp0(1)+1:imp0(end),imp0(1)+1:imp0(end)))
        
    case 3
        %% B样条二阶构建（公式）（似乎存在错误inv()）
        for j=1:length(knots)
            S=MPNum(j+1)-MPNum(j);
            Q=zeros(S-2,S);
            R=zeros(S-2,S-2);
            for i=1:1:S-2
                % 定义节knots点区间长度，h=t(i+1)-t(i)
                knotslist = knots{j};
                dk0=(knotslist(i+spdeg+1)-knotslist(i+spdeg))/3600;
                dk1=(knotslist(i+spdeg+2)-knotslist(i+spdeg+1))/3600;
                
                % 构建矩阵Q和R
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
            PP(MPNum(j)+1:MPNum(j+1),MPNum(j)+1:MPNum(j+1)) = K;
        end
        
        switch smoothmodel
            case 1
                H = PP;
            case 2
                H= chol(PP(MPNum(1)+1:MPNum(end),MPNum(1)+1:MPNum(end)));
        end
        % H 矩阵应为对称矩阵
        % 可能存在计算保留小数问题导致的，要强制性指定其为对称矩阵
        
    case 4
        %% B样条2阶构建（数值）
        % 根据参数位置行列确定积分上下限
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

