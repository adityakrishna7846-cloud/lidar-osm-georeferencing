%% STEP 1: Load Data

ptCloud = pcread('fixed.pcd');
gpsData = readtable('trajectory_xyzyaw.csv');

%% STEP 2: GPS -> ENU

latitudes  = gpsData.x;
longitudes = gpsData.y;
altitudes  = gpsData.z;

lat0 = latitudes(1);
lon0 = longitudes(1);
alt0 = altitudes(1);

[E,N,U] = geodetic2enu( ...
    latitudes, ...
    longitudes, ...
    altitudes, ...
    lat0, ...
    lon0, ...
    alt0, ...
    wgs84Ellipsoid);

gpsTrajectoryMeters = [E,N,U];

% Start trajectory at origin
normTraj = gpsTrajectoryMeters - gpsTrajectoryMeters(1,:);

%% STEP 3: Prepare Point Cloud

cloudXYZ = ptCloud.Location;

validIdx = ~isnan(cloudXYZ(:,1)) & ...
           ~isinf(cloudXYZ(:,1));

cloudXYZ = cloudXYZ(validIdx,:);

% Start cloud at origin
cloudXYZ = cloudXYZ - cloudXYZ(1,:);

%% STEP 4: Automatic Heading Alignment

gpsVec = normTraj(end,1:2) - normTraj(1,1:2);

cloudVec = mean(cloudXYZ(end-100:end,1:2),1) - ...
           mean(cloudXYZ(1:100,1:2),1);

gpsYaw   = atan2(gpsVec(2),gpsVec(1));
cloudYaw = atan2(cloudVec(2),cloudVec(1));

yawCorrection = gpsYaw - cloudYaw;

fprintf('GPS Heading   : %.2f deg\n',rad2deg(gpsYaw));
fprintf('Cloud Heading : %.2f deg\n',rad2deg(cloudYaw));
fprintf('Rotation      : %.2f deg\n',rad2deg(yawCorrection));

% Fine tuning from your latest plot
yawCorrection = yawCorrection + deg2rad(3);

R = [cos(yawCorrection) -sin(yawCorrection) 0;
     sin(yawCorrection)  cos(yawCorrection) 0;
     0                   0                  1];

rotatedCloudXYZ = (R * cloudXYZ')';

%% STEP 5: Centroid Alignment

gpsCenter = mean(normTraj(:,1:3),1);
cloudCenter = mean(rotatedCloudXYZ(:,1:3),1);

translation = gpsCenter - cloudCenter;

% Ignore height during alignment
translation(3) = 0;

finalCloudXYZ = rotatedCloudXYZ + translation;

%% STEP 6: Create Aligned Point Cloud

alignedPtCloud = pointCloud( ...
    finalCloudXYZ, ...
    'Intensity', ptCloud.Intensity(validIdx));

%% STEP 7: Top-Down Verification

figure('Name','2D Alignment');

scatter(finalCloudXYZ(:,1), ...
        finalCloudXYZ(:,2), ...
        1,'.');

hold on;

plot(normTraj(:,1), ...
     normTraj(:,2), ...
     'm', ...
     'LineWidth',3);

axis equal;
grid on;

xlabel('East (m)');
ylabel('North (m)');
title('Top View Alignment');

legend('LiDAR Map','GPS Trajectory');

%% STEP 8: 3D Verification

figure('Name','LiDAR Map vs GPS');

pcshow(alignedPtCloud);
hold on;

plot3(normTraj(:,1), ...
      normTraj(:,2), ...
      normTraj(:,3), ...
      'm-', ...
      'LineWidth',5);

xlabel('East (m)');
ylabel('North (m)');
zlabel('Up (m)');

title('LiDAR Map vs GPS Trajectory');

grid on;

legend('LiDAR Map','GPS Trajectory');
