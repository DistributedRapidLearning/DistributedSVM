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
    
    %retrieve the tableResult and convert columns to rows
    dataTable = cell2mat(jsonData.results.bindings');

    %determine output cell matrix
    tableResult = cell(size(dataTable,1), size(headValues,2));

    %loop over all columns
    for i=1:size(headValues,2)
        currentVar = headValues{i};

        %loop over all rows
        for j=1:size(dataTable,1)
            %get the specific row
            row = dataTable(j);
            
            if isfield(row, currentVar)
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

