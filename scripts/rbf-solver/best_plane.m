function [norm_vec,x_c,z,S] = best_plane(leaf)
m = length(leaf);
x_c = sum(leaf)/m;
A = leaf - repmat(x_c,m,1);
[~,S,norm_vec] = svds(A,1,'smallest');

d = x_c*norm_vec;
z = @(x,y) (d - norm_vec(1)*x - norm_vec(2)*y)/norm_vec(3);
% Error Analysis
% E = A*a;
% epsilon_sqr = (E'*E)/(a'*a);
% MSE = epsilon_sqr/m;
end