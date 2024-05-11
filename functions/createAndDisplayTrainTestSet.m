function [XTrainSet, XTestSet] = createAndDisplayTrainTestSet(dataset, percentage, rgbImg)
%CREATEANDDISPLAYTRAINTESTSET holdout train test set
arguments
    dataset table
    percentage {mustBeInRange(percentage,0,1)}
    rgbImg
end

rng(10)

indexTrain = false(height(dataset),1);
for i=1:length(unique(dataset.labels))
    labelTrees = unique(dataset{dataset.labels == i,"treenum"});
    labelTreesTrainNum = randsample(labelTrees, round(length(labelTrees)*percentage));
    
    for j=1:length(labelTreesTrainNum)
        indexTrain = indexTrain | dataset.treenum == labelTreesTrainNum(j);
    end
end



XTrainSet = dataset(indexTrain, :);
XTestSet = dataset(~indexTrain, :);


% XTrainSet = [train1 ; train2 ; train3 ; train4 ; train5];
% XTestSet =  [test1 ; test2 ; test3 ; test4 ; test5];


[a, b] = ind2sub(size(rgbImg,[1,2]),XTrainSet.index);
[c, d] = ind2sub(size(rgbImg,[1,2]),XTestSet.index);

figure
imshow(rgbImg)
hold on
c1 = plot(b, a, '.', 'MarkerSize', 7,'Color', 'blue','DisplayName','Train set');
c2 = plot(d, c, '.', 'MarkerSize', 7,'Color', 'red','DisplayName','Test set');
hold off
legend([c1,c2],Location='northeastoutside')
end

