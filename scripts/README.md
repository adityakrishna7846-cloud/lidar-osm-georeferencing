# MATLAB Scripts

This directory contains all MATLAB scripts developed during the LiDAR–GPS–OSM georeferencing investigation.

---

## Current Scripts

| Script | Purpose |
|---------|---------|
| 01_align_gps_to_lidar.m | Converts GPS (WGS84) to ENU coordinates and aligns the LiDAR map with the GPS trajectory. |
| 02_compare_osm_local.m | Compares OSM local coordinates against the LiDAR map. |
| 03_compare_osm_latlon.m | Evaluates alignment between GPS and OSM latitude/longitude coordinates. |
| 04_extract_osm_centerline.m | Extracts local coordinates from the OSM XML file. |
| 05_export_pointclouds.m | Exports transformed datasets into PCD format for visualization. |

---

## Utilities

Utility functions are placed in

```

scripts/utilities/

```

These include reusable functions for

- reading OSM nodes
- GPS to ENU conversion
- plotting
- coordinate transformations
