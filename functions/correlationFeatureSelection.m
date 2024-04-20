function [newTrain,newTest] = correlationFeatureSelection(train,test)
%CORRELATIONFEATURESELECTION Feature selection che scarta le feature che
%tra loro sono fortemente correlate
coeff = corrcoef(train{:,1:13});
isupper = logical(triu(ones(size(coeff)),1));
coeff(isupper) = NaN;
% Plot results
h = heatmap(coeff,'MissingDataColor','w','Colormap',jet);
labelNames = {'ndvi','evi2','cire','gndvi','grvi','psri','ren','savi', 'green','red','rededge','nir','class'};
h.XDisplayLabels = labelNames;
h.YDisplayLabels = labelNames; 

corrFeat = zeros(1,size(train(:,1:13),2));
for i=2:size(train(:,1:13),2)
    for j=1:i-1
        if abs(coeff(i,j))> 0.8
            corrFeat(i) = 1;
        end
    end

end

corrFeat = logical(corrFeat);
newTrain = removevars(train,labelNames(corrFeat));
newTrain = removevars(newTrain, {'treenum','index'});
newTest = removevars(test,labelNames(corrFeat));
newTest = removevars(newTest, {'treenum','index'});
end

