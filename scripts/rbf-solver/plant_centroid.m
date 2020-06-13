function [cent] = plant_centroid(leaves_new)
n = size(leaves_new,1);
N = 0;
cent = zeros(1,3);
for i = 1:n
    leaf_new = leaves_new{i,1};
    N = N + size(leaf_new,1);
    cent = cent + sum(leaf_new);
end
cent = cent/N;
end