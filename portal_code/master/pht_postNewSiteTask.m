function [ binaryData ] = pht_postNewSiteTask( registryBase, inputSiteFile, imageName, runId, siteId )
%PHT_POSTNEWSITETASK Summary of this function goes here
%   Detailed explanation goes here

% open file with input parameters from master
fileId = fopen(inputSiteFile,'r');
% read json string from file
userInputFile = fscanf(fileId,'%c');
% close file
fclose(fileId);

requestBody = struct();
requestBody(1).image = imageName;
requestBody(1).inputString = userInputFile;
requestBody(1).runId = runId;

header = http_createHeader('Content-Type', 'application/json');

%open the URL, including the query as a GET-parameter
endpoint = [registryBase '/client/' siteId '/task/add'];
[binaryData, extra] = urlread2(endpoint,'POST',savejson('', requestBody), header);
end

