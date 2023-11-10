% ��ȡ�����ļ�������ȫ�ֱ�����GlobalPar��
%% ReadSeafloorNetSolution-->Seafloor network Solution exchange format

function GlobalPar = ReadNSinex(ConfigFile) 

% ��ȡ�ƶ��������ļ�
fid = fopen(ConfigFile);

StorageName = 'Struct';


while ~feof(fid)
    tline = fgetl(fid);   % ��ȡÿ������ 
    if strfind(tline,'[')
        ModelName = StandareStr(tline);
        TempName = ModelName;
        
        while 1
            tline = fgetl(fid);   % ��ȡÿ������
            % ������Ϊ��ʱ����ģ���ȡ
            if isempty(tline)     
                break
            end
            StrInf = split(tline,' = ');
            % ������Ϊ':'ʱ���½��зָ�
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
            %% �����д��� -����ˣ���Ҫ���⴦��
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








