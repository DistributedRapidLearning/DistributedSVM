function mainMaster(varargin)
% Manages the learning run on the master.

% in the compiled version, the varargin cell differs compared to the local
% simulation
if length(varargin) == 1
	varargin = varargin{1};
end

% place all function input in a struct
functionInput = struct('runId',varargin{1},...
    'itNumber',varargin{2},...
    'pathToSiteOutputFolder',varargin{3},...
    'pathToMasterOutputFolder',varargin{4},...
    'pathToTempFolder',varargin{5},...
    'abort',varargin{6},...
    'siteIds',varargin{7},...
    'pathToUserInputFile',varargin{8},...
    'pathToLogFile',varargin{9});

writeToLog(['Master starts iteration ' num2str(functionInput.itNumber) '.'], functionInput);
% format function input
[functionInput] = formatFunctionInput(functionInput);

% read user input
[userInput] = readUserInput(functionInput);

% read site output after first iteration
if functionInput.itNumber > 1
    [siteOutput] = readSiteOutput(functionInput);
else
    siteOutput = [];
end
% create structs/load & update structs
[instance,state,sites] = createStructs(functionInput,userInput,siteOutput);

% control stage progression
if isnan(state.stage)
    state.stage = 0; % algorithm just started, initiate data reading on sites
elseif state.stage == 0
    [sites,state,instance] = stageProcessData(functionInput,sites,state,instance);
elseif state.stage == 1
    [sites,state,instance] = stageLearning(functionInput,sites,state,instance);
elseif state.stage == 2
    [sites,state,instance] = stageEvaluation(functionInput,sites,state,instance);
end

% write site input
writeSiteInput(functionInput,sites,state,instance);
% save instance & state structs
save(fullfile(functionInput.pathToTempFolder,'structs'),'instance','state')
end