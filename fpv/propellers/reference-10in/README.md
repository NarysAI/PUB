# Reference 10-inch FPV propeller

Self-contained OpenSCAD conversion of the nominal 10-inch three-blade propeller
present in the supplied drone STEP assembly.

## Geometry

- Nominal class: 10 inch.
- Three blades and hub are retained as one watertight source solid.
- Maximum rendered axis-aligned envelope depends on the source blade rotation;
  the standalone SCAD is centered for placement and inspection.
- Canonical source: `reference-propeller-10in.scad`; no STL/STEP import is used.

The model is suitable for visual layout and clearance checks. Pitch, airfoil,
rotation direction, material, RPM rating, hub standard, balance, and safe flight
load are unverified. It must not be used to manufacture a flight propeller.

## Provenance and license

- Input: `10 inch Assem stepap214.STEP`.
- STEP SHA-256: `e378710f07af1124d1117a7f1faa8981b34e24072fd2f1ba01dd14b28f8256a1`.
- STEP metadata: SolidWorks 2023, timestamp 2025-07-19, declared author
  `asasplit@gmail.com`.
- Original source URL, manufacturer, part number, and license were not supplied.
- `license_status: unverified`; NarysAI does not represent the upstream geometry
  as permissively licensed or claim authorship of it.

The SCAD polyhedron was tessellated from the supplied STEP with a 0.35 mm
deflection setting. It is native OpenSCAD geometry but does not recreate the
original SolidWorks feature history.
