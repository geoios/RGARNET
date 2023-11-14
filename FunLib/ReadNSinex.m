%% ReadSeafloorNetSolution-->Seafloor network Solution exchange format
function GlobalPar = ReadNSinex(ConfigFile) 

% Read the defined configuration file
fid = fopen(ConfigFile);

StorageName = 'Struct';


while ~feof(fid)
    tline = fgetl(fid); 
    if strfind(tline,'[')
        ModelName = StandareStr(tline);
        TempName = ModelName;
        
        while 1
            tline = fgetl(fid); 
            % When the line content is empty, it is read out of the module
            if isempty(tline)     
                break
            end
            StrInf = split(tline,' = ');
            % If the line content is ':', the split is re-divided
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
            %% There is a '-' in the date, therefore, special handling is required
            IsMinus = strfind(VarInf,' -');
            %%
            [StrPer,NumPer] = StrAnalisy(VarInf);
            if NumPer == 1 & IsMinus
%                 VarInf = strrep(VarInf,' ','');
                VarInf = str2num(VarInf);
                eval([StorageName,'.',ModelName '.' VarName  '=' 'VarInf;']);
            else
                eval([StorageName,'.',ModelName '.' VarName  '= VarInf;']); 
            end
        end
    end
end
eval(['GlobalPar' ,'=' , StorageName ';']);
fclose(fid);
end