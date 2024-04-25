function [newA, mask, treeLabel, cultLabel, treeNum] = refineSegmentation(A,cultTable,x,y,radius, treeNum)
%REFINESEGMENTATION Migliora la segmnetazioni dell'immagini, creando dei
%cerchi intorno ai centroidi degli alberi e ridefinendo il contorno per
%seguire esattamente la chioma degli ulivi
arguments
    A (:,:,3) uint8
    cultTable table
    x (:,1) double
    y (:,1) double
    radius int8
    treeNum int16
end

grayA = im2gray(A);
[m, n, ~] = size(A);

[I, J] = ndgrid(1:m, 1:n);

mask = false(m, n);
% label di conteggio albero
treeLabel = zeros(m,n);
% label del tipo di coltura
cultLabel = zeros(m,n);


for i = 1:length(x)
    % distance euclidea
    distance = sqrt((I - y(i)).^2 + (J - x(i)).^2);
    cultLabel(distance <= radius) = cultTable{i,"cult"};
    treeLabel(distance <= radius) = treeNum;
    treeNum = treeNum + 1;
    mask = mask | (distance <= radius);
end

mask = ~mask;

% qui con l'ausilio dell'mmagine in scala di grigi
% trasformiamo i 'cerchi' che individuano gli alberi
% dello step precedente, nella forma delle loro chiome

for i=1:m
    for j=1:n
        if grayA(i,j) == 0
            mask(i,j) = 1;
            cultLabel(i,j)=0;
            treeLabel(i,j)=0;
        end
    end
end

newA = A;
newA(repmat(mask, [1 1 3])) = 255;
end

