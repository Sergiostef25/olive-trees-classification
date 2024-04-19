function [cultTable, newCultCounts] = removeLowCountTrees(cultTable,cultCounts)
%REMOVELOWCOUNTTREES rimozione alberi che sono presenti soltanto una volta

arguments
    cultTable (:,4) table
    cultCounts (:,1) cell
end

% conteggio tipologie alberi di ulivo
for i=1:length(cultCounts)
    cultCounts{i,2} = nnz(cultTable.cult == i);
end

idx = false(height(cultTable),1);

for i=1:height(cultTable)
    if cultCounts{cultTable{i,"cult"},2} == 1
        idx(i) = true;
    end
end

cultTable(idx,:) = [];

newCultCounts = cell(length(find(idx)),2);
k = 1;
for i=1:length(cultCounts)
    if ~isequal(cultCounts{i,2},1)
        newCultCounts{k,1} = cultCounts{i,1};
        newCultCounts{k,2} = cultCounts{i,2};
        k = k + 1;
    end

end

end

