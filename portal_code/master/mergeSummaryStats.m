function [instance] = mergeSummaryStats(sites,instance)
% PURPOSE:
%   Right now this function only determines min and max values for each variable
%   over all sites and places them in the instance struct.
%   It could be extended to merge more summary statistics.
% INPUT:
%   sites:
%   instance:
% OUTPUT:
%   instance:


% initialize NaN matrices to be filled up with values iteratively
minMatrix = nan(length(sites),length(sites(1).min));
maxMatrix = nan(length(sites),length(sites(1).min));
% add min and max values per site
for i_siteIndices = 1:length(sites)
    minMatrix(i_siteIndices,:) = sites(i_siteIndices).min;
    maxMatrix(i_siteIndices,:) = sites(i_siteIndices).max;
end
% determine global minimum irrespective of training/test sites
instance.globalMin = min(minMatrix,[],1);
% determine global maximum irrespective of training/test sites
instance.globalMax = max(maxMatrix,[],1);
end