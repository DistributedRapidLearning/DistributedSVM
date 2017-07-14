function [sites] = updateX(outcome,features,sites,instance)
% PURPOSE:
%   Run the x-update according to Boyd. (http://web.stanford.edu/~boyd/papers/admm_distr_stats.html) 
%   Instead of cvx, the Matlab-internal quadprog() is used. Requires the
%   Optmization package.
% INPUT:
%   outcome:
%   features:
%   sites:
%   instance:

% OUTPUT:
%   sites:
%%
% get the number of coefficients = number of features + the intercept
numberOfCoefficients = size(features,2) + 1;

%% prepare input parameters

% use variables passed on by the master algo
u = sites.u;
z = sites.z;
rho = instance.rho;

% transpose vectors if in incorrect format
if size(u,1)<size(u,2)
   u = transpose(u); 
end

%transpose vectors if in incorrect format
if size(z,1)<size(z,2)
   z = transpose(z); 
end

%% prepare data matrices for learning
% set the outcome in variable named y
y = outcome';
% set negative outcomes (non-events) to -1
y(y == 0) = -1;
% set the input variables to X
X = features';
% combine dataset and outcome again in a different matrix (note the "m-1")
A = [ -((ones(numberOfCoefficients-1,1)*y).*X)' -y'];


%% Quadprog (solves the same as the cvx optimization by Boyd http://web.stanford.edu/~boyd/papers/admm_distr_stats.html )
noPatients = length(y);
constParam = 1;
H = [rho*eye(numberOfCoefficients) zeros(numberOfCoefficients,noPatients); zeros(noPatients,(noPatients+numberOfCoefficients))];
f = [-(z-u)'*rho constParam*ones(1,noPatients)];
constraintA = -[repmat(y',1,numberOfCoefficients).*[X' ones(noPatients,1)] eye(noPatients)];
constraintB = -ones(noPatients,1);
lb = [-Inf*ones(numberOfCoefficients,1);zeros(noPatients,1)];
optionsQP = optimoptions('quadprog','Display','off');
[quadOutput]=quadprog(H,f,constraintA,constraintB,[],[],lb,[],[],optionsQP);
x = quadOutput(1:numberOfCoefficients);

%% export parameters of the learned model
% sumPos is needed in the master algorithm to calculate the value of the
%  objective function
sumPos = sum(max((A*x + 1),0));

% put all the calculated variables in the outputParams struct, which is
% passed to the master
sites.x = x;
sites.sumPos = sumPos;
end