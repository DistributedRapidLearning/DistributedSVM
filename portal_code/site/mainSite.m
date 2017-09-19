function mainSite(varargin)
% Manages the learning run on the site(s).

% in the compiled version, the varargin cell differs compared to the local
% simulation
if length(varargin) == 1
	varargin = varargin{1};
end

% place all function input in a struct
functionInput = struct('runId', varargin{1},...
    'itNumber',varargin{2},...
    'pathToInputFileFromMaster',varargin{3},...
    'pathToOutputFile',varargin{4},...
    'pathToTempFolder',varargin{5},...
    'pathToLogFile',varargin{6},...
    'sparqlProxy',varargin{7},...
    'sparqlToken',varargin{8},...
    'dataProxyType',varargin{9}...
    );


% format function input
[functionInput] = formatFunctionInput(functionInput);

% read input from master
[sites,state,instance]= readSiteInput(functionInput);
writeToLog(['Site ' num2str(sites.id) ' starts iteration ' num2str(functionInput.itNumber) '.'], functionInput);
% control stage progression
switch state.stage
    case 0
        [sites] = stageDataReading(functionInput,sites,state,instance);
    case 1
        [sites] = stageLearning(functionInput,sites,state,instance);
    case 2
        [sites] = stageEvaluation(functionInput,sites,state,instance);
end

% write site output
writeSiteOutput(sites,functionInput)
end