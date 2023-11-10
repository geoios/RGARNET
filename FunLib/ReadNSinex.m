% 读取配置文件并返回全局变量（GlobalPar）
%% ReadSeafloorNetSolution-->Seafloor network Solution exchange format

function GlobalPar = ReadNSinex(ConfigFile) 

% 读取制定的配置文件
fid = fopen(ConfigFile);

StorageName = 'Struct';


while ~feof(fid)
    tline = fgetl(fid);   % 读取每行数据 
    if strfind(tline,'[')
        ModelName = StandareStr(tline);
        TempName = ModelName;
        
        while 1
            tline = fgetl(fid);   % 读取每行数据
            % 行内容为空时跳出模块读取
            if isempty(tline)     
                break
            end
            StrInf = split(tline,' = ');
            % 行内容为':'时重新进行分割
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
            %% 日期中存在 -，因此，需要特殊处理
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








