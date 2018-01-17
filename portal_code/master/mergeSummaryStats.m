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

for i_siteIndices = 1:length(sites)
    instance.min(i_siteIndices,:) = sites(i_siteIndices).min; % min value per column
    instance.max(i_siteIndices,:) = sites(i_siteIndices).max; % max value per column
    instance.mean(i_siteIndices,:) = sites(i_siteIndices).mean; % mean value per column
    instance.median(i_siteIndices,:) = sites(i_siteIndices).median; % median value per column
    instance.mode(i_siteIndices,:) = sites(i_siteIndices).mode; % mode value per column
    instance.std(i_siteIndices,:) = sites(i_siteIndices).std; % standard deviation per column
    instance.count(i_siteIndices,:) = sites(i_siteIndices).count; % number of available values per column
    instance.missing(i_siteIndices,:) = sites(i_siteIndices).missing; % number of missing values per column
    instance.patientCount(i_siteIndices,:) = sites(i_siteIndices).patientCount; % number of patients/rows
    instance.quartOne(i_siteIndices,:) = sites(i_siteIndices).quartOne; % first quartile per column
    instance.quartThree(i_siteIndices,:) = sites(i_siteIndices).quartThree; % third quartile per column
end
end