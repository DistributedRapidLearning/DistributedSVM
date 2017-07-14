function [copyStatus,copyStatusMessage] = batchCopyFiles(fileNames,sourceFolder,targetFolder,displayBoolean)
for ii = 1:length(fileNames)
    a = fullfile(sourceFolder,fileNames{ii});
    b = fullfile(targetFolder,fileNames{ii});
    if displayBoolean == 1
        disp([ii length(fileNames)])
    end
    [copyStatus(ii),copyStatusMessage{ii}]  = copyfile(a,b);
end
end