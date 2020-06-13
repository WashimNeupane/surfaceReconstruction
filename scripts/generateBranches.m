%THIS IS A 2 PART CODE
%PART 1: GET ALL THE BRANCH POINTS
%PART 2: GENERATE A CYLINDER CONNECTING THE BRANCH POINTS


%PART 1
out = [val;zzz];
hold on
grid on
plot3(out(1,:),out(2,:),out(3,:),'-r','MarkerSize',12)
bcell = cell(size(stemLocation,1),1);
out = out';
for i =1:length(stemLocation)    
    A = stemLocation(i,:);
    Idx = knnsearch(out,A);
    scatter3(A(1),A(2),A(3))
    B = out(Idx,:);    
bcell{i} = vertcat(A,B)';
plot3(bcell{i}(1,:),bcell{i}(2,:),bcell{i}(3,:),'-r','MarkerSize',15);
end


%PART 2: FIT AN ALPHASHAPE THROUGH ALL THE BRANCHES
%THERE ARE ISSUES WITH THIS VERSION
%A BETTER IMPLEMENTATION USING CYLINDER FITTING IS USED INSTEAD OF THIS


% for i=1:size(stemLocation,1)-1
%     zzzz = bcell{i+1}(1,:); 
%     yyyy = bcell{i+1}(2,:); 
%     xxxx=bcell{i+1}(3,:);
%     z = [];
% x0 = xxxx; y0 = yyyy;
% x0 = repmat(x0, repeats,1);
% y0 = repmat(y0, repeats,1);
% coss = repmat(cos(th),1,size(x0,2));
% 
% x1 = repmat(cos(th)+ x0,1,1);
% y1 = repmat(sin(th)+ y0,1,1);
% x1 = reshape(x1,numel(x1),1);
% y1 = reshape(y1,numel(y1),1);
% 
% for i=1:length(zzzz)
% z1 = [(repmat(zzzz(i),1,repeats))];
% z = [z1,z];
% end
% 
% x = [x1];
% y = [y1];
% z = z';
% hold on
% plot3(z,y,x,'.')
% 
% shp = alphaShape(x,y,z,15);
% [tri,bxyz] = boundaryFacets(shp);
% trisurf(tri,bxyz(:,3),bxyz(:,2),bxyz(:,1))
% 
% end

for i=1:length(bcell)
    [o1,o2,o3] = cylinder(0.4,100,bcell{i}(:,1)',bcell{i}(:,2)');
     new_bcell{i}(:,1) = reshape(o1,numel(o1),1);
     new_bcell{i}(:,2) = reshape(o2,numel(o2),1);
     new_bcell{i}(:,3) = reshape(o3,numel(o3),1);
     
    A = new_bcell{i}(:,1);
    B = new_bcell{i}(:,2);
    C = new_bcell{i}(:,3);
    new_shp{i}= alphaShape(A,B,C,1000);
        
    [tri,cell] = boundaryFacets(new_shp{i});    
    new_tri{i} = tri;
    new_cell{i} = cell;
    trisurf(tri,cell(:,1),cell(:,2),cell(:,3))
    hold on
end










