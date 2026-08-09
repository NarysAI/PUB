# Changelog

All notable catalog changes are recorded here. The format follows Keep a
Changelog, and catalog versions follow Semantic Versioning.

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
