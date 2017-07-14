function [sites] = updateZAndU(sites,instance)
% PURPOSE:
%   This file updates the learning variables retrieved from all sites
%   according to Boyd's updating rules.
%   (http://web.stanford.edu/~boyd/papers/admm_distr_stats.html)
% INPUT:
%   sites: struct containing learning variables from all sites;
%   instance:
% OUTPUT:
%   sites:
%%

% read variables
x = [sites(find([sites(:).isTrain])).x];
z = [sites(find([sites(:).isTrain])).z];
u = [sites(find([sites(:).isTrain])).u];

% read input parameters for ADMM (alpha/lambda/rho)
alpha = instance.alpha;
lambda = instance.lambda;
rho = instance.rho;

% determine the number of sites included in training
n = size(x,2);

% z-update with relaxation
xHat = alpha*x +(1-alpha)*z; % relaxation
z = n*rho/(1/lambda + n*rho)*mean(xHat + u,2);
z = z*ones(1,n);

% u-update
u = u + (xHat - z);

% create vector of indices (for site struct) indicating training sites
trainSiteIndices = find([sites(:).isTrain]);
for i_trainSites = 1:size(u,2)
    % move z to zOld;
    sites(trainSiteIndices(i_trainSites)).zOld = sites(trainSiteIndices(i_trainSites)).z;
    % assign newly updated u & z values
    sites(trainSiteIndices(i_trainSites)).u = u(:,i_trainSites);
    sites(trainSiteIndices(i_trainSites)).z = z(:,i_trainSites);
end
end