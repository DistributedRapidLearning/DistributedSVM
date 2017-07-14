function [dirStruct] = deleteDotsInDir(dirStruct) 

for ii = 1:length(dirStruct)
     if strcmp(dirStruct(ii).name,'.')
        dirStruct(ii) = [];
        break
     end
end

for ii = 1:length(dirStruct)
     if strcmp(dirStruct(ii).name,'..')
        dirStruct(ii) = [];
        break
     end
end

end