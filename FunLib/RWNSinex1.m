function RWNSinex1(ReadPath,WritePath,para,used_shot)
% create folder
indexList = strfind(WritePath,'\');
FilePath = WritePath(1:indexList(end));
if ~exist(FilePath,'dir')
    mkdir (FilePath)
end
% Read the formulated configuration file
FidRead = fopen(ReadPath,'r');FidWrite = fopen(WritePath,'w');
while ~feof(FidRead)
    tline = fgetl(FidRead);   %Read each row of data
    if contains(tline,'used_shot')
        tline = [' used_shot   =',sprintf('% 6d',used_shot)];
        fprintf(FidWrite,[tline,'\n']);
        continue;
    end
    % %Determine if the character contains' _dPos'"
    if contains(tline,'dCentPos')
        MP = para;
        Subtline = [];
        for i = 1:6
            Subtline = [Subtline,'  ',sprintf('%10.4f',MP(i))];
        end
        for j = 7:9
            Subtline = [Subtline,'  ',sprintf('%10.3e',MP(j))];
        end
        Subtline = strip(Subtline,'right');
        tline = [' dCentPos    =',Subtline];
        fprintf(FidWrite,[tline,'\n']);
    else
        fprintf(FidWrite,[tline,'\n']);
    end
end
fclose(FidRead);fclose(FidWrite);
end

