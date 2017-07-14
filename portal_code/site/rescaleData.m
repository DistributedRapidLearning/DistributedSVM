function [features] = rescaleData(instance,features)
% Rescale all non-categorical features by (v-min(v)/(max(v)-min(v)). Binary
% variables are unaffected by the scaling. Dummy coded variables
% (categorical features) are excluded because we didn't compute min and max
% values for those in the previous iteration. Since they are now
% represented by multiple binary variables, they also don't need rescaling
% anymore. This function will yield an error if min() and max() values are
% equal for a variable. That means there is no variation in that variable.
 
% create logical vector for non-categorical features
nonCatFeatureBoolean = cellfun(@isempty,instance.categoricalFeatureRange);

% remove the last value from globalMin (corresponds to the outcome)
featuresMin = instance.globalMin(1:(end-1));
featuresMax = instance.globalMax(1:(end-1));

% consider only the non-categorical features
featuresMin = featuresMin(nonCatFeatureBoolean);
featuresMax = featuresMax(nonCatFeatureBoolean);
% rescale non-categorical features 
features(:,nonCatFeatureBoolean) = bsxfun(@minus,features(:,nonCatFeatureBoolean),featuresMin);
features(:,nonCatFeatureBoolean) = bsxfun(@times,features(:,nonCatFeatureBoolean),1./(featuresMax - featuresMin));
end