function [sites,state,instance] = stageLearning(functionInput,sites,state,instance)
% This stage updates z & u, and checks whether ADMM converged.

% update learning parameters
[sites] = updateZAndU(sites,instance);
% check convergence
[state] = checkConvergence(sites,state,instance,functionInput);

% if solution has converged or iteration limit is reached,
% average x and tell sites to initialize evaluation,
% otherwise continue learning.
if state.hasConverged == true || state.itNumber == (instance.maxIter - 1)
    state.stage = 2;
    [instance] = averageX(sites,instance);
else
    state.stage = 1;
end
end