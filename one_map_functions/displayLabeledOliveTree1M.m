function displayLabeledOliveTree1M(img1,label1)
%DISPLAYLABELEDOLIVETREE1M Mostre le due immagini satellitare con gli ulivi
%labellizati

[row1, col1] = find(label1 == 1);
[row2, col2] = find(label1 == 2);
[row3, col3] = find(label1 == 3);
[row4, col4] = find(label1 == 4);

figure
imshow(img1)
hold on
% c1 = plot(col1, row1, '.', 'MarkerSize', 7,'Color', '#D95319','DisplayName','Altro');
c4 = plot(col1, row1, '.', 'MarkerSize', 7,'Color', '#008000','DisplayName','Altro');
c1 = plot(col2, row2, '.', 'MarkerSize', 7,'Color', '#EDB120','DisplayName','Coratina');
c2 = plot(col3, row3, '.', 'MarkerSize', 7,'Color', '#0000FF','DisplayName','Ogliarola barese');
c3 = plot(col4, row4, '.', 'MarkerSize', 7,'Color', '#A2142F','DisplayName','Ogliarola salentina');
% c3 = plot(col3, row3, '.', 'MarkerSize', 7, 'Color', '#800080','DisplayName','Oliastro');



title("Monopoli")
hold off
legend([c1,c2,c3,c4])
clear c1 c2 c3 row1 row2 row3 row4 col1 col2 col3 col4
end

