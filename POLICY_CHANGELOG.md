# Policy changelog

Policy versions follow Semantic Versioning independently from catalog releases
and use Git tags named `policy-vX.Y.Z`.

## [2.0.0] - 2026-08-09

### Changed

- Every new or changed standalone model now requires both same-stem sources:
  `.scad` for AI processing and `.FCStd` for engineering refinement.
- STL and STEP are explicitly generated from the FreeCAD master and are not
  canonical PUB data.
- CI rejects incomplete SCAD/FCStd pairs as well as non-canonical formats.

## [1.1.0] - 2026-08-09

### Added

- `.scad` as the only canonical format for visualization, reference, envelope,
  and parametric placement models.
- `.FCStd` as the only canonical format for complete manufacturable or printable
  parts.
- CI rejection of newly added or modified non-canonical CAD assets.
- Lossless migration requirements for existing legacy STEP/STL/mesh data.

## [1.0.0] - 2026-08-09

### Added

- Initial independently tagged PUB change-governance policy.
