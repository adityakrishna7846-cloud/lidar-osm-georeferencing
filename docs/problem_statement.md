# Problem Statement

## Objective

Investigate why a LiDAR-generated point cloud (.pcd), GPS trajectory (WGS84), and OpenStreetMap vector map (.osm) do not overlap despite representing the same physical road.

---

## Available Data

- LiDAR point cloud (.pcd)
- GPS trajectory (.csv)
- OpenStreetMap lane geometry (.osm)

---

## Expected Behaviour

After transforming every dataset into a common coordinate frame, the following should coincide:

- LiDAR map
- GPS trajectory
- OSM lane centerlines

---

## Initial Observation

The GPS trajectory aligns well with the LiDAR map after converting GPS latitude and longitude into a local ENU frame.

However, the OSM lane geometry does not align with the GPS trajectory even after converting the OSM coordinates into ENU.

The discrepancy is significantly larger than expected GPS error.

---

## Questions Investigated

- Is the GPS conversion correct?
- Is the LiDAR map already in ENU?
- Are the OSM coordinates referenced to the same origin?
- Is Vector Map Builder introducing an offset?
- Is the issue caused by different map projections?
