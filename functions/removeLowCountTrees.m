function [cultTable, newCultCounts] = removeLowCountTrees(cultTable,cultCounts, threshold)
%REMOVELOWCOUNTTREES rimozione alberi che sono presenti soltanto una volta

arguments
    cultTable table
    cultCounts (:,1) cell
    threshold
end

% conteggio tipologie alberi di ulivo
for i=1:length(cultCounts)
    cultCounts{i,2} = nnz(cultTable.cult == i);
end

idx = false(height(cultTable),1);

for i=1:height(cultTable)
    if cultCounts{cultTable{i,"cult"},2} <= threshold 
        idx(i) = true;
    end
end

cultTable(idx,:) = [];

k = 1;
for i=1:length(cultCounts)
    if cultCounts{i,2} > threshold
        newCultCounts{k,1} = cultCounts{i,1};
        newCultCounts{k,2} = cultCounts{i,2};
        k = k + 1;
    end

end

% rifaccio l'encoding dopo la rimozione di alcune categorie
cultEncoded = grp2idx(cultTable.cult);
cultTable.cult = cultEncoded;

end

