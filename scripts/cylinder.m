function [X, Y, Z] = cy(R, N,point1coords,point2coords)
    theta = linspace(0,2*pi,N);
    m = length(R);                 % Number of radius vectoralues
                                   % supplied.
    if m == 1                      % Only one radius vectoralue supplied.
        R = [R; R];                % Add a duplicate radius to make
        m = 2;                     % a cylinder.
    end
    
    X = zeros(m, N);             % Preallocate memory.
    Y = zeros(m, N);
    Z = zeros(m, N);
    
    vector=(point2coords-point1coords)/sqrt((point2coords-point1coords)*(point2coords-point1coords)');    %Normalized vector;
    random_point=rand(1,3);                                   %linear independent vector
    oth_vector=vector-random_point/(random_point*vector');    %orthogonal vector to vector
    oth_vector=oth_vector/sqrt(oth_vector*oth_vector');       %orthonormal vector to vector
    oth_vector2=cross(vector,oth_vector);                     %vectorector orthonormal to vector and oth_vector
    oth_vector2=oth_vector2/sqrt(oth_vector2*oth_vector2');
    
    point1coordsx=point1coords(1);point1coordsy=point1coords(2);point1coordsz=point1coords(3);
    point2coordsx=point2coords(1);point2coordsy=point2coords(2);point2coordsz=point2coords(3);
    vectorx=vector(1);vectory=vector(2);vectorz=vector(3);
    oth_vectorx=oth_vector(1);oth_vectory=oth_vector(2);oth_vectorz=oth_vector(3);
    oth_vector2x=oth_vector2(1);oth_vector2y=oth_vector2(2);oth_vector2z=oth_vector2(3);
    
    time=linspace(0,1,m);
    for j = 1 : m
      t=time(j);
      X(j, :) = point1coordsx+(point2coordsx-point1coordsx)*t+R(j)*cos(theta)*oth_vectorx+R(j)*sin(theta)*oth_vector2x; 
      Y(j, :) = point1coordsy+(point2coordsy-point1coordsy)*t+R(j)*cos(theta)*oth_vectory+R(j)*sin(theta)*oth_vector2y; 
      Z(j, :) = point1coordsz+(point2coordsz-point1coordsz)*t+R(j)*cos(theta)*oth_vectorz+R(j)*sin(theta)*oth_vector2z;
    end
   surf(X,Y,Z)
   X = reshape(X,numel(X),1);
   Y = reshape(Y,numel(Y),1);
   Z = reshape(Z,numel(Z),1);
   shp = alphaShape(X,Y,Z,10);
   [tri,cell] = boundaryFacets(shp);
   trisurf(tri,cell(:,1),cell(:,2),cell(:,3));

