function [leaves_new,R] = transform(leaves_old,norm_vec, x_c)

m = length(leaves_old);

a = norm_vec(1);
b = norm_vec(2);
c = norm_vec(3);
N_mag = norm(norm_vec,2);
u_mag = sqrt(a^2+b^2);

N = norm_vec/N_mag;
u = [b;-a;0]/u_mag;
v = [a*c;b*c;-u_mag^2]/(N_mag*u_mag);

R = [u,v,N];
leaves_new = leaves_old - repmat(x_c,m,1);
leaves_new = leaves_new*R;
end