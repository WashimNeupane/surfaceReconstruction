%THIS IS A 2 PART CODE
%PART-1: GENERATES SPLINE
%PART-2: GENERATES THE STEM (WITH TRIANGULATED MESH)
%PART-1: GENERATE SPLINE
%------------------------------------------------------------------
for i=1:length(stems_coord)
    stemLocation(i,1:3) = stems_coord{i}(:,1:3);
end

npts = length(stemLocation);
xyz = stemLocation';

x = xyz(1,:);
y = xyz(2,:);
z = xyz(3,:);
%Get xyz coordinates for Smoothed spline
% epsilon = ((z(end)-z(1))/(numel(z)-1))^3/16; p = 1/(1+epsilon*10^(3));   
%p = regularisation parameter

p =10^-4;

[pp,p]=csaps(z,[x;y],p);
zzz = linspace(-320, -260,50);
val=fnval(pp,zzz);

text(x,y,z,[repmat('  ',npts,1), num2str((1:npts)')])
plot3(val(1,:),val(2,:),zzz,'r.','Linewidth',7)
grid on

%------------------------------------------------------------------
%PART 2: GENERATE STEM WITH TRIANGULATED MESH
%------------------------------------------------------------------

repeats =100;
th = linspace(pi/12,1000*pi,repeats)'; newz = zzz;
z = [];
x0 = fliplr(val(1,:)); y0 = fliplr(val(2,:));
x0 = repmat(x0, repeats,1);
y0 = repmat(y0, repeats,1);
coss = repmat(cos(th),1,size(x0,2));

x1 = repmat(cos(th)+ x0,1,1);
y1 = repmat(sin(th)+ y0,1,1);
x1 = reshape(x1,numel(x1),1);
y1 = reshape(y1,numel(y1),1);

for i=1:length(newz)
z1 = [(repmat(newz(i),1,repeats))];
z = [z1,z];
end

x = [x1];
y = [y1];
z = z';
hold on
plot3(x,y,z,'-')

shp = alphaShape(x,y,z,20);
plot(shp)
[tri,bcellz] = boundaryFacets(shp);
trisurf(tri,bcellz(:,1),bcellz(:,2),bcellz(:,3))