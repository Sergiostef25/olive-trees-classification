function displayLabeledOliveTree(img1,img2,label1, label2)
%DISPLAYLABELEDOLIVETREE Mostre le due immagini satellitare con gli ulivi
%labellizati

[row1, col1] = find(label1 == 1);
[row2, col2] = find(label1 == 2);
[row3, col3] = find(label1 == 3);
[row4, col4] = find(label1 == 4);
[row5, col5] = find(label1 == 5);
figure
subplot(1,2,1)
imshow(img1)
hold on
% c1 = plot(col1, row1, '.', 'MarkerSize', 7,'Color', '#D95319','DisplayName','Altro');
c1 = plot(col1, row1, '.', 'MarkerSize', 7,'Color', '#008000','DisplayName','Leccino');
c2 = plot(col2, row2, '.', 'MarkerSize', 7,'Color', '#0000FF','DisplayName','Ogliarola barese');
c3 = plot(col3, row3, '.', 'MarkerSize', 7, 'Color', '#800080','DisplayName','Oliastro');
c4 = plot(col4, row4, '.', 'MarkerSize', 7,'Color', '#EDB120','DisplayName','Coratina');
c5 = plot(col5, row5, '.', 'MarkerSize', 7,'Color', '#A2142F','DisplayName','Ogliarola salentina');



title("Polignano")
hold off
legend([c1,c2,c3,c4,c5],Location='northoutside')
clear c1 c2 c3 c4 c5

[row1, col1] = find(label2 == 1);
[row2, col2] = find(label2 == 2);
[row3, col3] = find(label2 == 3);
[row4, col4] = find(label2 == 4);
[row5, col5] = find(label2 == 5);
subplot(1,2,2)
imshow(img2)
hold on
c1 = plot(col1, row1, '.', 'MarkerSize', 7,'Color', '#008000','DisplayName','Leccino');
c2 = plot(col2, row2, '.', 'MarkerSize', 7,'Color', '#0000FF','DisplayName','Ogliarola barese');
c3 = plot(col3, row3, '.', 'MarkerSize', 7, 'Color', '#800080','DisplayName','Oliastro');
c4 = plot(col4, row4, '.', 'MarkerSize', 7,'Color', '#EDB120','DisplayName','Coratina');
c5 = plot(col5, row5, '.', 'MarkerSize', 7,'Color', '#A2142F','DisplayName','Ogliarola salentina');

title("Monopoli")
hold off
legend([c1,c2,c3,c4,c5],Location='northoutside')
clear c1 c2 c3 c4 c5 col1 col2 col3 col4 col5 
clear row1 row2 row3 row4 row5
end

