load('../results/osm_local.mat');

osmX = osmLocalY;
osmY = -osmLocalX;

figure
plot(rotatedCloudXYZ(:,1),...
     rotatedCloudXYZ(:,2),'.')
hold on
plot(osmX,...
     osmY,...
     'r.')
axis equal
grid on
legend('LiDAR','OSM')
