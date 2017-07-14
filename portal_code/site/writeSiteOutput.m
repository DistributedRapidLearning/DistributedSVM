function writeSiteOutput(sites,functionInput)
% Converts the sites struct to a json string, writes ithe json string to
% the .txt file to be sent to the master.

% create json string from sites
jsonString = savejson('',sites, 'FileName', functionInput.pathToOutputFile);

end