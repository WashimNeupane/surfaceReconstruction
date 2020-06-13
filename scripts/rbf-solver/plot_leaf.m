function plot_leaf(leaf,z,leaf_transformed)

x = [min(leaf(:,1)),max(leaf(:,1))];
y = [min(leaf(:,2)),max(leaf(:,2))];
[X,Y] = meshgrid(x,y);
Z = z(X,Y);

figure
subplot(1,2,1)
plot3(leaf(:,1),leaf(:,2),leaf(:,3),'.')
hold on
surf(X,Y,Z)
title('Point cloud data and its plane of best fits')
axis equal

subplot(1,2,2)
plot3(leaf_transformed(:,1),leaf_transformed(:,2),leaf_transformed(:,3),'.')
title('Transformed point cloud data')
axis equal
end