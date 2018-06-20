function [instance] = recordAdmmVariables(sites,instance)

% PURPOSE:
%   Record x, z, and u in the instance struct for debugging/analysis.
% INPUT:
%   sites:
%   instance:
% OUTPUT:
%  instance:

x = [sites(find([sites(:).isTrain])).x];
z = [sites(find([sites(:).isTrain])).z];
u = [sites(find([sites(:).isTrain])).u];
numeroTrainSites = sum([sites(:).isTrain]);

if ~isfield(instance,'xLog')
   instance.xLog = cell(numeroTrainSites,1); 
end

if ~isfield(instance,'zLog')
   instance.zLog = []; 
end

if ~isfield(instance,'uLog')
   instance.uLog = cell(numeroTrainSites,1); 
end


for i_trainSites = 1:numeroTrainSites
instance.xLog{i_trainSites} = [instance.xLog{i_trainSites} x(:,i_trainSites)];
instance.uLog{i_trainSites} = [instance.uLog{i_trainSites} u(:,i_trainSites)];
end

% z is not different per site 
instance.zLog = [instance.zLog z(:,1)];

end