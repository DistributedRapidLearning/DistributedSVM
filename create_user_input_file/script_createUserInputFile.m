clear
clc
userInput.maxIter = 10000;
addpath('json')
%% adjust values here
% sites for training
userInput.trainSitesID = [28 78 234 846];
% sites for testing
userInput.testSitesID = [38];
% sparql query & endpointKey for sparql
userInput.sparqlQuery = '';
userInput.endpointKey = '';
% randomization seed (yet unused)
userInput.dataSplitSeed = 1;

% name of outcome variable
userInput.outcomeName = 'twoYearSurvival';
% names of features
userInput.featureNames = {'gender','age','who3g','countpet_all6g','tstage','gtv1','ott','eqd2'};
% userInput.featureNames = {'gender','age','who3g','bmi','fev1pc_t0','dumsmok2','t_ct_loc','hist4g','countpet_all6g','countpet_mediast6g','tstage','nstage','stage','timing','group','yearrt','eqd2','ott','gtv1','tumorload_total'}
% for each feature in userInput.featureNames: if the feature is a
% categorical with more than 2 categories, provide the vector of possible
% values (needs to be numerical) For binary and continuous variables, use [].
% Note for future updates: categoricalFeatureRange is a bit of a misnomer - consider renaming.
userInput.categoricalFeatureRange = cell(1,length(userInput.featureNames));
userInput.categoricalFeatureRange{1} = [1:2]; % gender
userInput.categoricalFeatureRange{2} = []; % age
userInput.categoricalFeatureRange{3} = [1:3]; % who3g
userInput.categoricalFeatureRange{4} = [1:6]; % countpet_all6g
userInput.categoricalFeatureRange{5} = [1:4]; % tstage
userInput.categoricalFeatureRange{6} = []; % gtv1
userInput.categoricalFeatureRange{7} = []; % ott
userInput.categoricalFeatureRange{8} = []; % eqd2

% determine imputation ('mode' or 'mean') for each feature in userInput.featureNames
% example for manual assignment:
% userInput.imputationType = {'mode','mean','mode'};
% automatic assignment based on userInput.categoricalFeatureRange:
for i_features = 1:length(userInput.featureNames)
    if isempty(userInput.categoricalFeatureRange{i_features}) % if it is continuous
    userInput.imputationType{i_features} = 'mean';
    else
    userInput.imputationType{i_features} = 'mode'; % if it is not continuous
    end
end

% Lagrangian parameter
userInput.rho = 1;
% relaxation parameter in z update
userInput.alpha = 1.5;
% weight in the SVM objective
userInput.lambda = 0.01;

% parameters for convergence criterion (Boyd's settings: userInput.absTol = 10^-4; userInput.relTol = 10^-2;)
userInput.absTol = 10^-2;
userInput.relTol = 10^-2;
%%
% names of all variables, automatically constructed from earlier input
userInput.variableNames = [userInput.featureNames userInput.outcomeName];
% loop to calculate the number of coefficients for x,u,z
numberOfCoefficients = 1; % start with 1 for the 'intercept'
for i_catFeatRange = 1:length(userInput.categoricalFeatureRange)
    if isempty(userInput.categoricalFeatureRange{i_catFeatRange})
        numberOfCoefficients = numberOfCoefficients + 1;
    else
        numberOfCoefficients = numberOfCoefficients + (numel(userInput.categoricalFeatureRange{i_catFeatRange}) - 1); % you create (numel()- 1) dummy variables
    end 
end
userInput.x = zeros(numberOfCoefficients,1);
userInput.u = zeros(numberOfCoefficients,1);
userInput.z = zeros(numberOfCoefficients,1);


% create json string from userInput struct and save to text file
jsonString = savejson('',userInput, 'FileName', 'userInputFile.txt');