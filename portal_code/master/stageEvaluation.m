function [sites,state,instance] = stageEvaluation(functionInput,sites,state,instance)
% This stage generates the predictions for the data from each site.

% arrange train and test data
[instance] = arrangeTrainAndTestSets(sites,instance);
% tune Platt scaling
[instance] = tunePlattScaling(instance);
% predict on train and test sets
[instance] = predictOutcome(instance);
% write output
writeResult(functionInput,instance)
% write finalX to log
writeToLog(['xFinal: ' num2str(instance.xFinal')],functionInput);
end