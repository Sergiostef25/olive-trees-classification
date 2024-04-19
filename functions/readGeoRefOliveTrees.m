function [A1, R1, A2, R2, x1, y1, x2, y2] = readGeoRefOliveTrees(cultTable, polignanoTiffFile,polignanoTiffSegFile,polignanoBands,monopoliTiffFile,monopoliTiffSegFile,monopoliBands, showImgages)
%READGEOREFOLIVETREES Lettura immagini satellitare e segmentate
%   Le immagini satellitari e segmentate vengono sovrapposte per una
%   preliminare rimozione del terreno
arguments
    cultTable (:,4) table
    polignanoTiffFile (1, :) string
    polignanoTiffSegFile (1,:) string
    polignanoBands (3,1) {mustBeInteger}
    monopoliTiffFile (1, :) string
    monopoliTiffSegFile (1,:) string
    monopoliBands (3,1) {mustBeInteger}
    showImgages logical
end

seg_crop1 = ~logical(imread(polignanoTiffSegFile));
seg_crop2 = ~logical(imread(monopoliTiffSegFile));

idx = cultTable.location == 0;

% lettura immagini georeferenziate 
[A1,R1] = readgeoraster(polignanoTiffFile,'Bands',polignanoBands);

proj1 = R1.ProjectedCRS;
[x1,y1] = projfwd(proj1,cultTable{idx,"expolat"},cultTable{idx,"expolon"});
A1=uint8(A1*500);
A1(repmat(seg_crop1, [1 1 3])) = 0;
    

[A2,R2] = readgeoraster(monopoliTiffFile,'Bands',monopoliBands);
proj2 = R2.ProjectedCRS;
[x2,y2] = projfwd(proj2,cultTable{~idx,"expolat"},cultTable{~idx,"expolon"});
A2=uint8(A2*500);
A2(repmat(seg_crop2, [1 1 3])) = 0;

if showImgages
    figure
    subplot(1,2,1)
    mapshow(A1,R1)
    hold on
    for i=1:length(x1)
        mapshow(x1(i),y1(i),DisplayType="point",Marker="o",MarkerFaceColor="g",MarkerEdgeColor="none");
    end
    title("Polignano")
    hold off
    
    subplot(1,2,2)
    mapshow(A2,R2)
    hold on
    for i=1:length(x2)
        mapshow(x2(i),y2(i),DisplayType="point",Marker="o",MarkerFaceColor="g",MarkerEdgeColor="none");
    end
    title("Monopoli")
    hold off
end

end

