%% Lettura coordinate
oliveTreesTable = createOliveTreesTable1M(readtable('new_data/ulivi_in_CROP2_RGB.xlsx'));
%oliveTreesTable(oliveTreesTable.cult == "Altro", :) = [];


% encoding delle tipologie di ultivo (da stringa a numero)
[cultEncoded, cultNameAndCount] = grp2idx(oliveTreesTable.cult);
oliveTreesTable.cult = cultEncoded;

[oliveTreesTable, cultNameAndCount] = removeLowCountTrees(oliveTreesTable, cultNameAndCount, 10);

% rifaccio l'encoding dopo la rimozione di alcune categorie
cultEncoded = grp2idx(oliveTreesTable.cult);
oliveTreesTable.cult = cultEncoded;

clear cultEncoded
%% Hypercubes
% lettura hypercube utili per estrapolare le informazioni iperspettrali
% delle immagin, sopratutto per visulaizzare le immagini in RGB

waves=[386,400.3,405.1,409.9,414.6,419.4,424.1,430.1,436,440.8,445.6,450.3,455.1,482.4,509.7,514.5,519.2,525.2,531.1,535.8,543,550.1,559.6,569.1,620,671,675.7,680.5,685.2,690,694.7,699.4,705.4,711.3,716,720.8,725.5,730.2,735,739.7,744.5,749.2,755.1,761,781.2,801.3,930.5]';

crop=hypercube('new_data/CROP2_47.tif',waves);
[rgbImg, bands] = colorize(crop,'Method','rgb','ContrastStretching',true);



%% Georaster
[A, R, xx, yy] = readGeoRefOliveTrees1M(oliveTreesTable,'new_data/CROP2_47.tif','new_data/Seg_CROP2.tif',bands,false);

[m, n, ~] = size(A);

%% Da cartesiane a pixel
[newXX, newYY] = worldToIntrinsic(R,xx,yy);
newXX = round(newXX);
newYY = round(newYY);

radius = 10;
treeNum = 1;

[newA, mask, treeLabel, cultLabel, treeNum] = refineSegmentation(A,oliveTreesTable, newXX, newYY, radius, treeNum);

displayLabeledOliveTree1M(rgbImg,cultLabel)
%% Maschera HSV per eliminare il terreno dall'immagine segmentata 

terrainMask = applyTerrainMask(rgbImg, mask, 'Monopoli');

% i pixel che prima facevano erroneamente parte di un ulivo ora saranno
% etichettati come terreno
cultLabel(terrainMask) = 0;
treeLabel(terrainMask) = 0;

% la maschera della segmentazione viene unita a quella del terreno
mask = mask | terrainMask;
newA(repmat(mask, [1 1 3])) = 255;

%% CalcoloVI
[ndviImg,evi2Img,cireImg,gndviImg,grviImg,psriImg,renImg,saviImg] = computeVisAndApplyMask(crop, mask);

%% Creazione Dataset
notTerrainIdx = find(cultLabel);
labels = cultLabel(notTerrainIdx);

green = crop.DataCube(:,:,22);
red = crop.DataCube(:,:,26);
redEdge = crop.DataCube(:,:,37);
nir = crop.DataCube(:,:,46);

dataset = table(ndviImg(notTerrainIdx),evi2Img(notTerrainIdx),cireImg(notTerrainIdx),gndviImg(notTerrainIdx),grviImg(notTerrainIdx),psriImg(notTerrainIdx),renImg(notTerrainIdx),saviImg(notTerrainIdx), ...
    green(notTerrainIdx), red(notTerrainIdx), redEdge(notTerrainIdx), nir(notTerrainIdx),labels, treeLabel(notTerrainIdx),notTerrainIdx,...
    'VariableNames',{'ndvi','evi2','cire','gndvi','grvi','psri','ren','savi', 'green','red','rededge','nir','labels','treenum','index'});

%% Creazione Training, Test set e normalizzazione
[XTrainSet, XTestSet] = createAndDisplayTrainTestSet(dataset, 0.7, rgbImg);
[XTrainSet,XTestSet] = normalizeTrainTestSet(XTrainSet,XTestSet);

%% Correlazione
[XTrainSetNew,XTestSetNew] = correlationFeatureSelection(XTrainSet,XTestSet,0.85);
YTrainSet = XTrainSetNew.labels;
YTestSet = XTestSetNew.labels;
XTrainSetNew = removevars(XTrainSetNew,"labels");
XTestSetNew = removevars(XTestSetNew,"labels");


numberOfFeatures = size(XTrainSetNew,2)-1

scatter3(XTrainSetNew{:,1},XTrainSetNew{:,2},XTrainSetNew{:,3},10,YTrainSet,'filled')
ax = gca;
ax.XDir = 'reverse';
view(-31,14)
xlabel(XTestSetNew.Properties.VariableNames{1})
ylabel(XTestSetNew.Properties.VariableNames{2})
zlabel(XTestSetNew.Properties.VariableNames{3})

cb = colorbar;                             
cb.Label.String = 'Labels';
%% Training e Testing KNN
rng(1)
% mdl = fitcknn(XTrainSetNew,YTrainSet,'NumNeighbors',5,'Standardize',1);
% mdl = fitcknn(XTrainSetNew,YTrainSet,'OptimizeHyperparameters','auto',...
%     'HyperparameterOptimizationOptions',...
%     struct('AcquisitionFunctionName','expected-improvement-plus'));
t = templateKNN;
t1 = datetime;
% mdl = fitcecoc(XTrainSetNew,YTrainSet,YTrainSet{:,:},'Learners',t,'ObservationsIn','rows','OptimizeHyperparameters','auto',...
%     'HyperparameterOptimizationOptions',struct('AcquisitionFunctionName',...
%     'expected-improvement-plus'))

mdl = fitcecoc(XTrainSetNew,YTrainSet,'Learners',t,'ObservationsIn','rows')
cvmdl = crossval(mdl); %10-fold

t2 = datetime;
fprintf('Durata training knn -> %s\n',between(t1,t2))
genError = kfoldLoss(cvmdl)
trainAcc = 1 -genError
%%
[Ypredicted,score,cost] = predict(cvmdl.Trained{1},XTestSetNew);

C = confusionmat(YTestSet,Ypredicted);
figure
cm = confusionchart(C,cultNameAndCount(:,1));


%% AUC curve
AUC = zeros(size(cultNameAndCount,1));
legends = cell(size(cultNameAndCount,1),1);
figure
hold on
for i=1:size(cultNameAndCount,1)
    [X,Y,T,AUC(i)] = perfcurve(YTestSet,score(:,1),i);
    plot(X,Y)
    legends{i} = sprintf('AUC for %s class: %.3f', cultNameAndCount{i,1}, AUC(i));
end
legend(legends, 'location', 'southeast')
    xlabel('False positive rate'); ylabel('True positive rate');
    title('ROC for Classification by KNN')
hold off
%% Training SVM
rng(1)
t = templateSVM;
t1 = datetime;
mdl = fitcecoc(XTrainSetNew,YTrainSet,'Learners',t,'ObservationsIn','rows')
cvmdl = crossval(mdl); %10-fold

t2 = datetime;
fprintf('Durata training knn -> %s\n',between(t1,t2))
genError = kfoldLoss(cvmdl)
trainAcc = 1 -genError
%%

[Ypredicted,score,cost] = predict(cvmdl.Trained{5},XTestSetNew);

C = confusionmat(YTestSet,Ypredicted);
figure
cm = confusionchart(C,cultNameAndCount(:,1));
%% AUC curve
AUC = zeros(size(cultNameAndCount,1));
legends = cell(size(cultNameAndCount,1),1);
figure
hold on
for i=1:size(cultNameAndCount,1)
    [X,Y,T,AUC(i)] = perfcurve(YTestSet,score(:,1),i);
    plot(X,Y)
    legends{i} = sprintf('AUC for %s class: %.3f', cultNameAndCount{i,1}, AUC(i));
end
legend(legends, 'location', 'southeast')
    xlabel('False positive rate'); ylabel('True positive rate');
    title('ROC for Classification by KNN')
hold off
