# LiDAR–OSM Georeferencing Analysis

## Overview

This repository documents an investigation into the alignment of three mapping datasets commonly encountered in autonomous vehicle workflows:

* LiDAR point cloud maps (.pcd)
* GPS trajectories (WGS84 latitude/longitude)
* HD maps generated in OSM format

The objective was to determine the source of misalignment observed between a LiDAR point cloud and a Vector Map Builder generated OSM map.

Due to confidentiality restrictions, the original datasets are not included in this repository. The focus of this repository is on the methodology.

---

## Problem Statement

A LiDAR point cloud map and an OSM road map represented the same roadway geometry but appeared misaligned when visualized using geographic coordinates.

The investigation aimed to determine whether the discrepancy originated from:

* LiDAR map geometry
* GPS trajectory accuracy
* OSM map geometry
* Georeferencing inconsistencies

---

## Methodology

The following workflow was implemented:

1. Parse OSM node information and extract local coordinates.
2. Load and visualize LiDAR point cloud data.
3. Convert GPS trajectory coordinates from WGS84 to ENU coordinates.
4. Compare local map geometry against LiDAR geometry.
5. Compare GPS trajectory against LiDAR geometry.
6. Evaluate alignment between OSM geographic coordinates and GPS coordinates.
7. Quantify translation and orientation differences.

---

## Key Findings

### Local Coordinate Analysis

The OSM local coordinates and LiDAR point cloud geometry were found to be consistent after a rigid transformation.

### GPS Validation

The GPS trajectory followed the same roadway geometry represented by the LiDAR map.

### Georeferencing Investigation

A significant discrepancy was observed between the OSM geographic coordinates and the GPS trajectory.

This suggests that the primary challenge is not lane geometry reconstruction but the relationship between the coordinate frames used during map generation and trajectory recording.

---

## Technologies Used

* MATLAB
* Point Cloud Processing
* WGS84 Coordinate Systems
* ENU Transformations
* OSM XML Parsing
* Georeferencing Analysis

---

## Repository Contents

scripts/ – MATLAB analysis code

docs/ – Investigation notes and findings

images/ – Visualizations and plots

results/ – Summary outputs

---

## Status

Investigation completed at the local geometry level.

Further work focuses on identifying the source of the georeferencing discrepancy and validating coordinate-frame assumptions used during map generation.
