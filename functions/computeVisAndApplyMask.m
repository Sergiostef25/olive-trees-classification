function [ndviImg,evi2Img,cireImg,gndviImg,grviImg,psriImg,renImg,saviImg,ipviImg,rdviImg,gosaviImg] = computeVisAndApplyMask(crop, mask)
%COMPUTEVISANDAPPLYMASK Calcolo degli indici di vegetazione e applicazione
%delle maschera. Gli indici verranno restituiti sull'immagine segmentata

ndviImg = computeVIs(crop, 'ndvi');
evi2Img = computeVIs(crop , 'evi2');
cireImg = computeVIs(crop, 'cire');
gndviImg = computeVIs(crop, 'gndvi');
grviImg = computeVIs(crop, 'grvi');
psriImg = computeVIs(crop, 'psri');
renImg = computeVIs(crop, 'ren');
saviImg = computeVIs(crop, 'savi');
ipviImg = computeVIs(crop, 'ipvi');
rdviImg = computeVIs(crop, 'rdvi');
gosaviImg = computeVIs(crop, 'gosavi');

ndviImg(mask)=0;
evi2Img(mask)=0;
cireImg(mask)=0;
gndviImg(mask)=0;
grviImg(mask)=0;
psriImg(mask)=0;
renImg(mask)=0;
saviImg(mask)=0;
ipviImg(mask)=0;
rdviImg(mask)=0;
gosaviImg(mask)=0;

end

