function [sites] = stageEvaluation(functionInput,sites,state,instance)
% This stage computes SVM scores for patients from this site and 
% passes them on to the master together with the outcome variable.

% load data
if exist(fullfile(functionInput.pathToTempFolder,'data.mat'),'file') == 2
    % load queried & imputed data into matlab workspace
    load(fullfile(functionInput.pathToTempFolder,'data.mat'),'outcome','features','dataHeader')
else
    error('.mat file with local data missing.')
end

% compute SVM scores for each patient, place them and the outcome
% in the sites struct
[sites] = computeSvmScore(outcome,features,sites,instance);
end