function [siteOutput] = readSiteOutput(functionInput)
% Opens .txt files received from each sites. Converts the contained 
% json string that represents a row from the sites struct. Puts these rows
% in the siteOutput struct.

for i_siteIds = 1:length(functionInput.siteIds)
    % construct path to site output file
    pathToSiteOutputFile = fullfile(functionInput.pathToSiteOutputFolder,['DistOutput_' num2str(functionInput.siteIds(i_siteIds)) '.txt']);
    
%     % open file with input parameters from master
%     fileId = fopen(pathToSiteOutputFile,'r');
%     
%     % read json string from file
%     jsonString = fscanf(fileId,'%s');
%     
%     % close file
%     fclose(fileId);
%     
%     % list sites in siteOutput struct in the order as in functionInput.siteIds
%     % convert json string to struct
%     newSite = loadjson(jsonString,'SimplifyCellArray',1);
    newSite = loadjson(pathToSiteOutputFile);
    % check that the site struct is indeed from the expected site
    if functionInput.siteIds(i_siteIds) ~= newSite.id
        error('Site order is messed up.')
    end
    
    % construct siteOutput struct
    if i_siteIds == 1
        siteOutput = newSite;
    else
        siteOutput = [siteOutput newSite];
    end
end
end