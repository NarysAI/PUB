# Reference 35 mm FPV motor

Self-contained OpenSCAD conversion of the motor present in the supplied
10-inch FPV drone STEP assembly.

## Geometry

- Nominal diameter: 35 mm.
- Rendered envelope: approximately 34.99 x 34.99 x 49.35 mm.
- Three source solids preserve the shaft, bell, and motor body.
- Canonical source: `reference-motor-35mm.scad`; no STL/STEP import is used.

This is a placement and clearance reference, not a claim of compatibility with
a particular motor SKU, bolt pattern, KV rating, electrical interface, or
manufacturing process.

## Provenance and license

- Input: `10 inch Assem stepap214.STEP`.
- STEP SHA-256: `e378710f07af1124d1117a7f1faa8981b34e24072fd2f1ba01dd14b28f8256a1`.
- STEP metadata: SolidWorks 2023, timestamp 2025-07-19, declared author
  `asasplit@gmail.com`.
- Original source URL, manufacturer, part number, and license were not supplied.
- `license_status: unverified`; NarysAI does not represent the upstream geometry
  as permissively licensed or claim authorship of it.

The SCAD polyhedra were tessellated from the supplied STEP with a 0.35 mm
deflection setting. They are native OpenSCAD geometry but do not recreate the
original SolidWorks feature history.
