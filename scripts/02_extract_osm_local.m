%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Script:
%   02_extract_osm_data.m
%
% Purpose:
%   Extract all relevant coordinate information from the Lanelet2 OSM file.
%
% Inputs:
%   new_lanelet2_maps.osm
%
% Outputs:
%   osmLocalX
%   osmLocalY
%   osmLat
%   osmLon
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;
clear;
close all;

%% Step 1 - Read OSM File

osmText = fileread('new_lanelet2_maps.osm');

%% Step 2 - Extract Local Coordinates

xTok = regexp(osmText,...
    'k="local_x" v="([^"]+)"',...
    'tokens');

yTok = regexp(osmText,...
    'k="local_y" v="([^"]+)"',...
    'tokens');

osmLocalX = cellfun(@(c) str2double(c{1}),xTok);
osmLocalY = cellfun(@(c) str2double(c{1}),yTok);

%% Step 3 - Extract Latitude

latTok = regexp(osmText,...
    'lat="([^"]+)"',...
    'tokens');

osmLat = cellfun(@(c) str2double(c{1}),latTok);

%% Step 4 - Extract Longitude

lonTok = regexp(osmText,...
    'lon="([^"]+)"',...
    'tokens');

osmLon = cellfun(@(c) str2double(c{1}),lonTok);

%% Step 5 - Display Information

fprintf('\n');
fprintf('OSM Nodes Extracted\n');
fprintf('-------------------\n');
fprintf('Latitude Nodes : %d\n',length(osmLat));
fprintf('Longitude Nodes: %d\n',length(osmLon));
fprintf('Local X Nodes  : %d\n',length(osmLocalX));
fprintf('Local Y Nodes  : %d\n',length(osmLocalY));

%% Step 6 - Visualize Local Coordinates

figure('Color','w')

scatter(osmLocalX,...
        osmLocalY,...
        15,...
        'filled')

axis equal
grid on

xlabel('Local X (m)')
ylabel('Local Y (m)')

title('Extracted OSM Local Coordinates')

%% Step 7 - Save Extracted Data

save('../results/osm_data.mat',...
     'osmLocalX',...
     'osmLocalY',...
     'osmLat',...
     'osmLon');
