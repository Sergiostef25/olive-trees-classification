function [XTrainSet, XTestSet, indexTrain,indexTest] = createAndDisplayTrainTestSet(dataset, percentage, rgbImg)
%CREATEANDDISPLAYTRAINTESTSET holdout train test set
arguments
    dataset table
    percentage {mustBeInRange(percentage,0,1)}
    rgbImg
end

index1Train = dataset.labels == 1;
index1Train(1:round(numel(index1Train)*percentage)) = 0;

index2Train = dataset.labels == 2;
index2Train(1:round(numel(index2Train)*percentage)) = 0;

index3Train = dataset.labels == 3;
index3Train(1:round(numel(index3Train)*percentage));

index4Train = dataset.labels == 4;
index4Train(1:round(numel(index4Train)*percentage));

index5Train = dataset.labels == 5;
index5Train(1:round(numel(index5Train)*percentage));

index6Train = dataset.labels == 6;
index6Train(1:round(numel(index6Train)*percentage));

indexTrain = index1Train | index2Train | index3Train | index4Train | index5Train | index6Train;
indexTest = ~ indexTrain;

XTrainSet = dataset(indexTrain,:);
XTestSet = dataset(indexTest, :);


[a, b] = ind2sub(size(rgbImg,[1,2]),XTrainSet.index);
[c, d] = ind2sub(size(rgbImg,[1,2]),XTestSet.index);

figure
imshow(rgbImg)
hold on
c1 = plot(b, a, '.', 'MarkerSize', 7,'Color', 'blue','DisplayName','Train set');
c2 = plot(d, c, '.', 'MarkerSize', 7,'Color', 'red','DisplayName','Test set');
hold off
legend([c1,c2])
clear c1 c2 a b c d
end

