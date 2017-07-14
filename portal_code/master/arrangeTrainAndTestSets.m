function [instance] = arrangeTrainAndTestSets(sites,instance)
% Create train and test sets to store in the instance struct. For each set,
% one vector with SVM scores and one vector with outcomes is created.
% The vectors are created by concatenating data from each site in the order
% of the sites struct.

[instance.trainSvmScore, instance.trainOutcome] = selectSvmScoreAndOutcomeFromSubgroup(sites,find([sites(:).isTrain]));
[instance.testSvmScore, instance.testOutcome] = selectSvmScoreAndOutcomeFromSubgroup(sites,find([sites(:).isTest]));
end

function [svmScore,outcome] = selectSvmScoreAndOutcomeFromSubgroup(sites,indices)
svmScore = cat(1,sites(indices).svmScore);
outcome = cat(1,sites(indices).outcome);
end