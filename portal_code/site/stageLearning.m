function [sites] = stageLearning(functionInput,sites,state,instance)
% This stage imputes, dummy codes, rescales the data on all sites 
% and applies the x update on training sites.

% load data
if exist(fullfile(functionInput.pathToTempFolder,'data.mat'),'file') == 2
    % load queried & imputed data into matlab workspace
    load(fullfile(functionInput.pathToTempFolder,'data.mat'),'outcome','features','dataHeader')
    
elseif exist(fullfile(functionInput.pathToTempFolder,'data_noImputation.mat'),'file') == 2
    % load dataset from stage 0
    load(fullfile(functionInput.pathToTempFolder,'data_noImputation.mat'),'dataMatrix_noImputation','dataHeader');
    
    % separate features and outcome
    [features_noImputation,outcome] = createFeatureAndOutcomeVariables(dataMatrix_noImputation,dataHeader,instance);
    % imputation
    [features,~] = modeAndMeanImputation(features_noImputation,instance.imputationType,[]);
    %dummy coding
    [features,dataHeader] = createBinaryVariablesGivenRange(features,~cellfun(@isempty,instance.categoricalFeatureRange),instance.featureNames,instance.categoricalFeatureRange);
    % rescaling
    [features] = rescaleData(instance,features);
    % save data
    save(fullfile(functionInput.pathToTempFolder,'data.mat'),'outcome','features','dataHeader')
else
    error('.mat file with local data missing.')
end

% training sites apply the x update
if sites.isTrain == 1
    % x update
    [sites] = updateX(outcome,features,sites,instance);
end

end