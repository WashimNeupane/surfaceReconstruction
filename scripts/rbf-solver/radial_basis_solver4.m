function [lambda,c] = radial_basis_solver4(x_bar,z,phi,type,rho)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs:
% Outputs:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
        
        if nargin == 5
            
            k = (Q2'*A*Q2 + 8*pi*N*rho*eye(N-(dim+1)))\(Q2'*z);
            lambda = Q2*k;
            c = R\(Q1'*(z - A*lambda));
            
        else  % estimate rho
            
            % search range - A log scaled search range for rho values, a vector with
            %    m_min and m_max, where lambda is in the range (10^-(min_n), 10^-(max_n)
            
            m_min=1; m_max=6;
            options = optimset('Display','iter','TolX',1e-3,'TolFun',1e-6);
            
            % This is for Gneralised cross validation (see Wahba book)
            fun = @(m) N*norm((Q2'*A*Q2 + 8*pi*N*(10^-m)*eye(N-(dim+1)))\(Q2'*z))^2/...
                     trace(inv(Q2'*A*Q2 + 8*pi*N*(10^-m)*eye(N-(dim+1))))^2;
            
            % This is GCV with stochastic trace estimation (see Hutchinson paper)
            % zk = 2*unidrnd(2, N-(dim+1), 1) - 3;  %random 1,-1 vector
            
            % generaste vector independently and identically distributed from a Rademacher distribution
            %nz = N-(dim+1); % number of samples
            %mp = [-1 1];    % the two values disred as outputs
            % Randomly pick one of the two values for nz samples.
            %zk = mp( (rand(1,nz) < 0.5) + 1 )';
            
            %fun = @(m) N*norm((Q2'*A*Q2 + 8*pi*N*(10^-m)*eye(N-(dim+1)))\(Q2'*z))^2/...
            %    (zk'*((Q2'*A*Q2 + 8*pi*N*(10^-m)*eye(N-(dim+1)))\zk))^2;
            
            m_opt = fminbnd(fun, m_min, m_max ,options);
            rho = 10^(-m_opt);  % optimal rho value
            
            disp(['m_opt=' num2str(m_opt) 'rho=' num2str(rho)]);
            
            fprintf('Estimating rho=%g\n',rho);
            
            k = (Q2'*A*Q2 + 8*pi*N*rho*eye(N-(dim+1)))\(Q2'*z);
            lambda = Q2*k;
            c = R\(Q1'*(z - A*lambda));
            
        end
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