clear
clc
userInput.maxIter = 10000;
addpath('json')
%% adjust values here
% sites for training
userInput.trainSitesID = [1 2];
% sites for testing
userInput.testSitesID = [1];
% sparql query & endpointKey for sparql
userInput.sparqlQuery = 'PREFIX ncit:<http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#>   PREFIX roo: <http://www.cancerdata.org/roo/>   PREFIX ro: <http://www.radiomics.org/RO/>   PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>   PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>      PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>   SELECT ?age ?sexNumeric ?cTNumeric ?cNNumeric ?survivalNumeric    WHERE {    	?patient a ncit:C16960 ;        		roo:P100008 ?diseaseObj ;         		roo:P100311 ?survivalObj ;       		roo:P100018 ?sexObj ;          		roo:P100000 ?ageObj.          	?ageObj roo:P100042 ?age.          	?survivalObj a ?survival.       ?survival rdfs:subClassOf roo:C100014.       FILTER(?survival!=roo:C100014 && !ISBLANK(?survival)).       VALUES (?survival ?survivalNumeric) {   	    (roo:C000000 "0"^^xsd:int )   	    (roo:C000001 "1"^^xsd:int )       }              	{ ?sexObj rdf:type ?sex.       ?sex rdfs:subClassOf ncit:C28421.       VALUES (?sex ?sexNumeric) {           (ncit:C20197 "1"^^xsd:int )           (ncit:C16576 "0"^^xsd:int )           } }                     ?diseaseObj 	roo:P100025 ?cTObj ;                	roo:P100025 ?cNObj.              ?cTObj a ncit:C48885 ;            	a ?cT.       ?cT rdfs:subClassOf ncit:C48885.       FILTER(?cT!=ncit:C48885 && !ISBLANK(?cT)).       VALUES (?cT ?cTNumeric) {   	    (ncit:C48720 "1"^^xsd:int )   	    (ncit:C48724 "2"^^xsd:int )   	    (ncit:C48728 "3"^^xsd:int )   	    (ncit:C48732 "4"^^xsd:int )       }              ?cNObj 	a ncit:C48884 ;           	a ?cN.       ?cN rdfs:subClassOf ncit:C48884.       FILTER(?cN!=ncit:C48884 && !ISBLANK(?cN)).       VALUES (?cN ?cNNumeric) {   	    (ncit:C48705 "0"^^xsd:int )   	    (ncit:C48706 "1"^^xsd:int )   	    (ncit:C48786 "2"^^xsd:int )   	    (ncit:C48714 "3"^^xsd:int )       }      }    LIMIT 1000';
userInput.endpointKey = '';
% randomization seed (yet unused)
userInput.dataSplitSeed = 1;

% name of outcome variable
userInput.outcomeName = 'survivalNumeric';
% names of features
userInput.featureNames = {'sexNumeric','age','cTNumeric','cNNumeric'};
% userInput.featureNames = {'gender','age','who3g','bmi','fev1pc_t0','dumsmok2','t_ct_loc','hist4g','countpet_all6g','countpet_mediast6g','tstage','nstage','stage','timing','group','yearrt','eqd2','ott','gtv1','tumorload_total'}
% for each feature in userInput.featureNames: if the feature is a
% categorical with more than 2 categories, provide the vector of possible
% values (needs to be numerical) For binary and continuous variables, use [].
% Note for future updates: categoricalFeatureRange is a bit of a misnomer - consider renaming.
userInput.categoricalFeatureRange = cell(1,length(userInput.featureNames));
userInput.categoricalFeatureRange{1} = []; % gender
userInput.categoricalFeatureRange{2} = []; % age
userInput.categoricalFeatureRange{3} = []; % who3g
userInput.categoricalFeatureRange{4} = []; % countpet_all6g

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
userInput.lambda = 0.5;

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
