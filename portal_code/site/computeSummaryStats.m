function [sites] = computeSummaryStats(dataMatrix_noImputation,sites)
% PURPOSE:
%   This function is executed to calculate initial summary statistics.
%   These (min and max) are later used for rescaling of the data.
% INPUT:
%   dataMatrix_noImputation: matrix containing the data table (rows are
%   patients, columns are features, NaNs are missing values).
%   sites:
% OUTPUT:
%   sites:

%%
%calculate summary statistics per variable
sites.min = min(dataMatrix_noImputation,[],1); %minimum value per column
sites.max = max(dataMatrix_noImputation,[],1); %maximum value per column
sites.mean = nanmean(dataMatrix_noImputation,1); %mean value per column
sites.median = nanmedian(dataMatrix_noImputation,1); %median value per column
sites.mode = mode(dataMatrix_noImputation,1); %mode value per column
sites.std = nanstd(dataMatrix_noImputation,0,1); %standard deviation per column
sites.count = sum(~isnan(dataMatrix_noImputation),1); %number of available values per column
sites.missing = sum(isnan(dataMatrix_noImputation),1); %number of missing values per column
sites.patientCount = size(dataMatrix_noImputation,1); % number of patients/rows
sites.quartOne = quantile(dataMatrix_noImputation,0.25); % first quartile per column
sites.quartThree = quantile(dataMatrix_noImputation,0.75); % third quartile per column
end