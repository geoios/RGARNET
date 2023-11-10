function [value] = Read_Ini_File(FilePath,key)
%首先判断配置文件是否存在
value = [] ;
if(exist(FilePath,'file') ~= 2)
    return;
end
%检查文件中有无key值，如果有则直接读取并返回，否则返回''
fid = fopen(FilePath);
while ~feof(fid)
    tline = fgetl(fid);
    if ~ischar(tline) || isempty(tline)
        %跳过无效行
        continue;
    end
    tmp=tline;
    tline(find(isspace(tline))) = []; %删除行中的空格
    Index = strfind(tline, [key '=']);
    j=0;
    if ~isempty(Index)
        %如果找到该配置项，则读取对应的value值
        ParamName = strsplit(tmp, {'=',' '});
        for i=1:size(ParamName,2)
            Index=strfind(ParamName{i}, key);
            if ~isempty(Index)
                j=i;
            end
        end
        k=1;
        try
            for i=j+1:1:j+9
                value(k)=str2num(ParamName{i});
                k=k+1;
            end
            break;
        catch
            for i=j+1:1:length(ParamName)
                value{k}=ParamName{i};
                k=k+1;
            end
        end
    end
end
fclose(fid); %关闭文件
end





