function [stems_coord,cent] = best_plane_leaves(leaves)
% close all
% clear all
% clc
 
tic
%% Initialise veriables
n = length(leaves); % Number of leaves in the data set.
plane = cell(n,2); % Plane of best fits and smallest singular value
x_c = cell(n,1); % Centroid of the leaf
norm_vec = cell(n,1); % Normal vector to the plane of best fit
leaves_transformed = cell(n,2); % Leaves transformed from plane of best fits, [before,after] point cloud reduction.
R = cell(n,1); % Rotational matrices from plane of best fit to the standard cartesian plane
Coeff = cell(n,2); % List of coefficient from radial basis solver
f = cell(n,1); % function representation of leaves.
leaves_new = cell(n,2); % undone transformation of the output leaves.
A = cell(n,1); % Area of all triangle mesh
%% Switch condition
visualisation = false;
RBF_type = 'Thin plate spline'; % RBF type

%% Choose RBF
switch RBF_type
    case 'Thin plate spline'
        phi = @(r) r.^2.*log(r);
    case 'Simple distance'
        phi = @(r) r;
end
fprintf('Initialisation complete. Beginning RBF fitting...\n')
for i = 1:n
    % Plane of best fit
    [norm_vec{i},x_c{i},plane{i,1},plane{i,2}] = best_plane(leaves{i}); % Find plane of best fit of a leaf
    [leaves_transformed{i,1},R{i}] = transform(leaves{i},norm_vec{i}, x_c{i}); % Transform leaf coordinate
    if visualisation
        plot_leaf(leaves{i},plane{i,1},leaves_transformed{i})
    end
    % Point cloud reduction
    leaf = leaves_transformed{i,1};
    ptCloud = pointCloud(leaf);
    ptCloud_unnoised = pcdenoise(ptCloud); 
    
%     ptCloud_reduced = ptCloud_unnoised;%pcdownsample(ptCloud_unnoised,'random',15000/ptCloud_unnoised.Count);
if(length(ptCloud_unnoised.Location)>5000)
    ptCloud_reduced = pcdownsample(ptCloud_unnoised,'random',5000/ptCloud_unnoised.Count);
else
    ptCloud_reduced = ptCloud_unnoised;
end

    leaves_transformed{i,2} = ptCloud_reduced;    
    leaf = ptCloud_reduced.Location;
    
    % RBF solver
    [Coeff{i,1},Coeff{i,2}] = radial_basis_solver4(leaf(:,1:2)',leaf(:,3),phi,RBF_type,10^-4);
    f{i} = @(x) radial_basis_solution(x,phi,leaf(:,1:2)',Coeff{i,1},Coeff{i,2});
    
    % Shrink boundary
    k = boundary(leaf(:,1),leaf(:,2));
    
    % Triangulation
    model = createpde;
    geometryFromEdges(model,@(varargin) leafBorderFunc(leaf(k,1),leaf(k,2),varargin{:}));
    mesh = generateMesh(model,'Hmax',1,'GeometricOrder','linear');
    leaf_new = [mesh.Nodes',f{i}(mesh.Nodes')];
    
    leaves_new{i,2} = mesh.Elements';
%     leaf_new = [leaf(:,1:2),f{i}(leaf(:,1:2))];
%     leaves_new{i,2} = delaunay(leaf_new(:,1:2));
%     
%     centroid = (leaf_new(leaves_new{i,2}(:,1),:)+leaf_new(leaves_new{i,2}(:,2),:)+leaf_new(leaves_new{i,2}(:,3),:))/3;
%     in = inpolygon(centroid(:,1),centroid(:,2),leaf_new(k,1),leaf_new(k,2));
%     leaves_new{i,2} = leaves_new{i,2}(in,:);
    
    leaves_new{i,1} = leaf_new*R{i}' + repmat(x_c{i},length(leaf_new),1); % Undoing transformation
       
    A{i} = tri_area(leaves_new{i,:});
    fprintf('RBF fitting %d/%d complete...\n',i,n)
end

%% Stem detection

[cent] = plant_centroid(leaves_new);
[stems_coord] = stem_find(leaves_new,cent);


%% Plot
%% Plot
fprintf('RBF fitting complete, Begin plotting process...\n')
figure
hold on
for i = 1:n
    leaf_new = leaves_new{i,1};
    stem_coord = stems_coord{i,1};
    trisurf(leaves_new{i,2},leaf_new(:,1),leaf_new(:,2),leaf_new(:,3))
    plot3(stem_coord(1),stem_coord(2),stem_coord(3),'ro')
    fprintf('Ploting %d/%d complete...\n',i,n)
end

plot3(cent(1),cent(2),cent(3),'g*')

axis equal
xlabel('x')
ylabel('y')
zlabel('z')

%% End
t_end = toc;
fprintf('Code finish running, function runtime is %.4g minutes.\n',toc/60)

%% Plotting individual leaf
% for i = 1:7
% figure
% hold on
% leaf_new = leaves_new{i,1};
% stem_coord = stems_coord{i,1};
% trisurf(leaves_new{i,2},leaf_new(:,1),leaf_new(:,2),leaf_new(:,3))
% plot3(stem_coord(1),stem_coord(2),stem_coord(3),'r*')
% fprintf('Ploting %d/7 complete...\n',i)
% axis equal
% xlabel('x')
% ylabel('y')
% zlabel('z')
% end
% 
% %%
% 
% x_test = leaves_transformed{1}(:,1);
% y_test = leaves_transformed{1}(:,2);
% k = convhull(x_test,y_test);
% plot(x_test(k),y_test(k),'r');
% hold on
% plot(leaves_transformed{1}(:,1),leaves_transformed{1}(:,2),'.' );
end