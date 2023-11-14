function [FilePath] = JumpFolder(FilePath)
if nargin<1 || isempty(FilePath)
    ScriptPath      = mfilename('fullpath');      % Script location
    [SubFilePath] = fileparts(ScriptPath);      % Folder location
    [FilePath] = fileparts(SubFilePath); 
end
cd(FilePath);
end

