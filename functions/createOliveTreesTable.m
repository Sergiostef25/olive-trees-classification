function t = createOliveTreesTable(polignanoTable, monopoliTable)
%CREATEOLIVETREESTABLE creazione tabella risultante
%   creazione tabella a partire dalle tabelle di Polignano e Monopoli.
%   Prima di unirle, le righe che hanno nella colonna 
%   Cult (il tipo di albero di ulivo) vengono rimosse

arguments
    polignanoTable (:,4) table
    monopoliTable (:,4) table
end

polignanoTable.Ris = [];
polignanoTable.Cult=categorical(polignanoTable.Cult);
missingCultIndex = ismissing(polignanoTable.Cult);
polignanoTable(missingCultIndex,:)=[];

polignanoTable = table(polignanoTable.expolat, polignanoTable.expolon, polignanoTable.Cult, zeros(height(polignanoTable),1));
polignanoTable.Properties.VariableNames = ["expolat","expolon","cult","location"];


monopoliTable.Ris = [];
monopoliTable.Cult = categorical(monopoliTable.Cult);
missingCultIndex = ismissing(monopoliTable.Cult);
monopoliTable(missingCultIndex,:)=[];


monopoliTable = table(monopoliTable.expolat, monopoliTable.expolon, monopoliTable.Cult, ones(height(monopoliTable),1));
monopoliTable.Properties.VariableNames = ["expolat","expolon","cult","location"];

t = [polignanoTable;monopoliTable];

clear missingCultIndex
end

