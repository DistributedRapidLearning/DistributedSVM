function [instance] = averageX(sites,instance)
% Create the final x vector by averaging the nearly equal x vectors from
% each site. Even though the convergence criteria are met, there might
% still be small differences in decimal values. Therefore, it is probably
% best to average the different values.

% read x from each training site
x = [sites(find([sites(:).isTrain])).x];

% average over all training sites
instance.xFinal = mean(x,2);
end