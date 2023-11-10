function GlobalPar = ReadSetINI(ConfigFile)
%% ReadSeafloorNetSolution-->Seafloor network Solution exchange format
% Read Configuration File and Return Global Variables£¨GlobalPar£©
% Read the Formulated Configuration File
fid = fopen(ConfigFile);

StorageName = 'Struct';

FileOrdorList = [];
while ~feof(fid)
    tline = fgetl(fid);   % Read each row of data
    FileOrdorList = [FileOrdorList;ftell(fid)];
    if strfind(tline,'[')
        ModelName = StandareStr(tline);
        TempName = ModelName;
        
        while 1
            tline = fgetl(fid);   % Read each row of data
            FileOrdorList = [FileOrdorList;ftell(fid)];
            % Jump out of module reading when line content is empty
            if feof(fid);break;end
            if contains(tline,'[')
                fseek(fid,FileOrdorList(end-1),'bof');
                break
            end
            if isempty(tline) || contains(tline,'#')
                continue;
            end
            StrInf = split(tline,' = ');
            % Re split when the line content is': '
            if length(StrInf) == 1
                StrInf  = split(tline,':');
                VarName = StrInf{1};
                VarName = StandareStr(VarName);
                ModelName = [ModelName,'.',VarName];
                continue
            else
                %                ModelName =  TempName;
            end
            VarName = StrInf{1};
            VarName = StandareStr(VarName);
            VarInf  = StrInf{2};
            %             VarInf  = strrep(VarInf,'-',' -');
            %% There is the "-" in the date, therefore special handling is required
            IsMinus = strfind(VarInf,' -');
            %%
            [StrPer,NumPer] = StrAnalisy(VarInf);
            if isempty(str2num(VarInf))
                eval([StorageName,'.',ModelName '.' VarName  '= VarInf;']);
            else
                if NumPer == 1 & IsMinus
                    VarInf = str2num(VarInf);
                    eval([StorageName,'.',ModelName '.' VarName  '=' 'str2num(VarInf);']);
                else
                    eval([StorageName,'.',ModelName '.' VarName  '= str2num(VarInf);']);
                end
            end
        end
    end
end
eval(['GlobalPar' ,'=' , StorageName ';']);
fclose(fid);
end