function [labels] = DBCluster(X,epsilon,minpts) 
labels = dbscan(X,epsilon,minpts);
labels = labels + 2;
clr = lines(max(labels));
figure
scatter3(X(:,1),X(:,2),X(:,3),labels,clr(labels,:),'Marker','.');
title(sprintf('epsilon = %d and minpts = %d',epsilon, minpts))
grid
end