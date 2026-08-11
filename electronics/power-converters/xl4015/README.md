# XL4015 step-down DC-DC converter

Reference CAD model of an XL4015 adjustable 5 A CC/CV buck converter module.

## Catalog representations

- `xl4015-step-down-5a-cc-cv.scad` is the self-contained, editable and optimized
  exterior model used for AI inspection and maintenance.
- `xl4015-step-down-5a-cc-cv.stl` is generated directly from that SCAD model and
  is the primary browser/download representation.
- `xl4015-step-down-5a-cc-cv.step` is retained unchanged as the detailed source
  reference. The original Fusion 360 file remains in `sources/` for future
  engineering review.

The optimized model preserves the 51 × 26 mm PCB envelope, four 2 mm mounting
holes, two auxiliary holes, connector and adjustment access, and the major
component clearance volumes. Its STL has 3,696 triangles versus 124,840 faces in
the tessellated STEP scene, a 97.0% reduction. It is intended for placement,
clearance and catalog visualization rather than PCB manufacturing.

## Provenance

Source reference: [XL4015 on GrabCAD](https://grabcad.com/library/xl4015-1).
PNG renders from the downloaded source directory were intentionally not imported.

The source directory did not include authorship or license terms. Redistribution
and downstream use must therefore be reviewed before production or commercial
use; NarysAI reports this object as `license_status: unverified`.
