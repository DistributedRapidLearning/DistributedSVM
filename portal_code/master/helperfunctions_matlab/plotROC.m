function fig = plotROC( FPR, TPR, AUC )
%PLOTROC Plots the ROC for the given False Positive Rate and True Positive
%Rate

fig = figure();

%plot the FPR/TPR values
plot(FPR,TPR,'LineWidth',2,'Color',[1 0 0]);

%plot the AUC=0.5 line
line([0 1], [0 1], 'Color', [0.5 0.5 0.5]);

%Add label on the x-axis
xlabel('1 - Specificity','FontWeight', 'bold');

%Add label on the y-axis
ylabel('Sensitivity','FontWeight', 'bold');

%add title
title('ROC-curve','FontWeight','bold');

%add background grid
grid;

%add AUC as legend
legend(['AUC: ' num2str(AUC)], 'Location', 'southeast');

end

