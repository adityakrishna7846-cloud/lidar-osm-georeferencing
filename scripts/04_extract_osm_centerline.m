%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script : 04_extract_osm_local_coordinates.m
%
% Purpose:
%   Extract local X/Y coordinates embedded inside a Lanelet2/OpenStreetMap
%   (.osm) file for subsequent comparison with LiDAR and GPS datasets.
%
% Inputs:
%   - new_lanelet2_maps.osm
%
% Outputs:
%   - roadX
%   - roadY
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Parameters

osmFile = "new_lanelet2_maps.osm";

%% Read OSM file

osmText = fileread(osmFile);

%% Extract local coordinates

xTokens = regexp( ...
    osmText, ...
    'k="local_x" v="([^"]+)"', ...
    'tokens');

yTokens = regexp( ...
    osmText, ...
    'k="local_y" v="([^"]+)"', ...
    'tokens');

%% Convert strings to numeric values

roadX = cellfun(@(c) str2double(c{1}), xTokens);

roadY = cellfun(@(c) str2double(c{1}), yTokens);

