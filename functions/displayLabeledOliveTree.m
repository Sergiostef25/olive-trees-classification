function displayLabeledOliveTree(img1,img2,label1, label2)
%DISPLAYLABELEDOLIVETREE Summary of this function goes here
%   Detailed explanation goes here
[row1, col1] = find(label1 == 1);
[row2, col2] = find(label1 == 2);
[row3, col3] = find(label1 == 3);
[row4, col4] = find(label1 == 4);
[row5, col5] = find(label1 == 5);
[row6, col6] = find(label1 == 6);
figure
subplot(1,2,1)
imshow(img1)
hold on
c1 = plot(col1, row1, '.', 'MarkerSize', 7,'Color', '#D95319','DisplayName','Altro');
c2 = plot(col2, row2, '.', 'MarkerSize', 7,'Color', '#008000','DisplayName','Leccino');
c3 = plot(col3, row3, '.', 'MarkerSize', 7,'Color', '#0072BD','DisplayName','Nociara');
c4 = plot(col4, row4, '.', 'MarkerSize', 7,'Color', '#0000FF','DisplayName','Ogliarola barese');
c5 = plot(col5, row5, '.', 'MarkerSize', 7, 'Color', '#800080','DisplayName','Oliastro');
c6 = plot(col6, row6, '.', 'MarkerSize', 7,'Color', '#EDB120','DisplayName','Coratina');
title("Polignano")
hold off
legend([c1,c2,c3,c4,c5,c6])
clear c1 c2 c3 c4 c5 c6

[row1, col1] = find(label2 == 1);
[row2, col2] = find(label2 == 2);
[row3, col3] = find(label2 == 3);
[row4, col4] = find(label2 == 4);
[row5, col5] = find(label2 == 5);
[row6, col6] = find(label2 == 6);
subplot(1,2,2)
imshow(img2)
hold on
c1 = plot(col1, row1, '.', 'MarkerSize', 7,'Color', '#D95319','DisplayName','Altro');
c2 = plot(col2, row2, '.', 'MarkerSize', 7,'Color', '#008000','DisplayName','Leccino');
c3 = plot(col3, row3, '.', 'MarkerSize', 7,'Color', '#0072BD','DisplayName','Nociara');
c4 = plot(col4, row4, '.', 'MarkerSize', 7,'Color', '#0000FF','DisplayName','Ogliarola barese');
c5 = plot(col5, row5, '.', 'MarkerSize', 7, 'Color', '#800080','DisplayName','Oliastro');
c6 = plot(col6, row6, '.', 'MarkerSize', 7,'Color', '#EDB120','DisplayName','Coratina');
title("Monopoli")
hold off
legend([c1,c2,c3,c4,c5,c6])
clear c1 c2 c3 c4 c5 c6 col1 col2 col3 col4 col5 col6
clear row1 row2 row3 row4 row5 row6
end

