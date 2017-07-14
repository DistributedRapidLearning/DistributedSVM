function [dataMatrix_noImputation,dataHeader] = getData(functionInput,instance)
% if the sparqlQuery is emtpy, it is assumed that you are in a local
% simulation, so you read data from a .mat file.
if ~isempty(instance.sparqlQuery)
    % Add sparql proxy and query information to logging variable
    writeToLog('============================= SPARQL ====================',functionInput);
    writeToLog(['proxy: ' functionInput.sparqlProxy],functionInput);
    writeToLog(['endpointKey: ' instance.endpointKey],functionInput);
    writeToLog(['sparqlToken: ' functionInput.sparqlToken],functionInput);
    writeToLog('query :',functionInput);
    writeToLog(instance.sparqlQuery,functionInput);
    writeToLog('=========================================================',functionInput);
    
    % Perform the sparql query using the code specifically made to work
    % with the proxy in the Varian Learning Portal
    [dataHeader, dataCell, extra] = sparql_vlp(functionInput.sparqlProxy, instance.sparqlQuery, instance.endpointKey, functionInput.sparqlToken, functionInput.pathToTempFolder);
    
    % Add to logging a line indicating data read was finished
    writeToLog(['Data was read: ' num2str(size(dataCell, 1)) ' rows, ' num2str(size(dataCell,2)) ' columns.' ],functionInput);
    
    [dataCell{cellfun(@isempty,dataCell)}] = deal(NaN); % replace empty cells by NaN
    dataMatrix_noImputation = cell2mat(dataCell); % turn cell into matrix
else
    % code for local simulation
    load(fullfile(functionInput.pathToTempFolder,'dataRaw.mat'),'dataCell','dataHeader');
    [dataCell{cellfun(@isempty,dataCell)}] = deal(NaN);
    dataMatrix_noImputation = cell2mat(dataCell);
end
end


