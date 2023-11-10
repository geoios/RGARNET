function [DataStruct] = DataTable2DataStruct(DataTable)

VariableNames=DataTable.Properties.VariableNames;
for i=1:length(VariableNames)
    if strncmp(VariableNames{i},'Var',3)
        % 表中数据没有对应没有字段，系统默认为"Var1、Var2，..."无用需剔除，有用则取消
        continue;
    else
       eval(['DataStruct.',VariableNames{i},'=','DataTable.',VariableNames{i},';']);
    end
end
end

