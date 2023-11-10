function str = ReplaceStr(textBlock,OldFixFile,NewFixFile)
%% 作用：更换字符串
%% ++++++++++++ Test Cold +++++++++++++++
% close all;clear all;clc;
% % Input:
% textBlock  = 'E:\GGithub\Github\日本数据\data_Tohoku2011-2020\initcfg\TOS2\TOS2.1911.meiyo_m5-initcfg.ini';
% OldFixFile = 'initcfg';
% NewFixFile = '3参数-fix';
% % Output: str = 'E:\GGithub\Github\日本数据\data_Tohoku2011-2020\3参数-fix\TOS2\TOS2.1911.meiyo_m5-fix.ini'
%% 
str = '';
strArray = regexp(textBlock, '\', 'split');  % 将字符串以'\'分开

% 将旧的文件名换成新的文件名
for i = 1:length(strArray)
    if strncmp(strArray(i),OldFixFile,length(OldFixFile))
        strArray{i} = NewFixFile;
    end
end

% 将换完后的字符串合并
for i = 1:length(strArray)
    if i == 1
        str = strArray{i};
    else
        str = strcat(str,'\');
        str = strcat(str,strArray{i});
    end
end
str = strrep(str,'initcfg','fix');