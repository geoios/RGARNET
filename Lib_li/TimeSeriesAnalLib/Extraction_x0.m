function x0s = Extraction_x0(GlobalPar,SingleOrAll)
%% ���ã�����ձ�������
% case0�����ձ�����������'1*n'����ʽ
% case1�����ձ�����������'n*3'����ʽ����ÿһ�д���һ�����׵�����
%%
X0Par   = GlobalPar.Model_parameter.MT_Pos;  % ��ȡ�����ֵ
StrName = fieldnames(X0Par);
CellNum = size(StrName,1);
X0Inf   = struct2cell(X0Par);
switch SingleOrAll
    case 0
        % ���ձ��������'1*n'����ʽ
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
        % ���ձ��������ÿһ�д���һ�����׵��������ʽ����'n*3'����ʽ
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