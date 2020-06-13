function A = tri_area(globalcoord, delaunay_id)
N = size(delaunay_id,1);
A = zeros(N,1);
for i = 1:N
    tricoord = globalcoord(delaunay_id(i,:),:);
    A(i) = norm(cross(tricoord(2,:)-tricoord(1,:),tricoord(3,:)-tricoord(1,:)))/2;
end

end