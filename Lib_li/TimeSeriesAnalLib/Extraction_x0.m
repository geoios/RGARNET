function x0s = Extraction_x0(GlobalPar,SingleOrAll)
%% 作用：获得日本解算结果
% case0；将日本解算结果读成'1*n'的形式
% case1：将日本解算结果读成'n*3'的形式，即每一行代表一个海底点坐标
%%
X0Par   = GlobalPar.Model_parameter.MT_Pos;  % 提取坐标初值
StrName = fieldnames(X0Par);
CellNum = size(StrName,1);
X0Inf   = struct2cell(X0Par);
switch SingleOrAll
    case 0
        % 将日本坐标读成'1*n'的形式
        x0s   = [];
        Loop  = 0;
        for i = 1:CellNum
            iCell = StrName(i);
            if contains(iCell,'M')
                Loop = Loop + 1;
                x0s = [x0s,X0Inf{i}(1:3)];
            end
        end
    case 1
        % 将日本坐标读成每一行代表一个海底点坐标的形式，即'n*3'的形式
        Loop  = 0;
        for i = 1:CellNum
            iCell = StrName{i};
            if contains(iCell,'M')
                SPNo = iCell(2:3);
                Loop = Loop + 1;
                x0s(Loop,:) = X0Inf{i}(1:3);
            end
        end
end