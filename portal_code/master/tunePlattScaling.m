function[instance] = tunePlattScaling(instance)
% PURPOSE:
%   Use labels and SVM scores from training data to determine a logistic fit. 
% INPUT:
%   instance:
% OUTPUT:
%   instance:
%%
% apply logistic fit
[instance.classificationCoefficients,~,~] = glmfit(instance.trainSvmScore,instance.trainOutcome,'binomial');
end