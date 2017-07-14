function [dataNew,dataHeaderNew] = reorderData(dataMatrix_noImputation,dataHeader,instance)
% Reorder dataMatrix_noImputation & dataHeader according to
% instance.variableNames.

dataOld = dataMatrix_noImputation;
dataNew = NaN(size(dataOld,1),length(instance.variableNames));

% for each variable in instance.variableNames find the corresponding column
% in dataOld and place it in the correct column of dataNew.
for i_dataCols = 1:length(instance.variableNames)
   colInd = find(strcmp(dataHeader,instance.variableNames{i_dataCols}));
   dataNew(:,i_dataCols) = dataOld(:,colInd);    
end

% dataNew now obeys the order in instance.variableNames, so the new data
% header is the same as instance.variableNames
dataHeaderNew = instance.variableNames;

end