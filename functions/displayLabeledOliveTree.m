function displayLabeledOliveTree(img1,img2,label1, label2, cultNameAndCount)
%DISPLAYLABELEDOLIVETREE Mostre le due immagini satellitare con gli ulivi
%labellizati

[row1, col1] = find(label1 == 1);
[row2, col2] = find(label1 == 2);
[row3, col3] = find(label1 == 3);
[row4, col4] = find(label1 == 4);

figure
subplot(1,2,1)
imshow(img1)
hold on
c1 = plot(col1, row1, '.', 'MarkerSize', 7,'DisplayName',strcat(num2str(cultNameAndCount{1,1}),'{ }',num2str(cultNameAndCount{1,3})));
c2 = plot(col2, row2, '.', 'MarkerSize', 7,'DisplayName',strcat(num2str(cultNameAndCount{2,1}),'{ }',num2str(cultNameAndCount{2,3})));
c3 = plot(col3, row3, '.', 'MarkerSize', 7,'DisplayName',strcat(num2str(cultNameAndCount{3,1}),'{ }',num2str(cultNameAndCount{3,3})));
c4 = plot(col4, row4, '.', 'MarkerSize', 7,'DisplayName',strcat(num2str(cultNameAndCount{4,1}),'{ }',num2str(cultNameAndCount{4,3})));



title("Polignano")
hold off
legend([c1,c2,c3,c4],Location='northoutside')
% clear c1 c2 c3

[row1, col1] = find(label2 == 1);
[row2, col2] = find(label2 == 2);
[row3, col3] = find(label2 == 3);
[row4, col4] = find(label2 == 4);
subplot(1,2,2)
imshow(img2)
hold on
c1 = plot(col1, row1, '.', 'MarkerSize', 7,'DisplayName',strcat(num2str(cultNameAndCount{1,1}),'{ }',num2str(cultNameAndCount{1,4})));
c2 = plot(col2, row2, '.', 'MarkerSize', 7,'DisplayName',strcat(num2str(cultNameAndCount{2,1}),'{ }',num2str(cultNameAndCount{2,4})));
c3 = plot(col3, row3, '.', 'MarkerSize', 7,'DisplayName',strcat(num2str(cultNameAndCount{3,1}),'{ }',num2str(cultNameAndCount{3,4})));
c4 = plot(col4, row4, '.', 'MarkerSize', 7,'DisplayName',strcat(num2str(cultNameAndCount{4,1}),'{ }',num2str(cultNameAndCount{4,4})));

title("Monopoli")
hold off
legend([c1,c2,c3,c4],Location='northoutside')
% clear c1 c2 c3 col1 col2 col3 col4
% clear row1 row2 row3 row4
end

