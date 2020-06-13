function [lambda,c] = radial_basis_solver3(x_bar,z,phi,type,rho)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs:
% Outputs:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin == 4
    rho = 0;
end
[dim,N] = size(x_bar);
A = zeros(N);
P = [ones(N,1),x_bar']; % Create a linear matrix

for i = 2:N
    if size(x_bar,1) == 1
        A(i,1:i-1) = phi(abs(x_bar(:,i)-x_bar(:,1:i-1)));
    else
        A(i,1:i-1) = phi(vecnorm(x_bar(:,i)-x_bar(:,1:i-1)));
    end
end
A = A + A';

switch type
    case 'Thin plate spline'
        [Q,R] = qr(P);
        Q1 = Q(:,1:dim+1);
        Q2 = Q(:,dim+2:end);
        R = R(1:dim+1,:);
        
        k = (Q2'*A*Q2 + 8*pi*N*rho*eye(N-(dim+1)))\(Q2'*z);
        lambda = Q2*k;
        c = R\(Q1'*(z - A*lambda));
    case 'Simple distance'
        B = [A - 8*N*pi*rho*eye(N),P;P',zeros(dim+1,dim+1)];
        b = [z;zeros(dim+1,1)];
        k = B\b;
        lambda = k(1:end-(dim+1));
        c = k(end-dim:end);
end
% if M~=N
%     B = B'*B;
%     b = B'*b;
% end
end