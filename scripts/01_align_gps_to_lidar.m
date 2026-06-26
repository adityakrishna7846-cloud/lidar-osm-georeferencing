%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Script:
%   01_align_gps_to_lidar.m
%
% Purpose:
%   Align a LiDAR point cloud with a GPS trajectory by converting GPS
%   coordinates from WGS84 to a local ENU coordinate frame and estimating
%   the rigid-body transformation between the datasets.
%
% Inputs:
%   fixed.pcd
%   trajectory_xyzyaw.csv
%
% Outputs:
%   aligned_lidar.pcd
%   alignment_transform.mat
%   GPS vs LiDAR verification plots
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;
clear;
close all;

%% Parameters

pcdFile = 'fixed.pcd';
gpsFile = 'trajectory_xyzyaw.csv';

sampleWindow = 100;
manualYawOffsetDeg = 3;

%% Step 1 - Load Data

ptCloud = pcread(pcdFile);
gpsData = readtable(gpsFile);

%% Step 2 - Convert GPS (WGS84) to ENU

latitudes  = gpsData.x;
longitudes = gpsData.y;
altitudes  = gpsData.z;

originLat = latitudes(1);
originLon = longitudes(1);
originAlt = altitudes(1);

wgs84 = wgs84Ellipsoid;

[east,north,up] = geodetic2enu( ...
    latitudes,...
    longitudes,...
    altitudes,...
    originLat,...
    originLon,...
    originAlt,...
    wgs84);

gpsENU = [east north up];

% Normalize trajectory

gpsENU = gpsENU - gpsENU(1,:);

%% Step 3 - Prepare LiDAR Point Cloud

cloudXYZ = ptCloud.Location;

validIdx = ~isnan(cloudXYZ(:,1)) & ...
           ~isinf(cloudXYZ(:,1));

cloudXYZ = cloudXYZ(validIdx,:);

cloudXYZ = cloudXYZ - cloudXYZ(1,:);

%% Step 4 - Estimate Heading Difference

gpsVec = gpsENU(end,1:2) - gpsENU(1,1:2);

cloudVec = ...
    mean(cloudXYZ(end-sampleWindow:end,1:2),1) - ...
    mean(cloudXYZ(1:sampleWindow,1:2),1);

gpsYaw = atan2(gpsVec(2),gpsVec(1));

cloudYaw = atan2(cloudVec(2),cloudVec(1));

yawCorrection = gpsYaw - cloudYaw;

yawCorrection = yawCorrection + ...
                deg2rad(manualYawOffsetDeg);

fprintf('\n');
fprintf('GPS Heading      : %.2f deg\n',rad2deg(gpsYaw));
fprintf('LiDAR Heading    : %.2f deg\n',rad2deg(cloudYaw));
fprintf('Applied Rotation : %.2f deg\n',rad2deg(yawCorrection));

%% Step 5 - Rotate LiDAR

rotationMatrix = ...
    [cos(yawCorrection) -sin(yawCorrection) 0;
     sin(yawCorrection)  cos(yawCorrection) 0;
     0                   0                  1];

rotatedCloudXYZ = ...
    (rotationMatrix * cloudXYZ')';

%% Step 6 - Translate LiDAR

gpsCenter = mean(gpsENU);

cloudCenter = mean(rotatedCloudXYZ);

translationVector = gpsCenter - cloudCenter;

translationVector(3) = 0;

alignedCloudXYZ = ...
    rotatedCloudXYZ + translationVector;

%% Step 7 - Create Aligned Point Cloud

alignedPtCloud = pointCloud( ...
    alignedCloudXYZ,...
    'Intensity',ptCloud.Intensity(validIdx));

%% Step 8 - Top View Verification

figure('Color','w');

scatter(alignedCloudXYZ(:,1),...
        alignedCloudXYZ(:,2),...
        1,'.');

hold on

plot(gpsENU(:,1),...
     gpsENU(:,2),...
     'm',...
     'LineWidth',3)

axis equal
grid on

xlabel('East (m)')
ylabel('North (m)')

title('LiDAR vs GPS (ENU)')

legend('LiDAR','GPS')

%% Step 9 - 3D Verification

figure('Color','w');

pcshow(alignedPtCloud)

hold on

plot3(gpsENU(:,1),...
      gpsENU(:,2),...
      gpsENU(:,3),...
      'm',...
      'LineWidth',4)

xlabel('East (m)')
ylabel('North (m)')
zlabel('Up (m)')

title('Aligned LiDAR Point Cloud')

%% Step 10 - Save Results

pcwrite(alignedPtCloud,...
    '../results/aligned_lidar.pcd');

save('../results/alignment_transform.mat',...
     'rotationMatrix',...
     'translationVector',...
     'yawCorrection');
