# Changelog

## [4.5.2] - 2026-08-11

### Fixed

- Rebuilt `usb-c-male-cable` from measurements taken from the linked original
  GrabCAD CAD viewer instead of visual estimates.
- Corrected the overall length to `48.77 mm`, the exposed plug to `7.24 mm`, the
  housing to `17.01 x 10.65 x 5.70 mm`, the smooth strain relief to
  `5.69 mm / 4.50 mm diameter`, and the cable to `3.30 mm diameter`.
- Added machine-checked reference-versus-model values for all key dimensions.

## [4.5.1] - 2026-08-11

- Corrected the Micro HDMI Type D male mating interface to the manufacturer
  drawing: `5.83 x 2.20 mm` shell, `4.65 mm` lower edge, `7.15 mm` engagement
  length, and the asymmetric Type D profile with `R0.25 mm` upper corners.
- Rebuilt the 19 contacts as two staggered rows on `0.40 mm` pitch with a
  `0.20 mm` row offset and documented which cable-body features remain cosmetic.
- Added dimensional-accuracy metadata and catalog policy enforcement for all
  new or changed 3D parts.

All notable catalog changes are recorded here. The format follows Keep a
Changelog, and catalog versions follow Semantic Versioning.

## [4.5.0] - 2026-08-11

### Added

- Added the `usb-c-male-cable` connector package with an independently authored,
  self-contained SCAD clearance model and a generated STL representation.
- Recorded Omri Datz's 2025 GrabCAD STEP model as the visual reference while
  keeping its unverified redistribution terms and sign-in-gated source archive
  out of PUB.

## [4.4.0] - 2026-08-11

### Added

- Added `//pub/electromechanics/switches/kcd1-203-dpdt-rocker` as a separate
  six-terminal DPDT `II-O-I` rocker reconstructed from the supplied videos and
  ruler photographs, without changing the existing three-terminal KCD1 object.
- Added the required self-contained SCAD/STL exterior representation pair with
  four semantic preview materials and a documented KCD1-203-compatible identity.

## [4.3.0] - 2026-08-11

### Added

- Added the `micro-hdmi-type-d-cable-male` connector package with an
  independently authored, self-contained SCAD clearance model and a generated
  STL representation.
- Recorded Alexandre Willame's 2015 GrabCAD model as the visual reference while
  keeping its unverified redistribution terms and unavailable sign-in-gated CAD
  archive out of PUB.

## [4.2.0] - 2026-08-11

### Added

- Added `electronics/power-converters/xl4015:xl4015-1` as a second, distinct
  XL4015-family object with its own optimized SCAD/STL exterior bundle.
- Reconstructed the visibly different 55 × 25 × 15 mm solder-pad layout from
  public GrabCAD renderings and the linked UNIT Electronics product envelope.

### Changed

- Documented the original screw-terminal XL4015 and the new `XL4015-1` as two
  separate catalog identities; neither replaces or aliases the other.

### Migration

- See `MIGRATIONS/4.2.0-XL4015-TWO-VARIANTS.md` for identity and accuracy notes.
## [4.1.6] - 2026-08-11

### Changed

- Restored the existing optimized SCAD and generated STL bundle to the public
  `xl4015-step-down-5a-cc-cv` object.
- Kept the original detailed STEP and Fusion 360 sources unchanged in the package
  and documented that the SCAD/STL exterior is a simplified clearance model.
- Kept the unrelated GrabCAD `xl4015-1` variant out of this stable object; it must
  be published separately from its own source geometry.

### Migration

- See `MIGRATIONS/4.1.6-XL4015-REPRESENTATIONS.md` for the representation record.

## [4.1.5] - 2026-08-11

### Fixed

- Restored `xl4015-step-down-5a-cc-cv` to its original detailed STEP model after
  it was incorrectly replaced by a reconstructed SCAD/STL exterior.
- Removed the incorrect GrabCAD `xl4015-1` attribution from the original object.
  `XL4015` and `xl4015-1` are distinct variants and must have separate object IDs
  and source-derived SCAD/STL bundles.

### Migration

- See `MIGRATIONS/4.1.5-RESTORE-XL4015.md` for the identity correction.

## [4.1.4] - 2026-08-11

### Changed

- Required every newly added 3D part to ship a complete optimized SCAD/STL
  representation pair, with automated validation of pairing, self-containment,
  STL validity, and a 250,000-triangle ceiling.
- Defined catalog completion as successful production publication: merge,
  release tag, production refresh, public search/download checks, and visible
  3D-preview verification are mandatory before work may be reported done.
- Migrated XL4015 from its legacy STEP-only catalog entry to a complete,
  optimized, same-stem SCAD/STL exterior bundle while retaining the original
  STEP and Fusion 360 sources for engineering reference.
- Reduced the XL4015 browser mesh from 124,840 STEP-scene faces to 3,696 STL
  triangles while preserving its 51 × 26 mm board envelope, mounting pattern,
  controls, connectors, and major clearance volumes.

### Migration

- See `MIGRATIONS/4.1.4-XL4015-SCAD-STL.md` for the source-preservation and
  compatibility record.

## [4.1.3] - 2026-08-11

### Changed

- Optimized the self-contained H30 Enclosed SCAD/STL to exterior geometry only:
  the original housing, cover, and four cover screws remain while the PCB and
  other hidden STEP objects are omitted.
- Reduced H30 Enclosed from 135,223 to 13,072 facets, cutting the SCAD size by
  91.2% and the STL size by 90.3% without changing the visible envelope.

## [4.1.2] - 2026-08-10

### Fixed

- Added the three missing M3x4 cover screws to H30 Enclosed by copying the
  existing official STEP screw into the other three exact countersunk-hole
  centers. The vendor housing and cover geometry remain unchanged.
- Made every H30 SCAD representation self-contained by embedding its exact
  tessellation as `polyhedron` data, with no mesh imports or included helpers.

## [4.1.1] - 2026-08-10

### Fixed

- Replaced the reconstructed H30 Enclosed exterior and its mechanical component
  models with direct tessellations of the unmodified official vendor STEP.
- Removed geometry that was not present in the vendor file, including the
  rounded/sloped reconstructed cover, added markings, and duplicated fasteners.
- Corrected the recorded SHA-256 provenance and used the original
  metal-housing STEP byte-for-byte as the conversion source.

### Migration

- See `MIGRATIONS/4.1.1-H30-ORIGINAL-STEP.md` for the source-preservation rule.

## [4.1.0] - 2026-08-10

### Added

- Added exact catalog components for the H30 main housing, cover, cover screw,
  and plastic damper screw.

### Changed

- Corrected H30 Enclosed to revision 1.1: centered the front USB-C opening,
  removed visible top screws, separated housing and cover, and modeled four
  concealed cover screws plus four plastic vibration-isolating screws.
- Added the `mechanical_component` model role for reusable physical assembly
  parts linked by exact catalog identifiers.

### Migration

- See `MIGRATIONS/4.1.0-H30-ENCLOSED-CORRECTION.md` for the corrected geometry
  and physical BOM.

## [4.0.0] - 2026-08-10

### Added

- Added the exact `H30 Enclosed` variant with a simplified SCAD reconstruction
  of the official 46.0 x 59.5 x 11.7 mm metal-housing STEP model.
- Added schema-versioned product-family metadata for exact variants, base-model
  relationships, revisions, BOM components, and compatibility aliases.
- Added SCAD/STL exterior representations for both H30 variants and the
  schema/validation contract for component-linked STEP interior models.

### Changed

- Renamed and relocated the previously misidentified H30WP object to the exact
  `//pub/electronics/modules/wheeltec-h30:h30-pcb` base variant.
- Replaced the package identity `wheeltec-h30wp` with the WHEELTEC H30 family.
  The website resolves the old object path as a compatibility alias.
- Expanded canonical electronic-component formats to SCAD, STL, and STEP with
  enforced exterior/interior geometry scopes.

### Migration

- See `MIGRATIONS/4.0.0-WHEELTEC-H30-FAMILY.md` for the stable-path mapping and
  official-source provenance.

## [3.1.0] - 2026-08-10

### Added

- Added `//pub/electronics/modules/wheeltec-h30wp` with a self-contained SCAD
  reference for the supplied WHEELTEC H30WP IMU PCB. The catalog source and
  visible model labels use the corrected H30WP identity; provenance and the
  unverified license status are documented with the package.

## [3.0.0] - 2026-08-10

### Removed

- Removed the sketch-only `//pub/std/metric/m` package and all 425 generated
  circle/slot object IDs. The complete stable-ID removal ledger and recovery
  path are recorded in `MIGRATIONS/3.0.0-PRUNE-EMPTY-PACKAGES.md`.
- Removed empty placeholder packages for metric NEMA interfaces, Raspberry Pi
  compute modules and microcontrollers, and the non-functional goBILDA commerce
  provider. None contained a part, assembly or usable sketch.

### Migration

- Moved the metric mating-interface templates, without their 425 catalog
  sketches, into the populated `//pub/std/metric/cqwarehouse` package and
  redirected all dependent packages and assemblies to the new namespace.
- `//pub/std/metric/standoffs` remains unchanged with its three configurable
  FF, MF and MM objects and six selectable metric size presets.

## [2.2.2] - 2026-08-10

### Fixed

- Kept the metric standoff package to exactly three useful FF, MF and MM
  objects while adding linked M2, M2.5, M3, M4, M5 and M6 size presets.
- Added finite selectable body, male-thread and female-thread dimensions for
  configurable previews instead of publishing duplicate size cards.
- Removed fabricated generic SKUs and replaced the imperial male/male example
  with metric manufacturer references and downloadable CAD families.
- Documented that the lightweight thread geometry is an envelope preview, not
  a manufacturing thread profile.

## [2.2.1] - 2026-08-10

### Fixed

- Replaced the placeholder circular geometry of all existing
  `std/metric/m:m*-slotted-*` sketches with a shared parametric CadQuery
  capsule profile while preserving every stable sketch and interface ID.
- Defined the second slot value as overall length and retained legacy
  shorter-than-diameter combinations as diameter-sized circular profiles.

## [2.2.0] - 2026-08-10

### Added

- `//pub/fpv/motors/reference-35mm`, a self-contained SCAD conversion of the
  approximately 35 mm motor found in the supplied 10-inch drone STEP assembly.
- `//pub/fpv/propellers/reference-10in`, a self-contained SCAD conversion of the
  nominal 10-inch three-blade propeller.
- `//pub/fpv/frames/10in-tube-frame`, the complete tube-frame construction with
  four arms, fourteen standoffs, plates, side panels, connectors, and mounts.
- `//pub/fpv/drones/reference-10in`, the complete available assembly containing
  the frame, four motors, and four propellers.

All four packages record the missing upstream URL and license as unverified,
retain the supplied STEP hash, and make no upstream ownership or flight-safety
claim.

## [2.1.0] - 2026-08-10

### Added

- Added `std/metric/standoffs` with parametric M2–M6 hexagonal threaded
  standoffs in female-female, male-female and male-male arrangements.
- Documented recommended ISO coarse pitches, manufacturer-specific width
  choices, dimensional limitations and MISUMI/Essentra provenance.

## [2.0.0] - 2026-08-10

### Added

- `//pub/fpv/case-holder` as the first source-free active-project pointer,
  linking to the canonical `NarysAI/Case_holder` Git repository and drawing
  checkpoint `drawing-v1.0.0`.
- Inventory schema 2, which distinguishes released packages from project
  pointers and records canonical project repositories.

### Removed

- Public package `//pub/narysai/comp-ivins-case-4` and its three legacy object
  IDs. Ongoing COMP development moves to a private standalone repository and is
  available in NarysAI only to authenticated users. The released bytes remain
  recoverable from PUB 1.3.0 and protected Git history.

### Migration

- See `MIGRATIONS/2.0.0-COMP-IVINS-CASE-4.md` for stable IDs, recovery, and the
  private replacement path.


## [1.3.0] - 2026-08-09

### Added

- Parametric KCD1-size three-position `II-O-I` rocker-switch package at
  `electromechanics/switches/kcd1-rocker`, reconstructed from orthogonal video
  views and cross-checked against the public 19 x 13 mm family drawing.
- Four-material SCAD preview layers for housing, rocker, face markings, and
  blade terminals.

## [1.2.0] - 2026-08-09

### Added

- Added `electromechanics/switches/button-a6`, a self-contained parametric
  OpenSCAD envelope of the generic red square two-terminal panel pushbutton
  reconstructed from user-provided reference videos.
- Documented the video-derived dimensional accuracy, unknown manufacturer and
  part number, unverified license status, and required physical measurements.

## [1.1.6] - 2026-08-09

### Changed

- Increased visual separation of Caddx Ratel Pro 2 components with twelve
  realistic material layers: five lens stages, transition, glass, housing,
  PCB, connector, rear components, and contacts.
- Lightened adjacent graphite shades and modeled the rear connector in light
  gray so individual components remain readable against the dark viewer.

## [1.1.5] - 2026-08-09

### Changed

- Caddx Ratel Pro 2 now declares six semantic preview materials for its lens,
  glass, housing, PCB, rear components, and gold contacts.
- The SCAD remains self-contained and can render either the complete model or
  an individual named material layer for color-preserving GLB conversion.

## [1.1.4] - 2026-08-09

### Changed

- Caddx Ratel Pro 2 migrated from STEP/F3D to a self-contained parametric SCAD
  re-render with `electronic_component` role.
- Corrected canonical-format policy to role-based SCAD or FreeCAD FCStd storage.

### Removed

- `electronics/cameras/caddx/ratel-pro-2/caddx-ratel-pro-2.step` and
  `sources/caddx-ratel-pro-2.f3d` after dimensional/render comparison. Both remain
  recoverable from PUB v1.1.3 and Git history.

## [1.1.3] - 2026-08-09

### Changed

- Canonical source policy now requires a same-stem SCAD and FreeCAD FCStd pair
  for every new or modified standalone model.
- FreeCAD is defined as the editable master and source for generated STL/STEP;
  SCAD is the parallel representation for AI processing.

## [1.1.2] - 2026-08-09

### Added

- Independently versioned policy metadata and changelog.
- Canonical source-format enforcement: SCAD for visualization/reference models
  and FreeCAD FCStd for complete manufacturable or printable parts.
- Safe legacy-format migration rules that prohibit destructive bulk deletion.

## [1.1.1] - 2026-08-09

### Added

- Normative change policy covering preservation, package structure, provenance,
  licenses, validation, website-tree parity, reviews, releases, and recovery.
- Contributor workflow, mandatory pull-request checklist, and catalog owner.
- Automated validation of the required SemVer increment against the base
  catalog inventory.

## [1.1.0] - 2026-08-09

### Added

- Five parametric EC Buying LED breakout-board envelope models: KY-009 SMD RGB,
  KY-016 DIP RGB, horizontal DIP RGB, KY-011 bi-colour, and KY-034 seven-colour.
- `electronics/modules/ec-buying` as a stable public package path.

## [1.0.0] - 2026-08-09

### Added

- First versioned inventory of all PartCAD packages, declared objects, and CAD
  assets in NarysAI PUB.
- Camera reference models under `electronics/cameras`.
- XL4015 DC-DC converter under `electronics/power-converters/xl4015`.
- Hierarchical Raspberry Pi catalog, including Raspberry Pi 5 visualization.
- CI protection against unrecorded package, object, or CAD asset changes.

### Changed

- Established stable catalog paths and Semantic Versioning rules.

### Removed

- Broken inherited PartCAD example metadata whose two LFS image objects were
  never present on GitHub. The KiCad source example and its CAD assets remain.
