# 10-inch tube-frame assembly

Complete mechanical frame extracted from the supplied 10-inch FPV assembly and
converted into one self-contained native OpenSCAD model.

## Included source components

| Component | Quantity |
| --- | ---: |
| Carbon-fiber tube, nominal 18 x 200 mm | 4 |
| Aluminium standoff, nominal 6.4 x 30 mm | 14 |
| Top and bottom plates, 4 mm | 2 |
| Side panel | 2 |
| Two-half arm connector | 4 assemblies |
| Two-half motor mount | 4 assemblies |

Rendered frame envelope: approximately 403.31 x 407.37 x 38.00 mm. The SCAD
contains the complete assembled tessellation in one polyhedron so NarysAI can
render it without repeating expensive boolean unions. It contains no external
STL/STEP import.

This is reference geometry, not a manufacturing drawing. Materials, tolerances,
fasteners, laminate schedule, strength, vibration performance, and flight safety
are unverified.

## Provenance and license

- Inputs: `10 inch Assem stepap214.STEP` and the supplied component STL set.
- STEP SHA-256: `e378710f07af1124d1117a7f1faa8981b34e24072fd2f1ba01dd14b28f8256a1`.
- Frame STL SHA-256: `561ef3325b757f59b1c039b657fa70f95a6599802f444cf34e417c062eed0474`.
- STEP metadata: SolidWorks 2023, timestamp 2025-07-19, declared author
  `asasplit@gmail.com`.
- Original source URL and license were not supplied.
- `license_status: unverified`; NarysAI does not represent the upstream geometry
  as permissively licensed or claim authorship of it.

The SCAD polyhedron was tessellated from the supplied STEP with a 0.35 mm
deflection setting and does not recreate the original SolidWorks feature tree.
