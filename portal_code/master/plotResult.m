function plotResult(functionInput,instance)
% PURPOSE:
%   Plot the AUC curve for the training and testing set
% INPUT:
%   functionInput:
%   instance:

% OUTPUT:
%   None; all results are written to a file

aucPathTraining = fullfile(functionInput.pathToMasterOutputFolder,'training.png');
[fpr,tpr,perfT,AUC] = calcAUC(instance.trainOutcome, instance.trainPrediction);
fig = plotROC(fpr, tpr, AUC);
saveas(fig, aucPathTraining);

aucPathTraining = fullfile(functionInput.pathToMasterOutputFolder,'testing.png');
[fpr,tpr,perfT,AUC] = calcAUC(instance.testOutcome, instance.testPrediction);
fig = plotROC(fpr, tpr, AUC);
saveas(fig, aucPathTraining);

end

