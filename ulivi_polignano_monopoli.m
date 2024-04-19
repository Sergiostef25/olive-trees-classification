%% Lettura coordinate
oliveTreesTable = createOliveTreesTable(readtable('new_data/ulivi_in_CROP1_RGB.xlsx'), readtable('new_data/ulivi_in_CROP2_RGB.xlsx'));

% encoding delle tipologie di ultivo (da stringa a numero)
[cultEncoded, cultNameAndCount] = grp2idx(oliveTreesTable.cult);
oliveTreesTable.cult = cultEncoded;

[oliveTreesTable, cultNameAndCount] = removeLowCountTrees(oliveTreesTable, cultNameAndCount);

% rifaccio l'encoding dopo la rimozione di alcune categorie
cultEncoded = grp2idx(oliveTreesTable.cult);
oliveTreesTable.cult = cultEncoded;

clear cultEncoded
%% Hypercubes
% lettura hypercube utili per estrapolare le informazioni iperspettrali
% delle immagin, sopratutto per visulaizzare le immagini in RGB

waves=[386,400.3,405.1,409.9,414.6,419.4,424.1,430.1,436,440.8,445.6,450.3,455.1,482.4,509.7,514.5,519.2,525.2,531.1,535.8,543,550.1,559.6,569.1,620,671,675.7,680.5,685.2,690,694.7,699.4,705.4,711.3,716,720.8,725.5,730.2,735,739.7,744.5,749.2,755.1,761,781.2,801.3,930.5]';

crop1=hypercube('new_data/CROP1_47.tif',waves);
[rgbImg1, bands1] = colorize(crop1,'Method','rgb','ContrastStretching',true);

crop2=hypercube('new_data/CROP2_47.tif',waves);
[rgbImg2, bands2] = colorize(crop2,'Method','rgb','ContrastStretching',true);



%% Georaster
[A1, R1, A2, R2, x1, y1, x2, y2] = readGeoRefOliveTrees(oliveTreesTable, ...
    'new_data/CROP1_47.tif','new_data/Seg_CROP1.tif',bands1, ...
    'new_data/CROP2_47.tif','new_data/Seg_CROP2.tif',bands2, false);

[m1, n1, ~] = size(A1);
[m2, n2, ~] = size(A2);

%% Da cartesiane a pixel
[newX1, newY1] = worldToIntrinsic(R1,x1,y1);
newX1 = round(newX1);
newY1 = round(newY1);
[newX2, newY2] = worldToIntrinsic(R2,x2,y2);
newX2 = round(newX2);
newY2 = round(newY2);

radius = 10;
treeNum = 1;

[newA1, mask1, treeLabel1, cultLabel1, treeNum] = refineSegmentation(A1,oliveTreesTable, newX1, newY1, radius, treeNum);

[newA2, mask2, treeLabel2, cultLabel2, treeNum] = refineSegmentation(A2,oliveTreesTable, newX2, newY2, radius, treeNum);


displayLabeledOliveTree(rgbImg1,rgbImg2,cultLabel1,cultLabel2)
%% Maschera HSV per eliminare il terreno dall'immagine segmentata 

terrainMask1 = applyTerrainMask(rgbImg1, mask1, 'Polignano');

% i pixel che prima facevano erroneamente parte di un ulivo ora saranno
% etichettati come terreno
cultLabel1(terrainMask1) = 0;
treeLabel1(terrainMask1) = 0;

% la maschera della segmentazione viene unita a quella del terreno
mask1 = mask1 | terrainMask1;
newA1(repmat(mask1, [1 1 3])) = 255;

terrainMask2 = applyTerrainMask(rgbImg2, mask2, 'Monopoli');

cultLabel2(terrainMask2) = 0;
treeLabel2(terrainMask2) = 0;

mask2 = mask2 | terrainMask2;
newA2(repmat(mask2, [1 1 3])) = 255;
%% CalcoloVI
[ndviImg1,evi2Img1,cireImg1,gndviImg1,grviImg1,psriImg1,renImg1,saviImg1] = computeVisAndApplyMask(crop1, mask1);
[ndviImg2,evi2Img2,cireImg2,gndviImg2,grviImg2,psriImg2,renImg2,saviImg2] = computeVisAndApplyMask(crop2, mask2);
%% Merge immagine

[rgbImg, cultLabel, treeLabel] = mergeOliveTreesImages(newA1,newA2,m1,m2,n1, cultLabel1, cultLabel2, treeLabel1, treeLabel2);


[ndviImg,evi2Img,cireImg,gndviImg,grviImg,psriImg,renImg,saviImg] = mergeOliveTreesVIs(m2,m1,n1,ndviImg1,evi2Img1,cireImg1, ...
    gndviImg1,grviImg1,psriImg1,renImg1,saviImg1, ...
    ndviImg2,evi2Img2,cireImg2,gndviImg2,grviImg2,psriImg2,renImg2,saviImg2);

clear cultLabel1 cultLabel2 treeLabel1 treeLabel2
clear ndviImg1 ndviImg2 evi2Img1 evi2Img2 cireImg1 cireImg2 gndviImg1 gndviImg2 grviImg1 grviImg2 psriImg1 psriImg2 renImg1 renImg2 saviImg1 saviImg2;

%displayVIs(ndviImg,evi2Img,cireImg,gndviImg,grviImg,psriImg,renImg,saviImg);

%% Creazione Dataset
notTerrainIdx = find(cultLabel);
labels = cultLabel(notTerrainIdx);

green = cat(2, [crop1.DataCube(:,:,22); zeros(m2-m1,n1)], crop2.DataCube(:,:,22));
red = cat(2, [crop1.DataCube(:,:,26); zeros(m2-m1,n1)], crop2.DataCube(:,:,26));
redEdge = cat(2, [crop1.DataCube(:,:,37); zeros(m2-m1,n1)], crop2.DataCube(:,:,37));
nir = cat(2, [crop1.DataCube(:,:,46); zeros(m2-m1,n1)], crop2.DataCube(:,:,46));

dataset = table(ndviImg(notTerrainIdx),evi2Img(notTerrainIdx),cireImg(notTerrainIdx),gndviImg(notTerrainIdx),grviImg(notTerrainIdx),psriImg(notTerrainIdx),renImg(notTerrainIdx),saviImg(notTerrainIdx), ...
    green(notTerrainIdx), red(notTerrainIdx), redEdge(notTerrainIdx), nir(notTerrainIdx), treeLabel(notTerrainIdx),notTerrainIdx,labels,...
    'VariableNames',{'ndvi','evi2','cire','gndvi','grvi','psri','ren','savi', 'green','red','rededge','nir','treenum','index','labels'});
%% Creazione Training e Test set
[XTrainSet, XTestSet] = createAndDisplayTrainTestSet(dataset, 0.7, rgbImg);

%% Normalizzazione del dataset
XTrainSetMean = mean(XTrainSet{:,1:12});
XTrainSetStd = std(XTrainSet{:,1:12});

% Normalizzazione Z-score per il set di addestramento
XTrainSet{:,1:12} = (XTrainSet{:,1:12} - XTrainSetMean) ./ XTrainSetStd;

% Applica la stessa normalizzazione al set di test
XTestSet{:,1:12} = (XTestSet{:,1:12} - XTrainSetMean) ./ XTrainSetStd;