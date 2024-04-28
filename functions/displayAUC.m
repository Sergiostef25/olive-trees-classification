function displayAUC(cultNameAndCount,YTestSet,score)
%DISPLAYAUC Summary of this function goes here
%   Detailed explanation goes here
AUC = zeros(size(cultNameAndCount,1));
legends = cell(size(cultNameAndCount,1),1);
figure
hold on
for i=1:size(cultNameAndCount,1)
    [X,Y,T,AUC(i)] = perfcurve(YTestSet,score(:,i),i);
    plot(X,Y)
    legends{i} = sprintf('AUC for %s class: %.3f', cultNameAndCount{i,1}, AUC(i));
end
legend(legends, 'location', 'southeast')
    xlabel('False positive rate'); ylabel('True positive rate');
    title('ROC for Classification by KNN')
hold off
end

