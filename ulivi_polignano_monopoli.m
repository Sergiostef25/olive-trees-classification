%% Coordinates Reading and Tree Selection
oliveTreesTable = createOliveTreesTable(readtable('new_data/ulivi_in_CROP1_RGB.xlsx'), readtable('new_data/ulivi_in_CROP2_RGB.xlsx'));

oliveTreesTable(oliveTreesTable.cult == "Altro", :) = [];

% encoding delle tipologie di ultivo (da stringa a numero)
[cultEncoded, cultNameAndCount] = grp2idx(oliveTreesTable.cult);
oliveTreesTable.cult = cultEncoded;

[oliveTreesTable, cultNameAndCount] = removeLowCountTrees(oliveTreesTable, cultNameAndCount, 11);

%% Hypercubes and Georaster
% lettura hypercube utili per estrapolare le informazioni iperspettrali
% delle immagini, sopratutto per visulaizzare le immagini in RGB

waves=[386,400.3,405.1,409.9,414.6,419.4,424.1,430.1,436,440.8,445.6,450.3,455.1,482.4,509.7,514.5,519.2,525.2,531.1,535.8,543,550.1,559.6,569.1,620,671,675.7,680.5,685.2,690,694.7,699.4,705.4,711.3,716,720.8,725.5,730.2,735,739.7,744.5,749.2,755.1,761,781.2,801.3,930.5]';

crop1=hypercube('new_data/CROP1_47.tif',waves);
[rgbImg1, bands1] = colorize(crop1,'Method','rgb','ContrastStretching',true);

crop2=hypercube('new_data/CROP2_47.tif',waves);
[rgbImg2, bands2] = colorize(crop2,'Method','rgb','ContrastStretching',true);

[A1, R1, A2, R2, x1, y1, x2, y2] = readGeoRefOliveTrees(oliveTreesTable, ...
    'new_data/CROP1_47.tif','new_data/Seg_CROP1.tif',bands1, ...
    'new_data/CROP2_47.tif','new_data/Seg_CROP2.tif',bands2, true);

[m1, n1, ~] = size(A1);
[m2, n2, ~] = size(A2);
%% Labeling and Segmentation Refinement
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

displayLabeledOliveTree(rgbImg1,rgbImg2,cultLabel1,cultLabel2, cultNameAndCount)
%% HSV mask to remove terrain from segmented image
terrainMask1 = applyTerrainMask(rgbImg1, mask1, 'Polignano');

% pixels that were previously mistakenly part of an olive tree will now be labelled as land
cultLabel1(terrainMask1) = 0;
treeLabel1(terrainMask1) = 0;

% the segmentation mask is merged with the terrain mask
mask1 = mask1 | terrainMask1;
newA1(repmat(mask1, [1 1 3])) = 255;

terrainMask2 = applyTerrainMask(rgbImg2, mask2, 'Monopoli');

cultLabel2(terrainMask2) = 0;
treeLabel2(terrainMask2) = 0;

mask2 = mask2 | terrainMask2;
newA2(repmat(mask2, [1 1 3])) = 255;
%% CalcoloVI
[ndviImg1,evi2Img1,cireImg1,gndviImg1,grviImg1,psriImg1,renImg1,saviImg1,ipviImg1,rdviImg1,gosaviImg1] = computeVisAndApplyMask(crop1, mask1);
[ndviImg2,evi2Img2,cireImg2,gndviImg2,grviImg2,psriImg2,renImg2,saviImg2,ipviImg2,rdviImg2,gosaviImg2] = computeVisAndApplyMask(crop2, mask2);
%% Merge immagine

[rgbImg, cultLabel, treeLabel] = mergeOliveTreesImages(newA1,newA2,m1,m2,n1, cultLabel1, cultLabel2, treeLabel1, treeLabel2);


[ndviImg,evi2Img,cireImg,gndviImg,grviImg,psriImg,renImg,saviImg,ipviImg,rdviImg,gosaviImg] = mergeOliveTreesVIs(m2,m1,n1,ndviImg1,evi2Img1,cireImg1, ...
    gndviImg1,grviImg1,psriImg1,renImg1,saviImg1,ipviImg1,rdviImg1,gosaviImg1, ...
    ndviImg2,evi2Img2,cireImg2,gndviImg2,grviImg2,psriImg2,renImg2,saviImg2,ipviImg2,rdviImg2,gosaviImg2);

displayVIs(ndviImg,evi2Img,cireImg,gndviImg,grviImg,psriImg,renImg,saviImg,ipviImg,rdviImg,gosaviImg);

clear cultLabel1 cultLabel2 treeLabel1 treeLabel2
clear ndviImg1 ndviImg2 evi2Img1 evi2Img2 cireImg1 cireImg2 gndviImg1 gndviImg2 grviImg1 grviImg2 psriImg1 psriImg2 renImg1 renImg2 saviImg1 saviImg2 ipviImg1 ipviImg2 rdviImg1 rdviImg2 gosaviImg1 gosaviImg2;
%% Creazione Dataset
notTerrainIdx = find(cultLabel);
labels = cultLabel(notTerrainIdx);
treeNumLabels = treeLabel(notTerrainIdx);

green = cat(2, [crop1.DataCube(:,:,22); zeros(m2-m1,n1)], crop2.DataCube(:,:,22));
red = cat(2, [crop1.DataCube(:,:,26); zeros(m2-m1,n1)], crop2.DataCube(:,:,26));
redEdge = cat(2, [crop1.DataCube(:,:,37); zeros(m2-m1,n1)], crop2.DataCube(:,:,37));
nir = cat(2, [crop1.DataCube(:,:,46); zeros(m2-m1,n1)], crop2.DataCube(:,:,46));

dataset = table(ndviImg(notTerrainIdx),evi2Img(notTerrainIdx),cireImg(notTerrainIdx),gndviImg(notTerrainIdx),grviImg(notTerrainIdx),psriImg(notTerrainIdx),renImg(notTerrainIdx),saviImg(notTerrainIdx),ipviImg(notTerrainIdx),rdviImg(notTerrainIdx),gosaviImg(notTerrainIdx), ...
    green(notTerrainIdx), red(notTerrainIdx), redEdge(notTerrainIdx), nir(notTerrainIdx), labels, treeNumLabels,notTerrainIdx,...
    'VariableNames',{'ndvi','evi2','cire','gndvi','grvi','psri','ren','savi','ipvi','rdvi','gosavi','green','red','rededge','nir','labels','treenum','index'});
%% Creazione Training, Test set e normalizzazione
[XTrainSet, XTestSet] = createAndDisplayTrainTestSet(dataset, 0.7, rgbImg);
[XTrainSet,XTestSet] = normalizeTrainTestSet(XTrainSet,XTestSet);

%% Correlazione
[XTrainSetNew,XTestSetNew] = correlationFeatureSelection(XTrainSet,XTestSet,0.85);
YTrainSet = XTrainSetNew.labels;
YTestSet = XTestSetNew.labels;
XTrainSetNew = removevars(XTrainSetNew,"labels");
XTestSetNew = removevars(XTestSetNew,"labels");
numberOfFeatures = size(XTrainSetNew,2);
fprintf('Number of features selected: %d\n',numberOfFeatures)

figure
scatter3(XTrainSetNew{:,1},XTrainSetNew{:,2},XTrainSetNew{:,3},10,YTrainSet,'filled')
ax = gca;
ax.XDir = 'reverse';
view(-31,14)
xlabel(XTestSetNew.Properties.VariableNames{1})
ylabel(XTestSetNew.Properties.VariableNames{2})
zlabel(XTestSetNew.Properties.VariableNames{3})

cb = colorbar;                             
cb.Label.String = 'Labels';
%% Training KNN
rng(1)
t1 = datetime;
knnMdl = fitcknn(XTrainSetNew,YTrainSet,'NumNeighbors',40,'Standardize',1);
cvKnnMdl = crossval(knnMdl); %10-fold
t2 = datetime;
fprintf('Durata training KNN -> %s\n',between(t1,t2))
knnGenError = kfoldLoss(cvKnnMdl,Mode="individual");
knnTrainAcc = 1 - knnGenError;

fprintf('Average KNN Training Accuracy: %0.2f%%\n',mean(knnTrainAcc*100))
[bestKnnTestAccuracy, bestKnnModel] = max(knnTrainAcc);
fprintf('Best KNN Model is the number %d with %.2f%% of Training Accuracy\n',bestKnnModel,bestKnnTestAccuracy*100)
%% Testing KNN
[YpredictedKnn,scoreKnn] = predict(cvKnnMdl.Trained{bestKnnModel},XTestSetNew);
knnTestLoss = loss(cvKnnMdl.Trained{bestKnnModel},XTestSetNew,YTestSet);
knnTestAccuracy = 1-knnTestLoss;

C = confusionmat(YTestSet,YpredictedKnn);
figure
confusionchart(C,cultNameAndCount(:,1),'RowSummary','row-normalized','ColumnSummary','column-normalized');
displayPredictionResults(rgbImg,XTestSet, YTestSet,YpredictedKnn)
displayAUC(cultNameAndCount,YTestSet,scoreKnn)
treePredictionAccuracy(XTestSet,YTestSet,YpredictedKnn);
%% Training SVM
rng(1)
t1 = datetime;
t = templateSVM;
svmMdl = fitcecoc(XTrainSetNew,YTrainSet,'Learners',t,'ObservationsIn','rows');
cvSvmMdl = crossval(svmMdl); %10-fold

t2 = datetime;
fprintf('Durata training SVM -> %s\n',between(t1,t2))
svMgenError = kfoldLoss(cvSvmMdl);
svmTrainAcc = 1 - svMgenError;
fprintf('Average SVM Training Accuracy: %0.2f%%\n',mean(svmTrainAcc*100))
[bestSvmTestAccuracy, bestSvmModel] = max(svmTrainAcc);
fprintf('Best SVM Model is the number %d with %.2f%% of Training Accuracy\n',bestSvmModel,bestSvmTestAccuracy*100)
%% Testing SVM
[YpredictedSvm,scoreSvm] = predict(cvSvmMdl.Trained{bestSvmModel},XTestSetNew);
svmTestLoss = loss(cvSvmMdl.Trained{bestSvmModel},XTestSetNew,YTestSet);
svmTestAccuracy = 1-svmTestLoss;

C = confusionmat(YTestSet,YpredictedSvm);
figure
confusionchart(C,cultNameAndCount(:,1),'RowSummary','row-normalized','ColumnSummary','column-normalized');
displayPredictionResults(rgbImg,XTestSet, YTestSet,YpredictedSvm)
displayAUC(cultNameAndCount,YTestSet,scoreSvm)

treePredictionAccuracy(XTestSet,YTestSet,YpredictedSvm);
%% Training Random Forest
rng(1)
XTrainTestSetNewRF = [XTrainSetNew; XTestSetNew];
XTrainTestSetRF=[XTrainSet; XTestSet];
YTrainTestSetRF = [YTrainSet; YTestSet];
t1 = datetime;
rfMdl = TreeBagger(500,XTrainTestSetNewRF, YTrainTestSetRF,Method="classification",OOBPrediction="on",Options=statset(UseParallel=true));
t2 = datetime;
fprintf('Durata training Random Forest -> %s\n',between(t1,t2))
% view(rfMdl.Trees{1},Mode="graph")
oobLoss = oobError(rfMdl);
oobAccuracy = 1-oobLoss;
fprintf('Average Training Random Forest Accuracy: %.2f%%\n',mean(oobAccuracy)*100)
plot(oobLoss)
xlabel("Number of Grown Trees")
ylabel("Out-of-Bag Classification Error")

%% Testing Random Forest
[oobLabels, oobScore] = oobPredict(rfMdl);
oobLabels = str2num(cell2mat(oobLabels));

C = confusionmat(YTrainTestSetRF,oobLabels);
figure
confusionchart(C,cultNameAndCount(:,1),'RowSummary','row-normalized','ColumnSummary','column-normalized');
% Da modificare per il random foreset
displayPredictionResultsForRF(rgbImg,XTrainTestSetRF,oobLabels);
displayAUC(cultNameAndCount,YTrainTestSetRF,oobScore)
treePredictionAccuracy(XTrainTestSetRF,YTrainTestSetRF,oobLabels);


