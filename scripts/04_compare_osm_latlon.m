%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script : 04_compare_osm_latlon.m
%
% Purpose:
%   Compare the geographic coordinates (latitude/longitude) stored in the
%   OSM file with the recorded GPS trajectory.
%
% Inputs:
%   - trajectory_xyzyaw.csv
%   - OSM latitude/longitude extracted from the .osm file
%
% Outputs:
%   - OSM vs GPS ENU comparison plot
%   - Translation statistics
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Step 1 - Load GPS trajectory

traj = readtable('trajectory_xyzyaw.csv');

%% Step 2 - Define ENU origin

lat0 = traj.x(1);
lon0 = traj.y(1);
alt0 = traj.z(1);

wgs84 = wgs84Ellipsoid;

%% Step 3 - Convert GPS to ENU

[e_traj,n_traj,~] = geodetic2enu( ...
    traj.x,...
    traj.y,...
    traj.z,...
    lat0,...
    lon0,...
    alt0,...
    wgs84);

%% Step 4 - Convert OSM Lat/Lon to ENU

[e_osm,n_osm,~] = geodetic2enu( ...
    osmLat,...
    osmLon,...
    zeros(size(osmLat)),...
    lat0,...
    lon0,...
    alt0,...
    wgs84);

%% Step 5 - Visual comparison

figure('Color','w')

plot(e_traj,n_traj,'b','LineWidth',2)

hold on

plot(e_osm,n_osm,'ro','MarkerSize',8)

axis equal
grid on

legend('GPS Trajectory','OSM Nodes')

xlabel('East (m)')
ylabel('North (m)')

title('OSM WGS84 vs GPS (ENU)')

%% Step 6 - Measure centroid offset

gpsCenter = mean([e_traj n_traj],1);
osmCenter = mean([e_osm n_osm],1);

offset = osmCenter - gpsCenter;

fprintf('\n');
fprintf('Mean East Offset : %.2f m\n',offset(1));
fprintf('Mean North Offset: %.2f m\n',offset(2));
