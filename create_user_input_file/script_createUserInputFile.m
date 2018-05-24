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
userInput.sparqlQuery = 'prefix roo: <http://www.cancerdata.org/roo/>  prefix ncit: <http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#>  prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#>  prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>  prefix time: <http://www.w3.org/2006/time#>  prefix icd: <http://purl.bioontology.org/ontology/ICD10/>  prefix icdcm: <http://purl.bioontology.org/ontology/ICD10CM/>  prefix uo: <http://purl.obolibrary.org/obo/>   SELECT ?gender ?age ?cT ?cN (xsd:integer(?pTN ) AS ?pCR) WHERE {      ?patient rdf:type ncit:C16960.     ?patient roo:100008 ?disease.     ?disease rdf:type icd:C20.     {         ?patient roo:100018 ?genderRes.         ?genderRes rdf:type ?genderClass.         VALUES (?genderClass ?gender) {              (ncit:C16576 "0"^^xsd:int )              (ncit:C20197 "1"^^xsd:int )          }     }          {         ?patient roo:100016 ?ageDiagnosisResource.         ?ageDiagnosisResource rdf:type roo:100002;             roo:100042 ?age;             roo:100027 ?ageUnitResource.         ?ageUnitResource rdf:type uo:UO_0000036.     }          {         ?disease roo:100243 ?clinicalTNMRes.         ?clinicalTNMRes rdf:type ncit:C48881.         ?clinicalTNMRes roo:100244 ?clinicalTRes.         ?clinicalTRes rdf:type ?clinicalTClass.         VALUES (?clinicalTClass ?cT) {             (ncit:C48720 "1"^^xsd:int )             (ncit:C48724 "2"^^xsd:int )             (ncit:C48728 "3"^^xsd:int )             (ncit:C48732 "4"^^xsd:int )         }         ?clinicalTNMRes roo:100242 ?clinicalNRes.         ?clinicalNRes rdf:type ?clinicalNClass.         VALUES (?clinicalNClass ?cN) {             (ncit:C48705 "0"^^xsd:int )             (ncit:C48706 "1"^^xsd:int )             (ncit:C48786 "2"^^xsd:int )             (ncit:C48714 "3"^^xsd:int )         }     }      {         ?disease roo:100287 ?pathologicTNMRes.         ?pathologicTNMRes rdf:type ncit:C48739.         ?pathologicTNMRes roo:100288 ?pathologicTRes.         ?pathologicTRes rdf:type ?pathologicTClass.         VALUES (?pathologicTClass ?pT) {             (ncit:C48720 "1"^^xsd:int )             (ncit:C48724 "2"^^xsd:int )             (ncit:C48728 "3"^^xsd:int )             (ncit:C48732 "4"^^xsd:int )         }         ?pathologicTNMRes roo:100286 ?pathologicNRes.         ?pathologicNRes rdf:type ?pathologicNClass.         VALUES (?pathologicNClass ?pN) {             (ncit:C48705 "0"^^xsd:int )             (ncit:C48706 "1"^^xsd:int )             (ncit:C48786 "2"^^xsd:int )             (ncit:C48714 "3"^^xsd:int )         }     }           BIND((?pT + ?pN)<2 AS ?pTN). }';
userInput.endpointKey = '';
% randomization seed (yet unused)
userInput.dataSplitSeed = 1;

% name of outcome variable
userInput.outcomeName = 'pCR';
% names of features
userInput.featureNames = {'gender','age','cT','cN'};
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
userInput.lambda = 0.1;

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