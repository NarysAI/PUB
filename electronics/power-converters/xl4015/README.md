# XL4015 step-down DC-DC converter

Reference CAD model of an XL4015 adjustable 5 A CC/CV buck converter module.

This package publishes two distinct catalog objects:

- `xl4015-step-down-5a-cc-cv`: the original 51 × 26 mm CC/CV board with screw
  terminals, preserved STEP/F3D sources, and its optimized SCAD/STL exterior;
- `xl4015-1`: the separate 55 × 25 × 15 mm UNIT Electronics / GrabCAD layout,
  which uses solder-pad connections, two end capacitors, a central flat toroid,
  and a single top-edge trimmer.

The public catalog uses the self-contained optimized SCAD exterior and its
generated STL representation. The original detailed STEP model remains unchanged
in the package, and the original Fusion 360 file remains in `sources/` for future
engineering edits. PNG renders from the source directory were intentionally not
imported.

The SCAD/STL bundle is a simplified placement and clearance representation of
this XL4015 object. It does not replace or claim the internal detail of the
preserved STEP source.

The `xl4015-1` SCAD/STL is an exterior reconstruction from the public GrabCAD
renderings and the 55 × 25 × 15 mm manufacturer envelope. GrabCAD lists the
original file as `XL4015_MODELO_PISTAS.step`, but downloading it requires an
authenticated account; the reconstruction therefore makes no claim of internal
or manufacturing-level accuracy.

The source directory did not include authorship or license terms. Redistribution
and downstream use must therefore be reviewed before production or commercial
use; NarysAI reports this object as `license_status: unverified`.
