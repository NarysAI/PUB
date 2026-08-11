# Policy changelog

## [4.2.0] - 2026-08-11

- Require key dimensions of every new or changed 3D model to match the original
  authoritative reference within a declared numeric tolerance.
- Add `narys.accuracy` schema version 2 with generated-model measurements and
  automated rejection of missing or out-of-tolerance dimensions.
- Require a human-readable reference-versus-model dimension table in each
  affected package README.

## [4.1.0] - 2026-08-11

- Require new or changed 3D parts to declare authoritative dimensional sources,
  critical dimensions, datums, tolerances, and non-functional approximations.
- Prohibit deriving functional or mating geometry solely from photographs or
  perspective renders, and require orthographic plus numerical verification.

Policy versions follow Semantic Versioning independently from catalog releases
and use Git tags named `policy-vX.Y.Z`.

## [4.0.0] - 2026-08-11

### Changed

- Every newly added 3D part now requires a complete optimized same-stem SCAD/STL
  representation pair, regardless of its canonical model role.
- Defined machine-checkable optimization limits: self-contained SCAD without
  external geometry imports and a valid nonempty STL with at most 250,000
  triangles.
- Printable parts retain FCStd as their canonical engineering master while
  adding SCAD and STL delivery representations.
- Local branches, commits, PRs, and localhost previews no longer qualify as
  completed catalog delivery.
- Production refresh and verification of the public HTTPS page, search results,
  representation downloads, and visible 3D preview are mandatory after merge.
- Publication must be reported as pending whenever merge, deployment, refresh,
  or production verification has not happened.

## [3.1.1] - 2026-08-10

### Fixed

- Clarified that canonical 3D `model_role` requirements apply to parts, not
  two-dimensional PartCAD sketches and interface profiles.
- Allowed compatible sketch geometry corrections to use CadQuery, Build123d,
  SVG, DXF, or `basic` sources without assigning an inapplicable 3D role.

## [3.1.0] - 2026-08-10

### Added

- Source-free `narys_project` pointers for active open Git projects.
- Validation that project pointers contain collaboration metadata and no CAD
  objects or assets.
- Explicit separation between PUB discovery identity, public canonical project
  Git, and private-project indexing.

## [3.0.0] - 2026-08-09

### Changed

- Replaced the paired-source rule with mutually exclusive model roles.
- `electronic_component` objects now require SCAD only and prohibit FCStd.
- `printable_part` objects now require FreeCAD FCStd only; STL/STEP are generated
  from that master.
- Website and CI architecture now expose and validate `model_role`.

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
