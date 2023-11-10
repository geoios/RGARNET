function [OBSData] = OutPutField_0(OBSData)

SaveField = {'SET','LN','MT','TT','ResiTT','TakeOff','gamma','flag','ST','ant_e0','ant_n0','ant_u0',...
    'head0','pitch0','roll0','RT','ant_e1','ant_n1','ant_u1','head1','pitch1','roll1','GradT','GradVe','GradVn','GradRe','GradRn'};
FieldList = fieldnames(OBSData);
for index = 1:length(FieldList)
    FieldName = FieldList{index};
    if isempty(find(strcmp(SaveField,FieldName)))
        OBSData = rmfield(OBSData,FieldName);
    end
end
end

