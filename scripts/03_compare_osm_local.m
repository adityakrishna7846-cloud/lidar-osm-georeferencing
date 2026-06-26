%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script : 03_compare_osm_local.m
%
% Purpose:
%   Compare the local Cartesian coordinates extracted from the OSM file
%   against the LiDAR point cloud.
%
% Inputs:
%   - fixed.pcd
%   - new_lanelet2_maps.osm
%
% Outputs:
%   - OSM vs LiDAR comparison plot
%   - osm_centerline.pcd
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Step 1 - Load LiDAR Point Cloud

ptCloud = pcread('fixed.pcd');
cloudXYZ = reshape(ptCloud.Location,[],3);

%% Step 2 - Read OSM File

osmText = fileread('new_lanelet2_maps.osm');

%% Step 3 - Extract Local Coordinates

xTok = regexp(osmText,...
    'k="local_x" v="([^"]+)"',...
    'tokens');

yTok = regexp(osmText,...
    'k="local_y" v="([^"]+)"',...
    'tokens');

osmLocalX = cellfun(@(c) str2double(c{1}),xTok);
osmLocalY = cellfun(@(c) str2double(c{1}),yTok);

fprintf('Extracted %d OSM nodes.\n',length(osmLocalX));

%% Step 4 - Transform OSM Coordinates

% The local coordinate frame stored in the OSM file differs from the
% LiDAR coordinate frame. During investigation it was observed that
% swapping the axes and mirroring one axis aligns the road geometry.

osmX = osmLocalY;
osmY = -osmLocalX;

%% Step 5 - Rotate LiDAR (Initial Alignment)

theta = -pi/2;

R = [cos(theta) -sin(theta);
     sin(theta)  cos(theta)];

rotatedCloudXY = (R * cloudXYZ(:,1:2)')';

%% Step 6 - Visual Comparison

figure('Color','w');

plot(rotatedCloudXY(:,1),...
     rotatedCloudXY(:,2),...
     '.',...
     'MarkerSize',2);

hold on;

plot(osmX,...
     osmY,...
     'r.',...
     'MarkerSize',18);

axis equal;
grid on;

xlabel('X (m)');
ylabel('Y (m)');

title('OSM Local Coordinates vs LiDAR Map');

legend('LiDAR','OSM');

%% Step 7 - Export OSM Centerline

osmCloud = pointCloud( ...
    [osmX(:), ...
     osmY(:), ...
     zeros(size(osmX(:)))]);

pcwrite(osmCloud,'osm_centerline.pcd');

fprintf('\n');
fprintf('OSM centerline exported successfully.\n');
fprintf('File: osm_centerline.pcd\n');
