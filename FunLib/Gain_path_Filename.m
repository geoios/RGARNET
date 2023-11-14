function [fileName_folder,Tag] = Gain_path_Filename(fileName,index)

files = dir(fullfile(fileName));
size_row = size(files);
folder_num = size_row(1);
for i=3:folder_num
    fileName_folder{i-2,1} = fullfile(fileName,files(i,1).name);
    Tag{i-2,1}=files(i,1).name(index:end);
end
end