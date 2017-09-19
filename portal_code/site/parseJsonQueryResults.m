function [headValues, tableResult] = parseJsonQueryResults( binaryData, pathToTempFolder )
%PARSEJSONQUERYRESULTS Parses the binary JSON data, which is output of a
%SPARQL query.
% Input parameters:
%   - binaryData: binary data coming from the HTTP result
% Output parameters:
%   - headValues: the "column" names specified as variables in the SELECT
%       part of the SPARQL query
%   - tableResult: cell matrix containing the results

%temporarily store XML result as file
fid = fopen(fullfile(pathToTempFolder, 'myFile.json'), 'w');
fprintf(fid,'%s',binaryData);
fclose(fid);

%add path of the used JSON library
%addpath('jsonlab-1.0\jsonlab\');

%load the json file using the library
%creates a struct containing the data
jsonData = loadjson(fullfile(pathToTempFolder, 'myFile.json'));

%if "SubmitSparqlQueryResult" exists as field, we are interpreting the
%Varian Learning Portal JSON result
if isfield(jsonData, 'SubmitSparqlQueryResult')
    jsonData = loadjson(jsonData.SubmitSparqlQueryResult);
end

%retrieve the variable names
headValues = jsonData.head.vars;

%% Replacement for dataTable = cell2mat(jsonData.results.bindings');
dataTable = struct;
% i_vars is the number of variables requested in the SPARQL query
% i_rows is the number of rows returned from the SPARQL query (as seen in
% the blazegraph interface)
for i_vars = 1:length(headValues)
    curVar = headValues{i_vars};
    for i_rows = 1:size(jsonData.results.bindings,2)
        if isfield(jsonData.results.bindings{i_rows},curVar)
            dataTable(i_rows,1).(curVar) =  jsonData.results.bindings{i_rows}.(curVar);
        end
    end
end
%%


%determine output cell matrix
tableResult = cell(size(dataTable,1), size(headValues,2));

%loop over all columns
for i=1:size(headValues,2)
    currentVar = headValues{i};
    
    %loop over all rows
    for j=1:size(dataTable,1)
        %get the specific row
        row = dataTable(j);
        
        if isfield(row, currentVar) & ~isempty(row.(currentVar))
            %get the column information for this row
            colStruct = row.(currentVar);
            
            %retrieve the column value for this row
            value = colStruct.value;
            
            %check if it's a literal, if yes, convert properly
            if(strcmp(colStruct.type,'literal'))
                dataType = 'NotAvailable';
                if isfield(colStruct, 'datatype')
                    dataType = colStruct.datatype;
                end
                value = parseLiteral(dataType, value);
            end
        else
            value = NaN;
        end
        
        %add the value to the final cell matrix
        tableResult(j,i) = {value};
    end
end

%remove path of the used JSON library
%rmpath('jsonlab-1.0\jsonlab\');

%delete current file
%delete(fullfile(pathToTempFolder, 'myFile.json'));
end

