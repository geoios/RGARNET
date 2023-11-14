function [value] = Read_Ini_File(FilePath,key)
%First, determine whether the configuration file exists
value = [] ;
if(exist(FilePath,'file') ~= 2)
    return;
end
%Check if there is a key value in the file, if there is one, read it directly and return, otherwise return ''
fid = fopen(FilePath);
while ~feof(fid)
    tline = fgetl(fid);
    if ~ischar(tline) || isempty(tline)
        % Skip invalid lines
        continue;
    end
    tmp=tline;
    tline(find(isspace(tline))) = []; % Remove spaces in rows
    Index = strfind(tline, [key '=']);
    j=0;
    if ~isempty(Index)
        % If the corresponding configuration item is found, the corresponding value is read
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
fclose(fid);
end





