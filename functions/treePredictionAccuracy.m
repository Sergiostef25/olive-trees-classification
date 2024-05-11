function treePredictionAccuracy(XTestSet,YTestSet,Ypredicted)
%TREEPREDICTIONACCURACY Summary of this function goes here
XTestSetUniqueTrees = unique(XTestSet.treenum);
conf = zeros(length(XTestSetUniqueTrees),1);
for i=1:length(XTestSetUniqueTrees)
    indexTree = XTestSet.treenum == XTestSetUniqueTrees(i);
    % se la differenza non è zero vuol dire che il pixel non è stato
    % correttamente classifcato
    a = nnz(abs(YTestSet(indexTree)-Ypredicted(indexTree)));
    conf(i) = 100-a*100/nnz(indexTree);
    fprintf('Tree n. %d confidence: %.2f%%\n',i,conf(i))
end
end

