function [FilePath] = JumpFolder(FilePath)
if nargin<1 || isempty(FilePath)
    ScriptPath      = mfilename('fullpath');      % 脚本位置
    [SubFilePath] = fileparts(ScriptPath);      % 文件夹位置
    [FilePath] = fileparts(SubFilePath); 
end
cd(FilePath);
end

