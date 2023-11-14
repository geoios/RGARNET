function [DataStruct] = DataTable2DataStruct(DataTable)

VariableNames=DataTable.Properties.VariableNames;
for i=1:length(VariableNames)
    if strncmp(VariableNames{i},'Var',3)
        % If there is no corresponding field for the data in the table, the system defaults to "Var1, Var2,...".
        continue;
    else
       eval(['DataStruct.',VariableNames{i},'=','DataTable.',VariableNames{i},';']);
    end
end
end

