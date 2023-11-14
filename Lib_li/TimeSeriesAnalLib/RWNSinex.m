function RWNSinex(ReadPath,WritePath,para,PostionNameList)
% Create folders
indexList = strfind(WritePath,'\');
FilePath = WritePath(1:indexList(end));
if ~exist(FilePath,'dir')
    mkdir (FilePath)
end
% Read the defined configuration file
FidRead = fopen(ReadPath,'r');FidWrite = fopen(WritePath,'w');
while ~feof(FidRead)
    tline = fgetl(FidRead);   % Read each row of data
    % Determine whether the character contains "_dPos"
    if contains(tline,'_dPos')
        M_Strindex = strfind(tline,'M');
        MP_index =contains(PostionNameList,tline(M_Strindex:M_Strindex+2)); 
        MP = para(MP_index,:);
        tlineList = regexp(tline,'\s+','split');
        ENU_Index = find(contains(tlineList,'=')==1);
        for i =1:3
             tline = strrep(tline,tlineList{ENU_Index+i},num2str(MP(i),'%.4f'));
        end
        fprintf(FidWrite,[tline,'\n']);
    else
        fprintf(FidWrite,[tline,'\n']);
    end
end
fclose(FidRead);fclose(FidWrite);
end