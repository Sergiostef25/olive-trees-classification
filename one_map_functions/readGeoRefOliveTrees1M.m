function [A1, R1, x1, y1] = readGeoRefOliveTrees1M(cultTable,tiffFile,tiffSegFile,bands, showImgages)
%READGEOREFOLIVETREES1M Lettura immagini satellitare e segmentate
%   Le immagini satellitari e segmentate vengono sovrapposte per una
%   preliminare rimozione del terreno
arguments
    cultTable table
    tiffFile (1, :) string
    tiffSegFile (1,:) string
    bands (3,1) {mustBeInteger}
    showImgages logical
end

seg_crop1 = ~logical(imread(tiffSegFile));

% lettura immagini georeferenziate 
[A1,R1] = readgeoraster(tiffFile,'Bands',bands);

proj1 = R1.ProjectedCRS;
[x1,y1] = projfwd(proj1,cultTable{:,"expolat"},cultTable{:,"expolon"});
A1=uint8(A1*500);
A1(repmat(seg_crop1, [1 1 3])) = 0;
    

if showImgages
    figure
    mapshow(A1,R1)
    hold on
    for i=1:length(x1)
        mapshow(x1(i),y1(i),DisplayType="point",Marker="o",MarkerFaceColor="g",MarkerEdgeColor="none");
    end
    title("Monopoli")
    hold off
end

end

