function [state] = checkConvergence(sites,state,instance,functionInput)

% PURPOSE:
%   Check whether the algorithm has converged (according to Boyd's
%   criteria) and then abort the ADMM process.
%   http://web.stanford.edu/~boyd/papers/admm_distr_stats.html
% INPUT:
%   sites:
%   state:
%   instance:
% OUTPUT:
%  state:

%%
% read variables
x = [sites(find([sites(:).isTrain])).x];
z = [sites(find([sites(:).isTrain])).z];
u = [sites(find([sites(:).isTrain])).u];
zOld = [sites(find([sites(:).isTrain])).zOld];
sumPos = [sites(find([sites(:).isTrain])).sumPos];

% load user input parameters (rho/lambda)
rho = instance.rho;
lambda = instance.lambda;
absTol = instance.absTol;
relTol = instance.relTol;

% determine number of coefficients (number of features + intercept)
n = size(x,1);

% compute objective function value
objval  = objective(sumPos,lambda,z);

% compute metrics for convergence criterion
r_norm  = norm(x - z);
s_norm  = norm(-rho*(z - zOld));

% determine primal and dual convergence parameters
eps_pri = sqrt(n)*absTol + relTol*max(norm(x), norm(-z));
eps_dual= sqrt(n)*absTol + relTol*norm(rho*u);

writeToLog(['r_norm - eps_pri: ' num2str(r_norm - eps_pri)],functionInput);
writeToLog(['s_norm - eps_dual: ' num2str(s_norm - eps_dual)],functionInput);

% writeToLog(['hello' 2 'world'],functionInput); % debugging

% for local simulation print to screen
if isempty(instance.sparqlQuery)
    display(['r_norm - eps_pri: ' num2str(r_norm - eps_pri)])
    display(['s_norm - eps_dual: ' num2str(s_norm - eps_dual)])
end
% determine whether convergence criterion has been reached
if (r_norm < eps_pri && s_norm < eps_dual)
    state.hasConverged = true;
end

end

% internal function to calculate objective
function obj = objective(sumPos,lambda,z)
hinge_loss = sum(sumPos);
obj = hinge_loss + 1/(2*lambda)*sum(z(:,1).^2);
end