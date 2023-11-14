%% ReadSeafloorNetSolution-->Seafloor network Solution exchange format
function GlobalPar = ReadNSinex(StandardFile) 

fid = fopen(StandardFile);
GlobalPar.FileName = StandardFile;
StorageName = 'GlobalPar.';
DataFlag =  0;
while ~feof(fid)
    tline = fgetl(fid);  
    if strfind(tline,'[')
        ModelName = StandareStr(tline);
        ModelName = [StorageName ModelName,'.'];
        while 1
            tline = fgetl(fid); 
            if isempty(tline)     
                break
            end
            if tline == -1
                break
            else
                StrInf = split(tline,' = ');
            end
            if length(StrInf) == 1     
                StrInf  = split(tline,' : ');
                VarName = StrInf{1};
                VarName = StandareStr(VarName);
                  if  StrInf{1}(1)  == '$'                 
                      DataFlag = 1;
                      Jumps = 1;
                      Data = [];
                      DataFieldStr = [ModelName StandareStr( StrInf{1}(3:end) ) ' = Data;'];
                  elseif StrInf{1}(1)  == '#' 
                      DataFlag = 2;
                      StructFieldStr = [ModelName StandareStr( StrInf{1}(3:end) )];
                  end
                if DataFlag == 2
                  tline = fgetl(fid);
                  StrInf = split(tline,' = ');
                elseif  DataFlag == 1
                  if Jumps
                     tline = fgetl(fid);
                     Jumps = 0;
                  end
                  StrInf = split(tline,' = ');
                end
            else
                if DataFlag ~= 2 && DataFlag ~= 1
                   StructFieldStr = [ModelName StandareStr( StrInf{1}(2:end) )];
                end
            end
            if DataFlag == 1
                VarName = StrInf{1};
                Data = [Data; str2num(VarName)];
                eval(DataFieldStr);
            else
                VarName = StrInf{1};
                VarName = StandareStr(VarName);
                VarInf  = StrInf{2};
    %             VarInf  = strrep(VarInf,'-',' -');
                %% - is present in the date and, therefore, requires special handling
                IsMinus = strfind(VarInf,' -');
                %%
                [StrPer,NumPer] = StrAnalisy(VarInf);
                if NumPer == 1  & IsMinus    %
                    VarInf = str2num(VarInf);
                end
                if DataFlag == 2  
                    eval([StructFieldStr '.' VarName  '= VarInf;']);
                else 
                    eval([StructFieldStr  '= VarInf;']);
                end
            end
        end
    end
end
% eval(['GlobalPar' ,'=' , StorageName ';']);
fclose(fid);