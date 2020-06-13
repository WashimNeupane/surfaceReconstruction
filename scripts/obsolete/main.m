ptCloudA = pcread('d6a5c98f-3f91-4433-a45d-0657669d63e6__hinten_0.ply');
% % ptCloudB = pcread('d6a5c98f-3f91-4433-a45d-0657669d63e6__vorne_0.ply');

% pcshow(ptHinten);
% figure
% ptCloud = pcmerge(ptCloudA,ptCloudB,1);
ptCloud = pcdenoise(ptCloudA);
pcshow(ptCloud);

X = ptCloud.Location;

%Manual method
Species = cell(3,1);
Species{1} = X(X(:,2)<3120,:);
Species{2} = X(and((X(:,2)<3730),(X(:,2)>3300)),:);
Species{3} = X(X(:,2)>3730,:);

% K-means method
K = 10;
[G,C] = kkmeans(Species{2},K);

%%Get each plant
Plant = cell(K,3);
for i=1:K
    Plant{i,1} = Species{2}(G==i,:);
end


minpts = 35; % Minimum number of neighbors for a core point
epsVal(Species{1},minpts);
epsilon = 4.5;
labels = DBCluster(Species{1},epsilon,minpts);
