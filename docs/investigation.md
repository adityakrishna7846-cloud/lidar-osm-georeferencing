# LiDAR–GPS–OSM Georeferencing Investigation

## Objective

The objective of this investigation is to understand why a LiDAR-generated point cloud, GPS trajectory, and OpenStreetMap (OSM) vector map do not initially align despite being collected from the same vehicle.

---

# Available Data

The investigation uses three independent datasets:

1. LiDAR point cloud (.pcd)
2. GPS trajectory (CSV containing WGS84 latitude, longitude, altitude)
3. OSM vector map generated using Vector Map Builder

---

# Initial Observations

The following inconsistencies were observed:

- LiDAR point cloud and GPS trajectory appeared in different coordinate frames.
- OSM local coordinates did not overlap with the LiDAR map.
- Latitude/longitude values represented similar geographic locations but differed in local ENU coordinates.
- Manual mirroring and translation could visually align datasets but did not explain the root cause.

---

# Investigation Timeline

## Stage 1
Converted GPS trajectory from WGS84 to ENU coordinates.

Result:
GPS trajectory successfully represented in a local Cartesian frame.

---

## Stage 2
Aligned LiDAR map to the GPS trajectory using heading estimation and centroid translation.

Result:
LiDAR and GPS showed good overlap after rotation and translation.

---

## Stage 3
Extracted local coordinates from the OSM XML file.

Result:
The OSM geometry matched the road shape but exhibited a significant positional offset.

---

## Stage 4
Compared OSM local coordinates against GPS ENU coordinates.

Result:
The offset persisted despite the geometries having similar shapes.

---

## Current Bottleneck

The remaining challenge is determining how Vector Map Builder defines its local coordinate frame.

Specifically:

- What origin is used?
- How are local X/Y coordinates generated?
- Are they ENU?
- Are they projected coordinates?
- Is an internal transformation applied?

Answering these questions is necessary before the OSM map can be accurately aligned with the LiDAR point cloud in a global coordinate frame.

---

## Current Status

✔ GPS → ENU conversion verified

✔ LiDAR → GPS alignment verified

✔ OSM local coordinate extraction verified

✔ Shape consistency confirmed

⬜ OSM global georeferencing under investigation
