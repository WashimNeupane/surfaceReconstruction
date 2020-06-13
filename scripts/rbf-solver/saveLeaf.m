function saveLeaf(filename,points,triangles,uv)

% Change point to homogenous coordinates
if size(points,2)==3
    points = [points,ones(size(points,1),1)];
end

% Get bounding box
maxs = [max(points(:,1)) max(points(:,2)) max(points(:,3))];
mins = [min(points(:,1)) min(points(:,2)) min(points(:,3))];
bbox = [mins, reshape(diag(maxs-mins)',1,[])];

% Get face normals (not saved)
s1 = points(triangles(:,2),1:3)-points(triangles(:,1),1:3);
s2 = points(triangles(:,3),1:3)-points(triangles(:,1),1:3);
normals = cross(s1,s2,2); 

%Get vertex normals
vertexNormals = zeros(size(obj.points,1),3);
for i=1:size(points,1)
    inds = find(sum(triangles==i,2));
    tempNorms = normals(inds,:);
    % Comment for loop to get a weighted average for the vertex normal
    for j=1:size(tempNorms,1)
        tempNorms(j,:) = tempNorms(j,:)/norm(tempNorms(j,:));
    end
    vertexNormals(i,:) = mean(tempNorms);
    vertexNormals(i,:) = vertexNormals(i,:)/norm(vertexNormals(i,:));
end

% Open file
fileID = fopen([filename '.leaf'],'w');

% Get number of vertices and faces
np = size(points,1);
nt = size(triangles,1);
fprintf(fileID,'# %u %u\n',np,nt);

% Write vertices
for i=1:np
    fprintf(fileID,'v %f %f %f %f\n',points(i,:));
end

% Write vertex normals
nn = size(obj.vertexNormals,1);
for i=1:nn
    fprintf(fileID,'vn %f %f %f\n',vertexNormals(i,:));
end

% I haven't implemented the uv map yet

% if varargin>3
%     for i=1:nn
%         fprintf(fileID,'vn %f %f\n',uv(i,:));
%     end
%     
%     for i=1:nt
%         fprintf(fileID,'f %u/%u %u/%u %u/%u\n',reshape(repmat(triangles(i,:),2),[],1));
%     end
% else
    fprintf(fileID,'vt 0 0\n');
    
    for i=1:nt
        fprintf(fileID,'f %u/1 %u/1 %u/1\n',triangles(i,:));
    end
% end

% Add teh material type (leave this)
fprintf(fileID,'uvMat Wheat leafTop\n');

% Write bounding box
fprintf(fileID,'bb %f %f %f %f %f %f %f %f %f %f %f %f\n',bbox);

% Write colour (rgb)
colour = [52,106,15];
fprintf(fileID,'c %u %u %u\n',colour);

fclose(fileID);

end