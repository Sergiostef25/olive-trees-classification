function [train,test] = normalizeTrainTestSet(train,test)
%NORMALIZETRAINTESTSET Normalizzazion z-score dei set di training e testing
trainMean = mean(train{:,1:12});
trainStd = std(train{:,1:12});

% Normalizzazione Z-score per il set di addestramento
train{:,1:12} = (train{:,1:12} - trainMean) ./ trainStd;

% Applica la stessa normalizzazione al set di test
test{:,1:12} = (test{:,1:12} - trainMean) ./ trainStd;
end

