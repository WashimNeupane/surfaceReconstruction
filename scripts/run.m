%EACH LEAF HAS BEEN DOWNSAMPLED TO A MAXIMUM 1000 POINTS FOR THE PURPOSE OF TESTING

%REGULARISATION PARAMETER FOR STEM SMOOTHING SPLINE IS CONSTANT. 
%MAY GIVE TOO CURVY/STRAIGHT STEMS UNLESS ADJUSTED FOR EACH PLANT
%YOU MAY CHANGE IT THROUGH 'generateBranches.m' SCRIPT BY CHANGING 'p' VARIABLE.

clear all
load('Plant5')
[stems_coord,cent] = best_plane_leaves(leaves);
stems_coord = [stems_coord; cent(1) cent(2) -320];
hold on
generateSpline
generateBranches


 
