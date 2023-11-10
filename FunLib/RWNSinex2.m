function RWNSinex2(ReadPath,WritePath,para,PostionNameList,used_shot)
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
    if contains(tline,'Center_ENU')
        fix_avg = mean(para(:,1:3),1);Subline = [];
        for i = 1:3
            Subline = [Subline,'  ',sprintf('%10.4f',fix_avg(i))];
        end
        tline = [' Center_ENU   =',Subline];
        fprintf(FidWrite,[tline,'\n']);
        continue;
    end
    
    
 % Determine if the character contains' _dPos'"
    if contains(tline,'_dPos')
       
        M_Strindex = strfind(tline,'M');
        MP_index = contains(PostionNameList,tline(M_Strindex:M_Strindex+2)); 
        MP = para(MP_index,:);
        Subtline = [];
        for i = 1:6
            Subtline = [Subtline,'  ',sprintf('%10.4f',MP(i))];
        end
        for j = 7:9
            Subtline = [Subtline,'  ',sprintf('%10.3e',MP(j))];
        end
        Subtline = strip(Subtline,'right');
        tline = [' ',PostionNameList{MP_index},'_dPos    =',Subtline];
        fprintf(FidWrite,[tline,'\n']);
    else
        fprintf(FidWrite,[tline,'\n']);
    end
end
fclose(FidRead);fclose(FidWrite);
end