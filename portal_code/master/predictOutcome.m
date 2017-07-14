function [instance] = predictOutcome(instance)
% Predicts outcomes using the Platt scaling logistic regression
% for training and test sets. Places the result in the instance struct.
instance.trainPrediction = glmval(instance.classificationCoefficients,instance.trainSvmScore,'logit');
instance.testPrediction = glmval(instance.classificationCoefficients,instance.testSvmScore,'logit');
end