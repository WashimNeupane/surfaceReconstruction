function [G,C] = kkmeans(X,K)
%# K-means clustering
%# (K: number of clusters, G: assigned groups, C: cluster centers)
[numInst,numDims] = size(X);
[G,C] = kmeans(X, K, 'distance','sqEuclidean', 'start','sample');
%# show points and clusters (color-coded)
clr = lines(K);
figure, hold on

scatter3(X(:,1), X(:,2),X(:,3), 10, clr(G,:), 'Marker','.')
scatter3(C(:,1), C(:,2),C(:,3), 100, clr, 'Marker','*', 'LineWidth',3)
% 
% scatter(X(:,1), X(:,2), 10, clr(G,:), 'Marker','.')
% scatter(C(:,1), C(:,2), 100, clr, 'Marker','*', 'LineWidth',3)
hold off
view(3), axis vis3d, box on, rotate3d on
xlabel('x'), ylabel('y'), zlabel('z')
end

