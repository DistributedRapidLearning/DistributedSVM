function writeSiteInput(functionInput,sites,state,instance)
% This function places the three relevant structs (sites, state, instance)
% into one struct (otherwise we cannot create a single json string),
% creates a json string and saves it in the .txt file for each
% corresponding site. A site only receives the row in the sites struct
% that corresponds to that site.

for i_siteIds = 1:length(instance.siteIds)
    % find the index of the i_siteIds-th site in the site struct
    siteIndex = find([sites.id] == instance.siteIds(i_siteIds));
    
    % create struct of structs so that they all fit in one json string
    outputStruct = struct;
    outputStruct.sites = sites(siteIndex);
    outputStruct.state = state;
    outputStruct.instance = instance;
    
    
    % create full path to file where the json string is to be stored
    filenameInputFileForSite = fullfile(functionInput.pathToMasterOutputFolder,['input_' num2str(instance.siteIds(i_siteIds)) '.txt']);
    
    % create json string from struct of structs
    jsonString = savejson('',outputStruct, 'FileName', filenameInputFileForSite);
end

end