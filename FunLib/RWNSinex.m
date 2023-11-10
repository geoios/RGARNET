function RWNSinex(ReadPath,WritePath,para_fix,PostionNameList)
% create folder
indexList = strfind(WritePath,'\');
FilePath = WritePath(1:indexList(end));
if ~exist(FilePath,'dir')
    mkdir (FilePath)
end
% Read the formulated configuration file
FidRead = fopen(ReadPath,'r');FidWrite = fopen(WritePath,'w');
while ~feof(FidRead)
    tline = fgetl(FidRead); 
    if contains(tline,'Center_ENU')
        fix_avg = mean(para_fix,1);Subline = [];
        for i = 1:3
            Subline = [Subline,'  ',sprintf('%.4f',fix_avg(i))];
        end
        tline = [' Center_ENU   =',Subline];
        fprintf(FidWrite,[tline,'\n']);
        continue;
    end
    
    if contains(tline,'_dPos')
        M_Strindex = strfind(tline,'M');
        MP_index =contains(PostionNameList,tline(M_Strindex:M_Strindex+2));
        MP = para_fix(MP_index,:);
        
        Subtline = [];
        for i = 1:3
            Subtline = [Subtline,'  ',sprintf('% 10.4f',MP(i))];
        end
        for i = 4:6
            Subtline = [Subtline,'  ',sprintf('% 10.4f',0)];
        end
        for j = 7:9
            Subtline = [Subtline,'  ',sprintf('% 10.3e',0)];
        end
        tline = [' ',PostionNameList{MP_index},'_dPos    =  ',Subtline];
        fprintf(FidWrite,[tline,'\n']);
    elseif contains(tline,'dCentPos')
        Subtline = [];
        for i = 1:3
            Subtline = [Subtline,'  ',sprintf('% 10.4f',0)];
        end
        for i = 4:6
            Subtline = [Subtline,'  ',sprintf('% 10.4f',3)];
        end
        for j = 7:9
            Subtline = [Subtline,'  ',sprintf('% 10.3e',0)];
        end
        tline = [' dCentPos    =  ',Subtline];
        fprintf(FidWrite,[tline,'\n']);
    else
        fprintf(FidWrite,[tline,'\n']);
    end
end
fclose(FidRead);fclose(FidWrite);
end