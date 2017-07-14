function [features_noImputation,outcome] = createFeatureAndOutcomeVariables(dataMatrix_noImputation,dataHeader,instance)
% Take the data matrix on the site and create a matrix of features and a
% vector of outcomes. The order of the feature matrix obeys the order in
% instance.featureNames.

% create outcome variable
outcome = dataMatrix_noImputation(:,strcmp(dataHeader,instance.outcomeName));

% initialize matrix
features_noImputation = nan(size(dataMatrix_noImputation,1),length(instance.featureNames));
% iteratively add feature to matrix
for i_features = 1:length(instance.featureNames)
    features_noImputation(:,i_features) = dataMatrix_noImputation(:,strcmp(dataHeader,instance.featureNames(i_features)));
end

end