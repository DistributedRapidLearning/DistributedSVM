clear
clc
%% user input
% path to file Stage3_anonymized.csv available at
% webpage: https://www.cancerdata.org/id/10.5072/candat.2015.02
% direct link to file : 'https://www.cancerdata.org/system/files/publications/Stage3_anonymized.csv'
pathToData = '';

%%
data = importOberijeEtAlData(pathToData, 2, 549);

data.deadstat = []; % remove death status
data.study_id = []; % remove study id
data.survmonth = []; % remove number of survival months (we use survival years as outocme)
data.twoYearSurvival = (data.survyear >= 2) + 0; % code 2 year survival from survyear
data.survyear = []; % remove after creating the 2 year survival outcome variable

% create data sets per site
siteData{1} = data(1:109,:);
siteData{2} = data(110:218,:);
siteData{3} = data(219:327,:);
siteData{4} = data(328:436,:);
siteData{5} = data(437:end,:);

% create dataHeader containing variable names
dataHeader = data.Properties.VariableNames;

% create site IDs
siteIds = {'234' '846' '78' '28' '38'};

for i_sites = 1:5
    dataCell = table2cell(siteData{i_sites});
    currentFolder = pwd;
    dataFolder = fullfile(currentFolder,'data',['site' num2str(siteIds{i_sites})]);
    sink = rmdir(dataFolder,'s');
    mkdir(dataFolder);
    dataPath = fullfile(dataFolder,'dataRaw.mat');
    save(dataPath,'dataCell','dataHeader');
end