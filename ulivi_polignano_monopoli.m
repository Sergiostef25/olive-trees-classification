%% Letttura coordinate
t1 = readtable('ulivi_in_CROP1_RGB.xlsx');
t1.Ris = [];
t1.Cult=categorical(t1.Cult);
color = cell(height(t1),1);


for i=1:height(t1)
    switch char(t1{i,"Cult"})
        case 'Ogliarola barese'
            color{i} = '#0000FF';
        case 'Leccino'
            color{i} = '#008000';
        case 'Oliastro'
            color{i} = '#800080';
        case 'Nociara'
            color{i} = '#0072BD';
        case 'Coratina'
            color{i} = '#EDB120';
        case 'Cornale'
            color{i} = '#7E2F8E';
        case 'Frantoio'
            color{i} = '#77AC30';
        case 'Mele'
            color{i} = '#4DBEEE';
        case 'Ogliarola salentina'
            color{i} = '#A2142F';
        case 'Oliva rossa'
            color{i} = '#FF0000';
        case 'Altro'
            color{i} = '#D95319';
    end
end

t1 = table(t1.expolat, t1.expolon, t1.Cult, categorical(color),zeros(height(t1),1));
t1.Properties.VariableNames = ["expolat","expolon","cult","color","location"];

t2 = readtable('ulivi_in_CROP2_RGB.xlsx');
t2.Ris = [];
t2.Cult = categorical(t2.Cult);
missingCultIndex = find(ismissing(t2.Cult));
t2(missingCultIndex,:)=[];
color2 = cell(height(t2),1);


for i=1:height(t2)
    switch char(t2{i,"Cult"})
        case 'Ogliarola barese'
            color2{i} = '#0000FF';
        case 'Leccino'
            color2{i} = '#008000';
        case 'Oliastro'
            color2{i} = '#800080';
        case 'Nociara'
            color2{i} = '#0072BD';
        case 'Coratina'
            color2{i} = '#EDB120';
        case 'Cornale'
            color2{i} = '#7E2F8E';
        case 'Frantoio'
            color2{i} = '#77AC30';
        case 'Mele'
            color2{i} = '#4DBEEE';
        case 'Ogliarola salentina'
            color2{i} = '#A2142F';
        case 'Oliva rossa'
            color2{i} = '#FF0000';
        case 'Altro'
            color2{i} = '#D95319';
    end
end

t2 = table(t2.expolat, t2.expolon, t2.Cult, categorical(color2),ones(height(t2),1));
t2.Properties.VariableNames = ["expolat","expolon","cult","color","location"];

newT = [t1;t2];
[cultEncoded, cultName, cultLevel] = grp2idx(newT.cult);
newT.cult = cultEncoded;
%%
% disp(['T1: Ogliarola barese ', num2str(length(find(t1.cult == 'Ogliarola barese')))])
% disp(['T1: Leccino ', num2str(length(find(t1.cult == 'Leccino')))])
% disp(['T1: Oliastro ', num2str(length(find(t1.cult == 'Oliastro')))])
% disp(['T1: Nociara ', num2str(length(find(t1.cult == 'Nociara')))])
% disp(['T1: Coratina ', num2str(length(find(t1.cult == 'Coratina')))])
% disp(['T1: Cornale ', num2str(length(find(t1.cult == 'Cornale')))])
% disp(['T1: Frantoio ', num2str(length(find(t1.cult == 'Frantoio')))])
% disp(['T1: Mele ', num2str(length(find(t1.cult == 'Mele')))])
% disp(['T1: Ogliarola salentina ', num2str(length(find(t1.cult == 'Ogliarola salentina')))])
% disp(['T1: Oliva rossa ', num2str(length(find(t1.cult == 'Oliva rossa')))])
% disp(['T1: Altro ', num2str(length(find(t1.cult == 'Altro')))])
% 
% disp(['T2: Ogliarola barese ', num2str(length(find(t2.cult == 'Ogliarola barese')))])
% disp(['T2: Leccino ', num2str(length(find(t2.cult == 'Leccino')))])
% disp(['T2: Oliastro ', num2str(length(find(t2.cult == 'Oliastro')))])
% disp(['T2: Nociara ', num2str(length(find(t2.cult == 'Nociara')))])
% disp(['T2: Coratina ', num2str(length(find(t2.cult == 'Coratina')))])
% disp(['T2: Cornale ', num2str(length(find(t2.cult == 'Cornale')))])
% disp(['T2: Frantoio ', num2str(length(find(t2.cult == 'Frantoio')))])
% disp(['T2: Mele ', num2str(length(find(t2.cult == 'Mele')))])
% disp(['T2: Ogliarola salentina ', num2str(length(find(t2.cult == 'Ogliarola salentina')))])
% disp(['T2: Oliva rossa ', num2str(length(find(t2.cult == 'Oliva rossa')))])
% disp(['T2: Altro ', num2str(length(find(t2.cult == 'Altro')))])
%
%% Hypercubes
waves=[386,400.3,405.1,409.9,414.6,419.4,424.1,430.1,436,440.8,445.6,450.3,455.1,482.4,509.7,514.5,519.2,525.2,531.1,535.8,543,550.1,559.6,569.1,620,671,675.7,680.5,685.2,690,694.7,699.4,705.4,711.3,716,720.8,725.5,730.2,735,739.7,744.5,749.2,755.1,761,781.2,801.3,930.5]';

crop1=hypercube('CROP1_47.tif',waves);
[rgbImg1, bands1] = colorize(crop1,'Method','rgb','ContrastStretching',true);
figure
subplot(1,2,1)
imagesc(rgbImg1)
title('Polignano')

crop2=hypercube('CROP2_47.tif',waves);
[rgbImg2, bands2] = colorize(crop2,'Method','rgb','ContrastStretching',true);
subplot(1,2,2)
imagesc(rgbImg2)
title('Monopoli')

seg_crop1 = ~logical(imread("Seg_CROP1.tif"));
seg_crop2 = ~logical(imread("Seg_CROP2.tif"));

%% Georaster
[A1,R1] = readgeoraster('CROP1_47.tif','Bands',bands1);
[m1, n1, ~] = size(A1);
proj1 = R1.ProjectedCRS;
[x1,y1] = projfwd(proj1,t1.expolat,t1.expolon);
A1=uint8(A1*500);
A1(repmat(seg_crop1, [1 1 3])) = 0;


    
figure
subplot(1,2,1)
mapshow(A1,R1)
hold on
for i=1:length(x1)
    switch char(t1{i,"cult"})
        case 'Ogliarola barese'
            c1 = mapshow(x1(i),y1(i),DisplayType="point",Marker="o",MarkerFaceColor=char(t1{i,"color"}),MarkerEdgeColor="none",DisplayName=char(t1{i,"cult"}));
        case 'Leccino'
            c2 = mapshow(x1(i),y1(i),DisplayType="point",Marker="o",MarkerFaceColor=char(t1{i,"color"}),MarkerEdgeColor="none",DisplayName=char(t1{i,"cult"}));
        case 'Oliastro'
            c3 = mapshow(x1(i),y1(i),DisplayType="point",Marker="o",MarkerFaceColor=char(t1{i,"color"}),MarkerEdgeColor="none",DisplayName=char(t1{i,"cult"}));
        case 'Nociara'
            c4 = mapshow(x1(i),y1(i),DisplayType="point",Marker="o",MarkerFaceColor=char(t1{i,"color"}),MarkerEdgeColor="none",DisplayName=char(t1{i,"cult"}));
        case 'Coratina'
            c5 = mapshow(x1(i),y1(i),DisplayType="point",Marker="o",MarkerFaceColor=char(t1{i,"color"}),MarkerEdgeColor="none",DisplayName=char(t1{i,"cult"}));
        case 'Cornale'
            c6 = mapshow(x1(i),y1(i),DisplayType="point",Marker="o",MarkerFaceColor=char(t1{i,"color"}),MarkerEdgeColor="none",DisplayName=char(t1{i,"cult"}));
        case 'Frantoio'
            c7 = mapshow(x1(i),y1(i),DisplayType="point",Marker="o",MarkerFaceColor=char(t1{i,"color"}),MarkerEdgeColor="none",DisplayName=char(t1{i,"cult"}));
        case 'Mele'
            c8 = mapshow(x1(i),y1(i),DisplayType="point",Marker="o",MarkerFaceColor=char(t1{i,"color"}),MarkerEdgeColor="none",DisplayName=char(t1{i,"cult"}));
        case 'Ogliarola salentina'
            c9 = mapshow(x1(i),y1(i),DisplayType="point",Marker="o",MarkerFaceColor=char(t1{i,"color"}),MarkerEdgeColor="none",DisplayName=char(t1{i,"cult"}));
        case 'Oliva rossa'
            c10 = mapshow(x1(i),y1(i),DisplayType="point",Marker="o",MarkerFaceColor=char(t1{i,"color"}),MarkerEdgeColor="none",DisplayName=char(t1{i,"cult"}));
        case 'Altro'
            c11 = mapshow(x1(i),y1(i),DisplayType="point",Marker="o",MarkerFaceColor=char(t1{i,"color"}),MarkerEdgeColor="none",DisplayName=char(t1{i,"cult"}));
    end
end
title("Polignano")
hold off
[A2,R2] = readgeoraster('CROP2_47.tif','Bands',bands2);
[m2, n2, ~] = size(A2);
proj2 = R2.ProjectedCRS;
[x2,y2] = projfwd(proj2,t2.expolat,t2.expolon);
A2=uint8(A2*500);
A2(repmat(seg_crop2, [1 1 3])) = 0;
subplot(1,2,2)
mapshow(A2,R2)
hold on
for i=1:length(x2)
    switch char(t2{i,"cult"})
        case 'Ogliarola barese'
            c1 = mapshow(x2(i),y2(i),DisplayType="point",Marker="o",MarkerFaceColor=char(t2{i,"color"}),MarkerEdgeColor="none",DisplayName=char(t2{i,"cult"}));
        case 'Leccino'
            c2 = mapshow(x2(i),y2(i),DisplayType="point",Marker="o",MarkerFaceColor=char(t2{i,"color"}),MarkerEdgeColor="none",DisplayName=char(t2{i,"cult"}));
        case 'Oliastro'
            c3 = mapshow(x2(i),y2(i),DisplayType="point",Marker="o",MarkerFaceColor=char(t2{i,"color"}),MarkerEdgeColor="none",DisplayName=char(t2{i,"cult"}));
        case 'Nociara'
            c4 = mapshow(x2(i),y2(i),DisplayType="point",Marker="o",MarkerFaceColor=char(t2{i,"color"}),MarkerEdgeColor="none",DisplayName=char(t2{i,"cult"}));
        case 'Coratina'
            c5 = mapshow(x2(i),y2(i),DisplayType="point",Marker="o",MarkerFaceColor=char(t2{i,"color"}),MarkerEdgeColor="none",DisplayName=char(t2{i,"cult"}));
        case 'Cornale'
            c6 = mapshow(x2(i),y2(i),DisplayType="point",Marker="o",MarkerFaceColor=char(t2{i,"color"}),MarkerEdgeColor="none",DisplayName=char(t2{i,"cult"}));
        case 'Frantoio'
            c7 = mapshow(x2(i),y2(i),DisplayType="point",Marker="o",MarkerFaceColor=char(t2{i,"color"}),MarkerEdgeColor="none",DisplayName=char(t2{i,"cult"}));
        case 'Mele'
            c8 = mapshow(x2(i),y2(i),DisplayType="point",Marker="o",MarkerFaceColor=char(t2{i,"color"}),MarkerEdgeColor="none",DisplayName=char(t2{i,"cult"}));
        case 'Ogliarola salentina'
            c9 = mapshow(x2(i),y2(i),DisplayType="point",Marker="o",MarkerFaceColor=char(t2{i,"color"}),MarkerEdgeColor="none",DisplayName=char(t2{i,"cult"}));
        case 'Oliva rossa'
            c10 = mapshow(x2(i),y2(i),DisplayType="point",Marker="o",MarkerFaceColor=char(t2{i,"color"}),MarkerEdgeColor="none",DisplayName=char(t2{i,"cult"}));
        case 'Altro'
            c11 = mapshow(x2(i),y2(i),DisplayType="point",Marker="o",MarkerFaceColor=char(t2{i,"color"}),MarkerEdgeColor="none",DisplayName=char(t2{i,"cult"}));
    end
    
end
title("Monopoli")
hold off
legend([c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11])
clear c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11
%% Da cartesiane a pixel

[newX1, newY1] = worldToIntrinsic(R1,x1,y1);
newX1 = round(newX1);
newY1 = round(newY1);
[newX2, newY2] = worldToIntrinsic(R2,x2,y2);
newX2 = round(newX2);
newY2 = round(newY2);

grayA1 = im2gray(A1);
raggio = 10;


[I, J] = ndgrid(1:m1, 1:n1);

mask1 = false(m1, n1);
% label di conteggio albero
treeLabel1 = zeros(m1,n1);
% label del tipo di coltura
cultLabel1 = zeros(m1,n1);

treeNum = 1;

for i = 1:length(newX1)
    % distanza euclidea
    distanza = sqrt((I - newY1(i)).^2 + (J - newX1(i)).^2);
    cultLabel1(distanza <= raggio) = newT{i,"cult"};
    treeLabel1(distanza <= raggio) = treeNum;
    treeNum = treeNum + 1;
    mask1 = mask1 | (distanza <= raggio);
end

mask1 = ~mask1;

for i=1:m1
    for j=1:n1
        if grayA1(i,j) == 0
            mask1(i,j) = 1; % segna la presenza di un albero
            cultLabel1(i,j)=0; % senza questo cult e tre sarebbere ancora dei cerchi e non seguirebbero il contorno degli alberi
            treeLabel1(i,j)=0;
        end
    end
end
newA1 = A1;
newA1(repmat(mask1, [1 1 3])) = 255;

grayA2 = im2gray(A2);
raggio = 10;

[I, J] = ndgrid(1:m2, 1:n2);

mask2 = false(m2, n2);
treeLabel2 = zeros(m2,n2);
cultLabel2 = zeros(m2,n2);

for i = 1:length(newX2)
    % distanza euclidea
    distanza = sqrt((I - newY2(i)).^2 + (J - newX2(i)).^2);
    cultLabel2(distanza <= raggio) = newT{i+height(t1),"cult"};
    treeLabel2(distanza <= raggio) = treeNum;
    treeNum = treeNum + 1;
    mask2 = mask2 | (distanza <= raggio);
end

mask2 = ~mask2;

for i=1:m2
    for j=1:n2
        if grayA2(i,j) == 0
            mask2(i,j) = 1;
            cultLabel2(i,j)=0;
            treeLabel2(i,j)=0;
        end
    end
end
newA2 = A2;
newA2(repmat(mask2, [1 1 3])) = 255;

figure
subplot(1,2,1)
imshow(newA1)
title('Polignano')
subplot(1,2,2)
imshow(newA2)
title('Monopoli')

%%
[row1, col1] = find(cultLabel1 == 1);
[row2, col2] = find(cultLabel1 == 2);
[row3, col3] = find(cultLabel1 == 3);
[row4, col4] = find(cultLabel1 == 4);
[row5, col5] = find(cultLabel1 == 5);
[row6, col6] = find(cultLabel1 == 6);
[row7, col7] = find(cultLabel1 == 7);
[row8, col8] = find(cultLabel1 == 8);
[row9, col9] = find(cultLabel1 == 9);
[row10, col10] = find(cultLabel1 == 10);
[row11, col11] = find(cultLabel1 == 11);
figure
imshow(rgbImg1)
hold on
c1 = plot(col1, row1, '.', 'MarkerSize', 7,'Color', '#D95319','DisplayName','Altro');
c2 = plot(col2, row2, '.', 'MarkerSize', 7,'Color', '#008000','DisplayName','Leccino');
c3 = plot(col3, row3, '.', 'MarkerSize', 7,'Color', '#0072BD','DisplayName','Nociara');
c4 = plot(col4, row4, '.', 'MarkerSize', 7,'Color', '#0000FF','DisplayName','Ogliarola barese');
c5 = plot(col5, row5, '.', 'MarkerSize', 7, 'Color', '#800080','DisplayName','Oliastro');
c6 = plot(col6, row6, '.', 'MarkerSize', 7,'Color', '#EDB120','DisplayName','Coratina');
c7 = plot(col7, row7, '.', 'MarkerSize', 7,'Color', '#7E2F8E','DisplayName','Cornale');
c8 = plot(col8, row8, '.', 'MarkerSize', 7,'Color', '#77AC30','DisplayName','Frantoio');
c9 = plot(col9, row9, '.', 'MarkerSize', 7,'Color', '#4DBEEE','DisplayName','Mele');
c10 = plot(col10, row10, '.', 'MarkerSize', 7,'Color', '#A2142F','DisplayName','Ogliarola salentina');
c11 = plot(col11, row11, '.', 'MarkerSize', 7,'Color', '#FF0000','DisplayName','Oliva rossa');
title("Polignano")
hold off
legend([c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11])
clear c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11

[row1, col1] = find(cultLabel2 == 1);
[row2, col2] = find(cultLabel2 == 2);
[row3, col3] = find(cultLabel2 == 3);
[row4, col4] = find(cultLabel2 == 4);
[row5, col5] = find(cultLabel2 == 5);
[row6, col6] = find(cultLabel2 == 6);
[row7, col7] = find(cultLabel2 == 7);
[row8, col8] = find(cultLabel2 == 8);
[row9, col9] = find(cultLabel2 == 9);
[row10, col10] = find(cultLabel2 == 10);
[row11, col11] = find(cultLabel2 == 11);
figure
imshow(rgbImg2)
hold on
c1 = plot(col1, row1, '.', 'MarkerSize', 7,'Color', '#D95319','DisplayName','Altro');
c2 = plot(col2, row2, '.', 'MarkerSize', 7,'Color', '#008000','DisplayName','Leccino');
c3 = plot(col3, row3, '.', 'MarkerSize', 7,'Color', '#0072BD','DisplayName','Nociara');
c4 = plot(col4, row4, '.', 'MarkerSize', 7,'Color', '#0000FF','DisplayName','Ogliarola barese');
c5 = plot(col5, row5, '.', 'MarkerSize', 7, 'Color', '#800080','DisplayName','Oliastro');
c6 = plot(col6, row6, '.', 'MarkerSize', 7,'Color', '#EDB120','DisplayName','Coratina');
c7 = plot(col7, row7, '.', 'MarkerSize', 7,'Color', '#7E2F8E','DisplayName','Cornale');
c8 = plot(col8, row8, '.', 'MarkerSize', 7,'Color', '#77AC30','DisplayName','Frantoio');
c9 = plot(col9, row9, '.', 'MarkerSize', 7,'Color', '#4DBEEE','DisplayName','Mele');
c10 = plot(col10, row10, '.', 'MarkerSize', 7,'Color', '#A2142F','DisplayName','Ogliarola salentina');
c11 = plot(col11, row11, '.', 'MarkerSize', 7,'Color', '#FF0000','DisplayName','Oliva rossa');
title("Monopoli")
hold off
legend([c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11])
clear c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11
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
%% Visualizza VI
figure
subplot(1,2,1);
imagesc(ndviImg1);
title('NDVI Polignano')
subplot(1,2,2);
imagesc(ndviImg2);
colorbar
title('NDVI Monopoli')

figure
subplot(1,2,1);
imagesc(evi2Img1);
title('EVI2 Polignano')
subplot(1,2,2);
imagesc(evi2Img2);
colorbar
title('EVI2 Monopoli')

figure
subplot(1,2,1);
imagesc(cireImg1);
title('CIRE Poligano')
subplot(1,2,2);
imagesc(cireImg2);
colorbar
title('CIRE Monopoli')

figure
subplot(1,2,1);
imagesc(gndviImg1);
title('GNDVI Polignano')
subplot(1,2,2);
imagesc(gndviImg2);
colorbar
title('GNDVI Monopoli')

figure
subplot(1,2,1);
imagesc(grviImg1);
title('GRVI Polignano')
subplot(1,2,2);
imagesc(grviImg2);
colorbar
title('GRVI Monopoli')


figure
subplot(1,2,1);
imagesc(psriImg1, [0, 1]);
title('PSRI Polignano')
subplot(1,2,2);
imagesc(psriImg2, [0, 1]);
colorbar
title('PSRI Monopoli')

figure
subplot(1,2,1);
imagesc(renImg1);
title('REN Polignano')
subplot(1,2,2);
imagesc(renImg2);
colorbar
title('REN Monopoli')

figure
subplot(1,2,1);
imagesc(saviImg1);
title('SAVI Polignano')
subplot(1,2,2);
imagesc(saviImg2);
colorbar
title('SAVI Monopoli')