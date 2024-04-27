function displayPredictionResults(rgbImg,XTestSet, YTestSet,Ypredicted)
%DISPLAYPREDICTIONRESULTS Display prediction results in the map
figure
imshow(rgbImg)

hold on

idxRightPrediction = YTestSet == Ypredicted;
percentage = numel(find(idxRightPrediction))*100/numel(idxRightPrediction);
[row, col] = ind2sub(size(rgbImg,[1,2]),XTestSet{idxRightPrediction,"index"});
c1 = plot(col, row, '.', 'MarkerSize', 7,'Color', 'green','DisplayName',strcat('Correttamente classificati{ }',num2str(round(percentage)),'%'));
[row, col] = ind2sub(size(rgbImg,[1,2]),XTestSet{~idxRightPrediction,"index"});
c2 = plot(col, row, '.', 'MarkerSize', 7,'Color', 'red','DisplayName',strcat('Non correttamente classificati{ }',num2str(round(100-percentage)),'%'));
hold off
legend([c1,c2], Location='northeastoutside')
end

