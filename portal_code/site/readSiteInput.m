function [sites,state,instance]= readSiteInput(functionInput)
% Read json string from .txt file received from the master and re-construct
% the three structs sites, state, instance.

% % Open file with input parameters from master
% fileId = fopen(functionInput.pathToInputFileFromMaster,'r');
% 
% % read json string from file
% jsonString = fscanf(fileId,'%s');
% 
% % Close file
% fclose(fileId);

% turn json string into struct of structs
% outputStruct = loadjson(jsonString,'SimplifyCellArray',1);
outputStruct = loadjson(functionInput.pathToInputFileFromMaster);
sites = outputStruct.sites;
state = outputStruct.state;
instance = outputStruct.instance;
end