function [fpr,tpr,perfT,AUC] = calcAUC(observed, predicted)
%BOOTAUC Summary of this function goes here
%   Detailed explanation goes here
% 1: observed
% 2: predicted
        if(length(unique(observed))>1)
            [fpr,tpr,perfT,AUC] = perfcurve(observed==1, predicted, 1==1, 'xCrit', 'FPR', 'yCrit', 'TPR');
        else
            AUC = NaN;
            fpr = NaN;
            tpr = NaN;
            perfT = NaN;
        end
end

