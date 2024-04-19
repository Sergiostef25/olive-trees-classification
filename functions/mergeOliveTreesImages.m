function [mergedRgbImg, mergedCultLabel, mergedTreeLabel] = mergeOliveTreesImages(img1,img2,m1,m2,n1, cultLabel1, cultLabel2, treeLabel1, treeLabel2)
%MERGEOLIVETREESIMAGES Summary of this function goes here
%   Detailed explanation goes here

whiteImg = zeros(m2-m1,n1,3);
whiteImg(:) = 255;

mergedRgbImg = cat(2, [img1; whiteImg], img2);
figure
imshow(mergedRgbImg)
title('Polignano and Monopoli merged')

mergedCultLabel = cat(2, [cultLabel1; zeros(m2-m1,n1)], cultLabel2);
mergedTreeLabel = cat(2, [treeLabel1; zeros(m2-m1,n1)], treeLabel2);


end

