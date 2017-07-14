function writeResult(functionInput,instance)
% PURPOSE:
%   Save the outcome and prediction to a .txt-file as the final
%   solution.
% INPUT:
%   functionInput:
%   instance:

% OUTPUT:
%   None; all results are written to a file

%%
% prepare path name
finalResultFile = fullfile(functionInput.pathToMasterOutputFolder,'Result.txt');

% open the actual file
fileID = fopen(finalResultFile,'w');

% write labels and predictions for training and test sets
fprintf(fileID,'observed,predicted\n');
fprintf(fileID,'%i,%10.10f\n',[instance.trainOutcome instance.trainPrediction]');
fprintf(fileID,'observed,predicted\n');
fprintf(fileID,'%i,%10.10f\n',[instance.testOutcome instance.testPrediction]');

% close file
fclose(fileID);
end