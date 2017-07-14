function [imputedData,imputedValidationData] = modeAndMeanImputation(data,imputationType,validationData)
% PURPOSE:
%   For each column, replace all NaNs by either mean or mode of the
%   corresponding column. Compute means and modes on the training data and
%   apply those also on the validation/test data.
% INPUT:
%   data: matrix of training data with samples per row.
%   imputationType: cell of strings ('mode' or 'mean') of equal size with
%   the number of features. Indicates how to impute per feature.
%   validationData: matrix of test/validation data with samples per row.
% OUTPUT:
%   imputedData: matrix of imputed training data with samples per row.
%   imputedValidationData: matrix of imputed test/validation data with samples per row

modes = mode(data,1); % compute all modes
means = nanmean(data,1); % compute all means

imputedData = data;
for ii = 1:size(data,2)
    nanInd = isnan(data(:,ii)); % compute rows with nans in current variable ii
    if imputationType{ii} == 'mode' % use modes
        imputedData(nanInd,ii) = modes(ii);
    elseif imputationType{ii} == 'mean' % uses means
        imputedData(nanInd,ii) = means(ii);
    else
        error('Unrecognized imputation type')
    end
end

if ~isempty(validationData)
    imputedValidationData = validationData;
    for ii = 1:size(validationData,2)
        nanInd = isnan(validationData(:,ii)); % compute rows with nans in current variable ii
        if imputationType{ii} == 'mode' % use modes
            imputedValidationData(nanInd,ii) = modes(ii);
        elseif imputationType{ii} == 'mean' % uses means
            imputedValidationData(nanInd,ii) = means(ii);
        else
            error('Unrecognized imputation type')
        end
    end
else
    imputedValidationData = [];
end