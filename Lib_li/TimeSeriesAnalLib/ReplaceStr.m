function str = ReplaceStr(textBlock,OldFixFile,NewFixFile)
%% What it does: Replace strings
%% 
str = '';
strArray = regexp(textBlock, '\', 'split');  % Separate the strings by ''

% Replace the old file name with the new file name
for i = 1:length(strArray)
    if strncmp(strArray(i),OldFixFile,length(OldFixFile))
        strArray{i} = NewFixFile;
    end
end

% Merge the swapped strings
for i = 1:length(strArray)
    if i == 1
        str = strArray{i};
    else
        str = strcat(str,'\');
        str = strcat(str,strArray{i});
    end
end
str = strrep(str,'initcfg','fix');