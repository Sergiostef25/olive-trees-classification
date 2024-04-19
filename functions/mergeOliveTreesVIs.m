function [ndviImg,evi2Img,cireImg,gndviImg,grviImg,psriImg,renImg,saviImg] = mergeOliveTreesVIs(m2,m1,n1,ndviImg1,evi2Img1,cireImg1, ...
    gndviImg1,grviImg1,psriImg1,renImg1,saviImg1, ...
    ndviImg2,evi2Img2,cireImg2,gndviImg2,grviImg2,psriImg2,renImg2,saviImg2)
%MERGEOLIVETREESVIS Summary of this function goes here
%   Detailed explanation goes here

ndviImg = cat(2, [ndviImg1; zeros(m2-m1,n1)], ndviImg2);
evi2Img = cat(2, [evi2Img1; zeros(m2-m1,n1)], evi2Img2);
cireImg = cat(2, [cireImg1; zeros(m2-m1,n1)], cireImg2);
gndviImg = cat(2, [gndviImg1; zeros(m2-m1,n1)], gndviImg2);
grviImg = cat(2, [grviImg1; zeros(m2-m1,n1)], grviImg2);
psriImg = cat(2, [psriImg1; zeros(m2-m1,n1)], psriImg2);
renImg = cat(2, [renImg1; zeros(m2-m1,n1)], renImg2);
saviImg = cat(2, [saviImg1; zeros(m2-m1,n1)], saviImg2);

end

