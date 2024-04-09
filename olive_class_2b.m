im_ORIGh=hypercube('taglio_Ostuni_EL_gorgognolo.img','taglio_Ostuni_EL_gorgognolo.hdr');

crophcube = cropData(im_ORIGh, 1198:1339, 1502:1661);
[rgbImgCrop] = colorize(crophcube,'Method','rgb');

im_ORIGh_seg=hypercube('tree_segmented.dat','tree_segmented.hdr');

crophcubeSeg = cropData(im_ORIGh_seg, 1198:1339, 1502:1661);
rgbImgCropSeg = colorize(crophcubeSeg,'Method','rgb');
%% Visualizzazione delle immagini
rgbImg = colorize(im_ORIGh,'Method','rgb','ContrastStretching',true);
figure
imagesc(rgbImg)
title('RGB image')

figure
subplot(1, 2, 1);
imagesc(rgbImgCrop);
title('Cropped RGB image')
subplot(1, 2, 2);
imagesc(rgbImgCropSeg);
impixelinfo
title('Cropped image of the segmented tree crown')

%% Maschera HSV per eliminare il terreno dall'immagine segmentata
hsvImg = rgb2hsv(rgbImgCropSeg);
% tonalità
hue = hsvImg(:,:,1);
% per visualizzare al meglio l'istogramma delle tonalità
% i pixel di valore 0 (nero) non vengono visualizzati

X = hue(hue ~= 0);
figure
imhist(X)

% Soglie impostata vedendo l'istogramma
maschera_marrone =  hsvImg(:,:,1) <= 0.4 | hsvImg(:,:,1) >= 0.6;

% La maschera viene applicata all'immagine originale
newRgbImgCropSeg = rgbImgCropSeg;
% repmat ci mermette di creare una maschera per le tre dimensioni
newRgbImgCropSeg(repmat(maschera_marrone, [1 1 3])) = 0;

figure
subplot(1,3,1)
imshow(rgbImgCropSeg)
title('With terrain')
subplot(1,3,2)
imshow(newRgbImgCropSeg)
title('Without terrain')
subplot(1,3,3)
imshowpair(rgbImgCropSeg,newRgbImgCropSeg)
title('Differences')
%% Calcolo VI
ndviImg = computeVIs(crophcube, 'ndvi');
evi2Img = computeVIs(crophcube, 'evi2');
cireImg = computeVIs(crophcube, 'cire');
gndviImg = computeVIs(crophcube, 'gndvi');
grviImg = computeVIs(crophcube, 'grvi');
psriImg = computeVIs(crophcube, 'psri');
renImg = computeVIs(crophcube, 'ren');
saviImg = computeVIs(crophcube, 'savi');
%% Visualizza VI
figure
subplot(1,2,1);
imshow(rgbImgCrop);
title('Cropped RGB image')
subplot(1,2,2);
imagesc(ndviImg);
colorbar
title('NDVI')

figure
subplot(1,2,1);
imshow(rgbImgCrop);
title('Cropped RGB image')
subplot(1,2,2);
imagesc(evi2Img);
colorbar
title('EVI2')

figure
subplot(1,2,1);
imshow(rgbImgCrop);
title('Cropped RGB image')
subplot(1,2,2);
imagesc(cireImg);
colorbar
title('CIRE')

figure
subplot(1,2,1);
imshow(rgbImgCrop);
title('Cropped RGB image')
subplot(1,2,2);
imagesc(gndviImg);
colorbar
title('GNDVI')

figure
subplot(1,2,1);
imshow(rgbImgCrop);
title('Cropped RGB image')
subplot(1,2,2);
imagesc(grviImg);
colorbar
title('GRVI')


figure
subplot(1,2,1);
imshow(rgbImgCrop);
title('Cropped RGB image')
subplot(1,2,2);
imagesc(psriImg, [0, 1]);
colorbar
title('PSRI')

figure
subplot(1,2,1);
imshow(rgbImgCrop);
title('Cropped RGB image')
subplot(1,2,2);
imagesc(renImg);
colorbar
title('REN')

figure
subplot(1,2,1);
imshow(rgbImgCrop);
title('Cropped RGB image')
subplot(1,2,2);
imagesc(saviImg);
colorbar
title('SAVI')

%% Labelizzazione
finalLabelImg = im2gray(newRgbImgCropSeg);
[m, n] = size(finalLabelImg);
x = [41 49 49 60 67 67 70 70 87 89 89 95 99 112 160 160 41]; %colonne
y = [142 127 123 113 113 104 104 80 80 80 72 72 34 0 0 142 142]; %righe

rawLabels = zeros(m,n);
blackIndx = finalLabelImg == 0;

cut_mask = poly2mask(x,y,m,n);

rawLabels(~cut_mask) = 1;
rawLabels(cut_mask) = 2;
rawLabels(blackIndx) = 0;

n_ulivi = find(rawLabels == 1);
n_alberi = find(rawLabels == 2);
figure
imshow(finalLabelImg)
hold on
plot(x,y,'b','LineWidth',1)
impixelinfo
hold off
%% Centroidi
[labeledImage, numAlberi] = bwlabel(finalLabelImg);

props = regionprops(labeledImage, 'Centroid');
pixelAlberi = cell(numAlberi,1);
centroidi = cat(1, props.Centroid);
centroidi = round(centroidi);

figure
imshow(finalLabelImg);
hold on
for i = 1:size(centroidi, 1)
    x = centroidi(i, 1);
    y = centroidi(i, 2);
    pixelAlberi{i} = find(labeledImage == i);
    
        if cut_mask(y,x) == 0
            plot(x, y, 'go', 'MarkerSize', 6, 'LineWidth', 1);
            centroidi(i, 3) = 1;
        else
            plot(x, y, 'ro', 'MarkerSize', 6, 'LineWidth', 1);
            centroidi(i, 3) = 2;
        end
        
        
    
end
impixelinfo
hold off
%% Creazione Tabella
%elimino le label 0 corrispondenti al terreno
notTerrIdx = find(rawLabels);
[rowTree, colTree] = ind2sub(size(rawLabels),notTerrIdx);
labels = categorical(rawLabels(notTerrIdx),[1 2],{'Ulivo','Albero'});
treeNum = labeledImage(notTerrIdx);

green = crophcube.DataCube(:,:,22);
red = crophcube.DataCube(:,:,26);
redEdge = crophcube.DataCube(:,:,37);
nir = crophcube.DataCube(:,:,46);

dataset = table(ndviImg(notTerrIdx),evi2Img(notTerrIdx),cireImg(notTerrIdx),gndviImg(notTerrIdx),grviImg(notTerrIdx),psriImg(notTerrIdx),renImg(notTerrIdx),saviImg(notTerrIdx), ...
    green(notTerrIdx), red(notTerrIdx), redEdge(notTerrIdx), nir(notTerrIdx), rowTree, colTree, treeNum,...
    'VariableNames',{'ndvi','evi2','cire','gndvi','grvi','psri','ren','savi', 'green','red','rededge','nir','row','col','treenum'});
%% Outlier removal
[datasetWitoutOutliers, outIdx]= rmoutliers(dataset{:,1:12});
datasetWitoutOutliers = [datasetWitoutOutliers, rowTree(~outIdx), colTree(~outIdx), treeNum(~outIdx)];
newDataset = array2table(datasetWitoutOutliers,'VariableNames',{'ndvi','evi2','cire','gndvi','grvi','psri','ren','savi', 'green','red','rededge','nir','row','col','treenum'});
newLabels = labels(~outIdx);
skewnessBefore = skewness(dataset{:,1:12});
%% Skewness ndvi prima e dopo la rimozione degli outlier
skewnessAfter = skewness(dataset{:,1:12});
figure
histogram(dataset.ndvi,'DisplayName','Originale','FaceColor','blue');
hold on
histogram(newDataset.ndvi,'DisplayName','Con outlier rimossi','FaceColor','red');
legend
hold off
%% test set ulivi e alberi
xtest = [0 99 105 105 110 97 66 66 48 44 13 0 0 42];
ytest = [142 142 142 130 130 94 84 90 90 89 80 83 142 142];
test_mask = poly2mask(xtest,ytest,m,n);
figure
imshow(finalLabelImg)
hold on
plot(xtest,ytest,'r','LineWidth',2)
impixelinfo
hold off


nd = height(newDataset);
XtrainSet = array2table(zeros(0,15),'VariableNames',{'ndvi','evi2','cire','gndvi','grvi','psri','ren','savi', 'green','red','rededge','nir','row','col','treenum'});
XtestSet = array2table(zeros(0,15),'VariableNames',{'ndvi','evi2','cire','gndvi','grvi','psri','ren','savi', 'green','red','rededge','nir','row','col','treenum'});
YtrainSet = categorical.empty;
YtestSet = categorical.empty;
figure
imshow(finalLabelImg);
hold on
k=1;
j=1;
for i = 1:height(newDataset)
    row = newDataset{i, 13};
    col = newDataset{i, 14};
    
        if test_mask(row, col) == 0
            plot(col, row, 'g.', 'MarkerSize', 6, 'LineWidth', 1);
            XtrainSet(k, :) = newDataset(i, :);
            YtrainSet(k, :) = newLabels(i);
            k=k+1;
        else
            plot(col, row, 'r.', 'MarkerSize', 6, 'LineWidth', 1);
            XtestSet(j, :) = newDataset(i, :);
            YtestSet(j, :) = newLabels(i);
            j=j+1;
        end
        
    
end
impixelinfo
hold off
%% Normalizzazione del dataset
XtrainSetMean = mean(XtrainSet{:,1:12});
XtrainSetStd = std(XtrainSet{:,1:12});

% Normalizzazione Z-score per il set di addestramento
XtrainSet{:,1:12} = (XtrainSet{:,1:12} - XtrainSetMean) ./ XtrainSetStd;

% Applica la stessa normalizzazione al set di test
XtestSet{:,1:12} = (XtestSet{:,1:12} - XtrainSetMean) ./ XtrainSetStd;
%% Correlazione
trainSetWithLab = XtrainSet{:,1:12};
trainSetWithLab = array2table(trainSetWithLab,'VariableNames',{'ndvi','evi2','cire','gndvi','grvi','psri','ren','savi', 'green','red','rededge','nir'});
trainSetWithLab.labels = YtrainSet == "Ulivo"; %trasforma le lebal da categorical a logical

coeff = corrcoef(trainSetWithLab{:,:});
isupper = logical(triu(ones(size(coeff)),1));
coeff(isupper) = NaN;
% Plot results
h = heatmap(coeff,'MissingDataColor','w','Colormap',jet);
labelNames = {'ndvi','evi2','cire','gndvi','grvi','psri','ren','savi', 'green','red','rededge','nir','class'};
h.XDisplayLabels = labelNames;
h.YDisplayLabels = labelNames; 

corrFeat = zeros(1,size(trainSetWithLab,2));
for i=2:size(trainSetWithLab,2)
    for j=1:i-1
        if abs(coeff(i,j))> 0.85
            corrFeat(i) = 1;
        end
    end

end

corrFeat = logical(corrFeat);
XtrainSetNew = removevars(XtrainSet,labelNames(corrFeat));
XtrainSetNew = removevars(XtrainSetNew, {'row','col','treenum'});
XtestSetNew = removevars(XtestSet,labelNames(corrFeat));
XtestSetNew = removevars(XtestSetNew, {'row','col','treenum'});

%% Training KNN
mdl = fitcknn(XtrainSetNew,YtrainSet,'NumNeighbors',5,'Standardize',1);
cvmdl = crossval(mdl); %10-fold
%% Testing KNN
[Ypredicted,score,cost] = predict(cvmdl.Trained{2},XtestSetNew);

C = confusionmat(YtestSet,Ypredicted);
figure
cm = confusionchart(C,{'Ulivo','Albero'});

%%
AUC = zeros(10);
figure
hold on
for i=1:10
    [~,score] = predict(cvmdl.Trained{i},XtestSetNew);
    [X,Y,T,AUC(i)] = perfcurve(YtestSet,score(:,1),'Ulivo');
    plot(X,Y)
    
end
legend('Modello 1','Modello 2','Modello 3','Modello 4','Modello 5','Modello 6','Modello 7','Modello 8','Modello 9','Modello 10')
    xlabel('False positive rate'); ylabel('True positive rate');
    title('ROC for Classification by KNN')
hold off


%%
tp = C(1);
fp = C(2);
fn = C(3);
tn = C(4);
accuracy = (tp+tn)/(tp+tn+fp+fn);
precision = tp/(tp+fp);
recall = tp/(tp+fn); %true positive rate
specificity = tn/(fp+tn); %true negative rate
error_rate = 1 - accuracy;
f_measure = 2*precision*recall/(precision+recall);
false_positive_rate = 1 - specificity;

%% visualizzazione grafica risultati test pixel per pixel

figure
imshow(finalLabelImg);
hold on
for i = 1:height(XtestSet)
    if YtestSet(i) == Ypredicted(i)
        if Ypredicted(i) == "Ulivo"
            plot(XtestSet{i,'col'},XtestSet{i,'row'}, 'g.');
        else
            plot(XtestSet{i,'col'},XtestSet{i,'row'}, 'b.');
        end
    else
        plot(XtestSet{i,'col'},XtestSet{i,'row'}, 'r.');
    end
       
end

hold off
%% elimina outlier da pixelalberi
outIdxNew = find(outIdx);
for i=1:size(pixelAlberi,1)
    difference = setdiff(pixelAlberi{i},outIdxNew); 
    pixelAlberi{i} = difference;
end
%%
alberiTest = pixelAlberi(unique(XtestSet.treenum));
alberiTest{:,2} = 0;

for tree=1:size(alberiTest,1)
    st = size(alberiTest{tree},1);
    alberiTest{tree,2} = 0;
        for pixel=1:st
           [row, col] = ind2sub(size(rawLabels),alberiTest{tree}(pixel));
           if Ypredicted(XtestSet.col == col & XtestSet.row == row) == "Ulivo"
               alberiTest{tree,2} = alberiTest{tree,2} +1;
           else
               alberiTest{tree,2} = alberiTest{tree,2} - 1;
           end
        end
end


%% visualizzazione grafica risultati test per albero

figure
imshow(finalLabelImg);
hold on
for i = 1:height(XtestSet)
    if YtestSet(i) == Ypredicted(i)
        if Ypredicted(i) == "Ulivo"
            plot(XtestSet{i,'col'},XtestSet{i,'row'}, 'g.');
        else
            plot(XtestSet{i,'col'},XtestSet{i,'row'}, 'b.');
        end
    else
        plot(XtestSet{i,'col'},XtestSet{i,'row'}, 'r.');
    end
       
end

hold off

