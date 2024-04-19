function terrainMask = applyTerrainMask(img, mask, imgTitle)
%APPLYTERRAINMASK i pixel marroni sono pixel che sporcano l'addestramento
%del modello. Sono considerati come degli outlier e vanno quindi rimossi

img(repmat(mask, [1 1 3])) = 255;
hsvImg = rgb2hsv(img);
% tonalità
hue = hsvImg(:,:,1);
% per visualizzare al meglio l'istogramma delle tonalità
% i pixel di valore 0 (nero) non vengono visualizzati

X = hue(hue ~= 0);
% figure
% imhist(X)

% Soglie impostata vedendo l'istogramma
terrainMask =  hsvImg(:,:,1) <= 0.18 | hsvImg(:,:,1) >= 0.45;
newRgbImgNoOut = img;
newRgbImgNoOut(repmat(terrainMask, [1 1 3])) = 255;


figure
subplot(1,3,1)
imshow(img)
title(strcat(imgTitle,' with terrain'))
subplot(1,3,2)
imshow(newRgbImgNoOut)
title(strcat(imgTitle,' without terrain'))
subplot(1,3,3)
imshowpair(img,newRgbImgNoOut)
title(strcat(imgTitle,' differences'))
end

