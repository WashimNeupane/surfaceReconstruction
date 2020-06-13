function [] = epsVal(X,minpts)
%EPSVAL Summary of this function goes here
%   Detailed explanation goes here
kD = pdist2(X,X,'euc','Smallest',minpts); % The minpts smallest pairwise distances
figure
plot(sort(kD(end,:)));
title('k-distance graph')
xlabel('Points sorted with 50th nearest distances')
ylabel('50th nearest distances')
grid
end

