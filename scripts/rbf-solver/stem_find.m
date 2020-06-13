function [stems_coord] = stem_find(leaves_new,cent)
n = size(leaves_new,1);
stems_coord = cell(n,1);
for i = 1:n
    leaf_new = leaves_new{i,1};
    dist_vec = vecnorm(leaf_new' - cent');
    [~,I] = min(dist_vec);
    stems_coord{i,1} = leaf_new(I,:);
end
end