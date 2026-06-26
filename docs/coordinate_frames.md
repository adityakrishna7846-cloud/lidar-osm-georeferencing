# Coordinate Frames

One of the primary challenges in autonomous vehicle mapping is that different sensors and mapping tools represent the same physical environment using different coordinate systems.

This document summarizes the coordinate frames encountered during this investigation.

---

# Overview

| Dataset | Coordinate Frame | Units |
|----------|------------------|-------|
| GPS | WGS84 Geodetic | Latitude / Longitude / Altitude |
| LiDAR Point Cloud | Local Cartesian | meters |
| OSM (Lat/Lon) | WGS84 Geodetic | Latitude / Longitude |
| OSM (local_x/local_y) | Local Cartesian (Vector Map Builder) | meters |

Although these datasets describe the same environment, they cannot be directly compared because they are expressed in different coordinate frames.

---

# 1. WGS84 Coordinates

GPS receivers report positions using the World Geodetic System (WGS84).

Example:

Latitude : 22.591426°

Longitude: 75.638692°

Altitude : 10.16 m

These values describe a position on the Earth's surface.

Distances cannot be measured directly using latitude and longitude.

---

# 2. ENU Coordinates

For local mapping, GPS positions are converted into an East-North-Up (ENU) coordinate system.

A reference GPS point is selected as the origin.

Every GPS measurement is then expressed as

East (meters)

North (meters)

Up (meters)

This creates a local Cartesian coordinate frame suitable for comparison with LiDAR maps.

---

# 3. LiDAR Coordinate Frame

The LiDAR point cloud is already represented in a Cartesian coordinate system.

Each point consists of

(X, Y, Z)

expressed in meters.

However, the origin depends on the mapping software or SLAM algorithm.

The point cloud is not guaranteed to share the same origin as the GPS trajectory.

---

# 4. OSM Coordinates

The generated OSM file contains two independent representations.

## Geographic Coordinates

Each node contains

Latitude

Longitude

Elevation

These are globally referenced.

---

## Local Coordinates

Each node also contains

local_x

local_y

These values are measured in meters.

However, the method used by Vector Map Builder to generate these local coordinates is currently under investigation.

The local origin does not appear to coincide with the ENU origin used for the GPS trajectory.

---

# Coordinate Relationships

```
                WGS84
                  │
      geodetic2enu()
                  │
                  ▼
            GPS ENU Frame
                  │
          Compare with
                  │
                  ▼
          LiDAR Point Cloud
                  │
          Compare with
                  │
                  ▼
      OSM local_x / local_y
```

---

# Current Findings

## GPS ↔ LiDAR

Successfully aligned after

- heading correction
- rotation
- translation

---

## GPS ↔ OSM (Lat/Lon)

The geographic positions describe the same roadway.

---

## GPS ENU ↔ OSM local_x/local_y

The road geometry is consistent.

However, a significant translation offset remains.

The source of this offset is believed to originate from the coordinate frame used internally by Vector Map Builder.

---

# Remaining Question

The primary unresolved question is

> How does Vector Map Builder define its local Cartesian coordinate system?

Understanding this transformation is required before the OSM map can be perfectly aligned with the LiDAR point cloud without manual adjustment.
