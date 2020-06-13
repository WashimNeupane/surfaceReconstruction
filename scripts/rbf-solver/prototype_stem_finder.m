function [cent,d, stems_coord] = prototype_stem_finder(leaves_new)

maxiter = 10000;
tol = 10^-10;
cent = plant_centroid(leaves_new);
error = inf;
d = zeros(3,1);
i = 0;
while i <= maxiter && error > tol
    [stems_coord] = stem_find(leaves_new,cent,d);
    [x_c,d_new,~] = best_line(stems_coord);
    
    error = norm(x_c - cent) + norm(d_new-d);
    cent = x_c;
    d = d_new;
    i = i+1
end
if i > maxiter
    warning('Code exceed maximum iteration.')
end

end

function [cent] = plant_centroid(leaves_new)
n = size(leaves_new,1);
N = 0;
cent = zeros(1,3);
for i = 1:n
    leaf_new = leaves_new{i,1};
    N = N + size(leaf_new,1);
    cent = cent + sum(leaf_new);
end
cent = (cent/N)';
end

function [stems_coord] = stem_find(leaves_new,cent,d)
n = size(leaves_new,1);
stems_coord = cell(n,1);
for i = 1:n
    leaf_new = leaves_new{i,1};
    m = length(leaf_new);
    v = leaf_new' - cent;
    if norm(d) == 0
        dist_vec = vecnorm(v);
    else
        D = repmat(d,1,m);
        hyp_vec = vecnorm(v);
        adj_vec = dot(v,D);
        dist_vec = sqrt(hyp_vec.^2 - adj_vec.^2);
    end
    [~,I] = min(dist_vec);
    stems_coord{i,1} = leaf_new(I,:);
end
end

function [x_c,d,S] = best_line(data)

m = length(data);
data_vec = zeros(m,3);
for i = 1:m
    data_vec(i,:) = data{i};
end
data = data_vec;
x_c = sum(data)/m;
A = data - repmat(x_c,m,1);
[~,S,d] = svds(A,1);
x_c = x_c';
% Error Analysis

% E = A*a;
% epsilon_sqr = (E'*E)/(a'*a);
% MSE = epsilon_sqr/m;
end