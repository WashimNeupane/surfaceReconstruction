 function [] = svm_3d_plot(mdl,X,group)
 %Gather support vectors from ClassificationSVM struct
 sv =  mdl.SupportVectors;
 %set step size for finer sampling
 d =0.05;
 %generate grid for predictions at finer sample rate
 [x, y, z] = meshgrid(min(X(:,1)):d:max(X(:,1)),...
    min(X(:,2)):d:max(X(:,2)), min(X(:,3)):d:max(X(:,3)));
 xGrid = [x(:),y(:),z(:)];
 %get scores, f
 [ ~ , f] = predict(mdl,xGrid);
 %reshape to same grid size as the input
 f = reshape(f(:,2), size(x));
 % Assume class labels are 1 and 0 and convert to logical
 t = logical(group);
 %plot data points, color by class label
 figure
 plot3(X(t, 1), X(t, 2), X(t, 3), 'b.');
 hold on
 plot3(X(~t, 1), X(~t, 2), X(~t, 3), 'r.');
 hold on
 % load unscaled support vectors for plotting
 plot3(sv(:, 1), sv(:, 2), sv(:, 3), 'go');
 %plot decision surface
 [faces,verts,~] = isosurface(x, y, z, f, 0, x);
 patch('Vertices', verts, 'Faces', faces, 'FaceColor','k','edgecolor', 
 'none', 'FaceAlpha', 0.2);
 grid on
 box on
 view(3)
 hold off
 end