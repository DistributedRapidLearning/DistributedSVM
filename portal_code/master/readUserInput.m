function [userInput] = readUserInput(functionInput)
% Reads the json string from user input file and converts it to a struct.

% % open file with input parameters from master
% fileId = fopen(functionInput.pathToUserInputFile,'r');
% 
% % read json string from file
% jsonString = fscanf(fileId,'%s');
% 
% % close file
% fclose(fileId);

% turn json string into struct.
% userInput = loadjson(jsonString,'SimplifyCellArray',1);

userInput = loadjson(functionInput.pathToUserInputFile);
end