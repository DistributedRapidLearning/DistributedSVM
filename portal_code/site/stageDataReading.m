function [sites] = stageDataReading(functionInput,sites,state,instance)
% This stage reads the data from the site and computes summary stats.



[dataMatrix_noImputation,dataHeader] = getData(functionInput,instance);
%% 
% add your SPARQL query and data-preprocessing in the function getData().
% the output needs to be
% dataMatrix_noImputation: a matrix with numeric values and NaNs 
% dataHeader: a cell with column headers for the matrix
%%

% quality check: reorder data and data header to obey order in instance.variableNames
[dataMatrix_noImputation,dataHeader] = reorderData(dataMatrix_noImputation,dataHeader,instance);

% save un-imputed data for later iterations
save(fullfile(functionInput.pathToTempFolder,'data_noImputation.mat'),'dataMatrix_noImputation','dataHeader');

% compute summary stats for variables at this site, needed for
% normalization
[sites] =  computeSummaryStats(dataMatrix_noImputation,sites);
end

% Example SPARQL query:
% SELECT ?patient ?disease
% WHERE {
%     ?patient rdf:type ncit:C16960.
%     ?patient roo:has_disease ?disease.
% }