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
newRgbImg1 = rgbImg1;
newRgbImg1(repmat(mask1, [1 1 3])) = 255;
hsvImg = rgb2hsv(newRgbImg1);
% tonalità
hue = hsvImg(:,:,1);
% per visualizzare al meglio l'istogramma delle tonalità
% i pixel di valore 0 (nero) non vengono visualizzati

X = hue(hue ~= 0);
% figure
% imhist(X)

% Soglie impostata vedendo l'istogramma
terrainMask1 =  hsvImg(:,:,1) <= 0.18 | hsvImg(:,:,1) >= 0.45;
newRgbImgNoOut1 = newRgbImg1;
newRgbImgNoOut1(repmat(terrainMask1, [1 1 3])) = 255;


figure
subplot(2,3,1)
imshow(newRgbImg1)
title('Polignano with terrain')
subplot(2,3,2)
imshow(newRgbImgNoOut1)
title('Polignano without terrain')
subplot(2,3,3)
imshowpair(newRgbImg1,newRgbImgNoOut1)
title('Polignano differences')

newRgbImg2 = rgbImg2;
newRgbImg2(repmat(mask2, [1 1 3])) = 255;
hsvImg = rgb2hsv(newRgbImg2);
% tonalità
hue = hsvImg(:,:,1);
% per visualizzare al meglio l'istogramma delle tonalità
% i pixel di valore 0 (nero) non vengono visualizzati

X = hue(hue ~= 0);
% figure
% imhist(X)

% Soglie impostata vedendo l'istogramma
terrainMask2 =  hsvImg(:,:,1) <= 0.18 | hsvImg(:,:,1) >= 0.45;
newRgbImgNoOut2 = newRgbImg2;
newRgbImgNoOut2(repmat(terrainMask2, [1 1 3])) = 255;


subplot(2,3,4)
imshow(newRgbImg2)
title('Monopoli with terrain')
subplot(2,3,5)
imshow(newRgbImgNoOut2)
title('Monopoli without terrain')
subplot(2,3,6)
imshowpair(newRgbImg2,newRgbImgNoOut2)
title('Monopoli differences')


cultLabel1(terrainMask1) = 0;
treeLabel1(terrainMask1) = 0;

mask1 = mask1 | terrainMask1;
newA1(repmat(mask1, [1 1 3])) = 255;


cultLabel2(terrainMask2) = 0;
treeLabel2(terrainMask2) = 0;

mask2 = mask2 | terrainMask2;
newA2(repmat(mask2, [1 1 3])) = 255;

%% CalcoloVI
ndviImg1 = computeVIs(crop1, 'ndvi');
evi2Img1 = computeVIs(crop1 , 'evi2');
cireImg1 = computeVIs(crop1, 'cire');
gndviImg1 = computeVIs(crop1, 'gndvi');
grviImg1 = computeVIs(crop1, 'grvi');
psriImg1 = computeVIs(crop1, 'psri');
renImg1 = computeVIs(crop1, 'ren');
saviImg1 = computeVIs(crop1, 'savi');

ndviImg2 = computeVIs(crop2, 'ndvi');
evi2Img2 = computeVIs(crop2, 'evi2');
cireImg2 = computeVIs(crop2, 'cire');
gndviImg2 = computeVIs(crop2, 'gndvi');
grviImg2 = computeVIs(crop2, 'grvi');
psriImg2 = computeVIs(crop2, 'psri');
renImg2 = computeVIs(crop2, 'ren');
saviImg2 = computeVIs(crop2, 'savi');

ndviImg1(mask1)=0;
evi2Img1(mask1)=0;
cireImg1(mask1)=0;
gndviImg1(mask1)=0;
grviImg1(mask1)=0;
psriImg1(mask1)=0;
renImg1(mask1)=0;
saviImg1(mask1)=0;

ndviImg2(mask2)=0;
evi2Img2(mask2)=0;
cireImg2(mask2)=0;
gndviImg2(mask2)=0;
grviImg2(mask2)=0;
psriImg2(mask2)=0;
renImg2(mask2)=0;
saviImg2(mask2)=0;
%% Merge immagine
additionNewA1 = zeros(m2-m1,n1,3);
additionNewA1(:) = 255;
mergedRgbImg = cat(2, [newA1; additionNewA1], newA2);
figure
imshow(mergedRgbImg)
title('Polignano and Monopoli merged')

mergedCultLabel = cat(2, [cultLabel1; zeros(m2-m1,n1)], cultLabel2);
mergedTreeLabel = cat(2, [treeLabel1; zeros(m2-m1,n1)], treeLabel2);


ndviImg = cat(2, [ndviImg1; zeros(m2-m1,n1)], ndviImg2);
clear ndviImg1 ndviImg2
evi2Img = cat(2, [evi2Img1; zeros(m2-m1,n1)], evi2Img2);
clear evi2Img1 evi2Img2
cireImg = cat(2, [cireImg1; zeros(m2-m1,n1)], cireImg2);
clear cireImg1 cireImg2
gndviImg = cat(2, [gndviImg1; zeros(m2-m1,n1)], gndviImg2);
clear gndviImg1 gndviImg2
grviImg = cat(2, [grviImg1; zeros(m2-m1,n1)], grviImg2);
clear grviImg1 grviImg2
psriImg = cat(2, [psriImg1; zeros(m2-m1,n1)], psriImg2);
clear psriImg1 psriImg2
renImg = cat(2, [renImg1; zeros(m2-m1,n1)], renImg2);
clear renImg1 renImg2
saviImg = cat(2, [saviImg1; zeros(m2-m1,n1)], saviImg2);
clear saviImg1 saviImg2;

%% Visualizza VI
figure
imagesc(ndviImg);
colorbar
title('NDVI')

figure
imagesc(evi2Img);
colorbar
title('EVI2')

figure
imagesc(cireImg);
colorbar
title('CIRE')

figure
imagesc(gndviImg);
colorbar
title('GNDVI')

figure
imagesc(grviImg);
colorbar
title('GRVI')

figure
imagesc(psriImg, [0, 1]);
colorbar
title('PSRI')

figure
imagesc(renImg);
colorbar
title('REN')

figure
imagesc(saviImg);
colorbar
title('SAVI')
%% Creazione Dataset
notTerrIdx = find(mergedCultLabel);
[rowDataset, colDataset] = ind2sub(size(mergedCultLabel),notTerrIdx);

green = cat(2, [crop1.DataCube(:,:,22); zeros(m2-m1,n1)], crop2.DataCube(:,:,22));
red = cat(2, [crop1.DataCube(:,:,26); zeros(m2-m1,n1)], crop2.DataCube(:,:,26));
redEdge = cat(2, [crop1.DataCube(:,:,37); zeros(m2-m1,n1)], crop2.DataCube(:,:,37));
nir = cat(2, [crop1.DataCube(:,:,46); zeros(m2-m1,n1)], crop2.DataCube(:,:,46));

dataset = table(ndviImg(notTerrIdx),evi2Img(notTerrIdx),cireImg(notTerrIdx),gndviImg(notTerrIdx),grviImg(notTerrIdx),psriImg(notTerrIdx),renImg(notTerrIdx),saviImg(notTerrIdx), ...
    green(notTerrIdx), red(notTerrIdx), redEdge(notTerrIdx), nir(notTerrIdx), rowDataset, colDataset, mergedTreeLabel(notTerrIdx),zeros(size(notTerrIdx)),...
    'VariableNames',{'ndvi','evi2','cire','gndvi','grvi','psri','ren','savi', 'green','red','rededge','nir','row','col','treenum','place'});
%% Creazione Training e Test set
% length(find(mergedCultLabel == 11))
aa = cultName;

