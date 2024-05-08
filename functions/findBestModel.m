function [k,bestKnnTestAccuracy] = findBestModel(cvMdl,XTestSet,YTestSet)
%FINDBESTMODEL Find best model from kfold cross validation training
k = 1;
bestKnnTestAccuracy = 0;
for i=1:10
    knnTestLoss = loss(cvMdl.Trained{i},XTestSet,YTestSet);
    knnTestAccuracy = 1-knnTestLoss;
    if knnTestAccuracy > bestKnnTestAccuracy
        k = i;
        bestKnnTestAccuracy = knnTestAccuracy;
    end
end
end

