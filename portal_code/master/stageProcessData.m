function [sites,state,instance] = stageProcessData(functionInput,sites,state,instance)
% This stage merges summary stats from each site and provides the initial
% values for the ADMM variables x, u, z.

% compute min/max of data from each site
[instance] = mergeSummaryStats(sites,instance);

% set stage to 1 so that sites start learning
state.stage = 1;

% initialize learning parameters
for i_sites = 1:length(sites)
sites(i_sites).x = sites(i_sites).xInitialization;
sites(i_sites).u = sites(i_sites).uInitialization;
sites(i_sites).z = sites(i_sites).zInitialization;
end
end