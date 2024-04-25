function  newTable= createOliveTreesTable1M(oldTable)
%CREATEOLIVETREESTABLE1M creazione tabella risultante
%   creazione tabella a partire dalle tabelle di Polignano e Monopoli.
%   Prima di unirle, le righe che hanno nella colonna 
%   Cult (il tipo di albero di ulivo) vengono rimosse

arguments
    oldTable (:,4) table
end


oldTable.Ris = [];
oldTable.Cult = categorical(oldTable.Cult);
missingCultIndex = ismissing(oldTable.Cult);
oldTable(missingCultIndex,:)=[];


newTable = table(oldTable.expolat, oldTable.expolon, oldTable.Cult);
newTable.Properties.VariableNames = ["expolat","expolon","cult"];

clear missingCultIndex oldTable
end

