%% �ɶ�ȡdCentpos
function x0s = Extraction_x02(GlobalPar)
% ��ȡ�����ֵ
X0Par = GlobalPar.Model_parameter.MT_Pos;


StrName = fieldnames(X0Par);
CellNum = size(StrName,1);
X0Inf = struct2cell(X0Par);
x0s =[];
Loop = 0;
for i = 1:CellNum
    iCell = StrName(i);
    if contains(iCell,'d')
        Loop = Loop + 1;
        x0s = [x0s,X0Inf{i}(1:3)];
    end
end

end