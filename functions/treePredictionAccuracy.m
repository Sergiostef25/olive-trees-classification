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
    fprintf('Tree n. %d confidence: %.2f%%\n',XTestSetUniqueTrees(i),conf(i))
end
    correctlyClassTree = nnz(conf >=60);
    fprintf('Percentage of correctly classified olive trees, with confidence greater than 60%% is:\n%.2f%% (%d out of %d)\n',correctlyClassTree*100/length(conf),correctlyClassTree,length(conf))
end

