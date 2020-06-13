function [x,y] = leafBorderFunc(xb,yb,bs,s)
% Create a unit circle centered at (0,0) using four segments.
n = length(xb);
switch nargin
    case 2
        x = n-1; % four edge segments
        return
    case 3
        A = [1:(n-1);2:n;ones(1,n-1);zeros(1,n-1)];
        x = A(:,bs); % return requested columns
        return
    case 4
        x = interp1(1:n,xb,s);
        y = interp1(1:n,yb,s);
end