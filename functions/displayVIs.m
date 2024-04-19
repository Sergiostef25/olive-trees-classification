function displayVIs(ndviImg,evi2Img,cireImg,gndviImg,grviImg,psriImg,renImg,saviImg)
%DISPLAYVIS Summary of this function goes here
%   Detailed explanation goes here
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
end

