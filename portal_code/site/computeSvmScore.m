function [sites] = computeSvmScore(outcome,features,sites,instance)
% PURPOSE:
%   Run the SVM with the given weights on the given set of variables. The
%   output of this model (SVM scores), and the observed
%   outcomes are stored in the sites struct.
% INPUT:
%   outcome:
%   features:
%   sites:
%   instance:
% OUTPUT:
%   sites:
%%
% get feature coefficients
w = instance.xFinal(1:(end-1));
% get the "intercept" value
b = instance.xFinal(end);

% calculate SVM scores by multiplying features by coefficients, and
% adding the "intercept". This means putting the features into the hyperplane
% equation.
svmScore = features*w + b;

sites.outcome = outcome;
sites.svmScore = svmScore;
end