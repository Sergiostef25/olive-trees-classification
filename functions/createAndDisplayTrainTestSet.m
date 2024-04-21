function [XTrainSet, XTestSet, indexTrain,indexTest] = createAndDisplayTrainTestSet(dataset, percentage, rgbImg)
%CREATEANDDISPLAYTRAINTESTSET holdout train test set
arguments
    dataset table
    percentage {mustBeInRange(percentage,0,1)}
    rgbImg
end

% subDataset = dataset(dataset.labels == 1,:);
% 
% n = height(subDataset);
% hpartition = cvpartition(n,'Holdout',0.3);
% idxTrain = training(hpartition);
% train1 = subDataset(idxTrain,:);
% idxNew = test(hpartition);
% test1 = subDataset(idxNew,:);
% 
% subDataset = dataset(dataset.labels == 2,:);
% 
% n = height(subDataset);
% hpartition = cvpartition(n,'Holdout',0.3);
% idxTrain = training(hpartition);
% train2 = subDataset(idxTrain,:);
% idxNew = test(hpartition);
% test2 = subDataset(idxNew,:);
% 
% subDataset = dataset(dataset.labels == 3,:);
% 
% n = height(subDataset);
% hpartition = cvpartition(n,'Holdout',0.3);
% idxTrain = training(hpartition);
% train3 = subDataset(idxTrain,:);
% idxNew = test(hpartition);
% test3 = subDataset(idxNew,:);
% 
% subDataset = dataset(dataset.labels == 4,:);
% 
% n = height(subDataset);
% hpartition = cvpartition(n,'Holdout',0.3);
% idxTrain = training(hpartition);
% train4 = subDataset(idxTrain,:);
% idxNew = test(hpartition);
% test4 = subDataset(idxNew,:);
% 
% subDataset = dataset(dataset.labels == 5,:);
% 
% n = height(subDataset);
% hpartition = cvpartition(n,'Holdout',0.3);
% idxTrain = training(hpartition);
% train5 = subDataset(idxTrain,:);
% idxNew = test(hpartition);
% test5 = subDataset(idxNew,:);


index1= find(dataset.labels == 1);
index1Train = index1(1:round(numel(index1)*percentage));
index1Test = index1(round(numel(index1)*percentage)+1:round(numel(index1)));

index2= find(dataset.labels == 2);
index2Train = index2(1:round(numel(index2)*percentage));
index2Test = index2(round(numel(index2)*percentage)+1:round(numel(index2)));

index3= find(dataset.labels == 3);
index3Train = index3(1:round(numel(index3)*percentage));
index3Test = index3(round(numel(index3)*percentage)+1:round(numel(index3)));

index4= find(dataset.labels == 4);
index4Train = index4(1:round(numel(index4)*percentage));
index4Test = index4(round(numel(index4)*percentage)+1:round(numel(index4)));

index5= find(dataset.labels == 5);
index5Train = index5(1:round(numel(index5)*percentage));
index5Test = index5(round(numel(index5)*percentage)+1:round(numel(index5)));



indexTrain = [index1Train ; index2Train ; index3Train ; index4Train ; index5Train];
indexTest =  [index1Test ; index2Test ; index3Test ; index4Test ; index5Test];

XTrainSet = dataset(indexTrain,:);
XTestSet = dataset(indexTest, :);

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
legend([c1,c2])
clear c1 c2 a b c d
end

