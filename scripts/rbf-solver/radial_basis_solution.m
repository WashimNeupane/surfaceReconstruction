function [z_approx] = radial_basis_solution(x,phi,x_bar,lambda,c)

if size(x,1) ~= size(x_bar,1)
    x = x';
    n = size(x,2);
    z_approx = zeros(n,1);
else
    n = size(x,2);
    z_approx = zeros(1,n);
end


for i = 1:n
    if size(x_bar,1) == 1
        r = abs(x(:,i) - x_bar);
    else
        r = vecnorm(x(:,i) - x_bar);
    end
    
    RBF_vector = lambda.*phi(r');
    RBF_vector(isnan(RBF_vector)) = 0;
    z_approx(i) = sum(RBF_vector);
    %     for j = 1: size(lambda)
    %         if r(j) ~= 0
    %             z_approx(i) = z_approx(i) + lambda(j)*phi(r(j));
    %         end
    %     end
    
    z_approx(i) = z_approx(i) + c(1) + c(2:end)'*x(:,i);
end

end