function [x_c,d,S] = best_line(data)

m = length(data);
data_vec = [];
for i = 1:m
    data_vec = [data_vec;data{i}];
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