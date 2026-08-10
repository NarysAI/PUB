# WHEELTEC H30 product family

AI-readable OpenSCAD reference models for two exact variants of the WHEELTEC
H30 IMU product family.

## Exact variants

| Variant | Catalog object | Description |
| --- | --- | --- |
| H30 PCB | `h30-pcb` | Bare sensor PCB and component population. |
| H30 Enclosed | `h30-enclosed` | Complete sensor with the H30 PCB inside the standard metal housing. |

`H30 Enclosed` declares `H30 PCB` as its base variant and as a quantity-one
component. The initial BOM intentionally groups the remaining supplied hardware
as one metal enclosure and two M3 cover screws; it is not a procurement BOM.

## Official geometry

The manufacturer documentation links to the public Seeed-Projects repository,
which supplies separate STEP models for the bare board and the metal-housing
sensor:

- `WHEELTEC_H30 Bare board.stp`, SHA-256
  `d2c1ebc33f8f33011f2e106c2dce1480dda9bfa64e3e167d151468e719198a64`.
- `WHEELTEC_H30 Sensor (metal housing).stp`, SHA-256
  `4f89379822580f53f651edd677c2c37ccc7c74a70b6e9cb9255d15f3e3da0208`.
- `WHEELTEC_H30 dimension diagram.pdf`, SHA-256
  `8025c79e0b8f5afe1afa9c49ff12876bb73349e8cfb3a2087d11a3bd214607c5`.

FreeCAD inspection of the official metal-housing STEP gives an overall envelope
of 46.0 x 59.5 x 11.7 mm. Its assembly contains the enclosure, H30 PCB, cover,
and two M3 screws. The enclosed SCAD model preserves that overall envelope and
component relationship with simplified AI-readable primitives rather than an
embedded STEP mesh.

`h30-pcb.scad` and `h30-enclosed.scad` are the two canonical entry sources.
Both reuse `_h30-pcb-model.scad`, a package-local helper, so the enclosed model
contains the same PCB geometry rather than a duplicated approximation.

The official bare-board STEP gives an envelope of approximately
43.9 x 31.5 x 4.9 mm including populated components. The current PCB SCAD began
as a photograph-based approximation and should be used for placement and
clearance, not fabrication or connector datum control.

## Naming and compatibility

The previous catalog object was incorrectly published as `H30WP`. It is now the
exact `H30 PCB` base variant. The old semantic path
`part/electronics/modules/wheeltec-h30wp:wheeltec-h30wp` remains a website
compatibility alias that resolves to `H30 PCB`; new links use the exact variant
path.

`H30 Enclosed` is the standard metal-housing model shown in the official STEP.
It is not the larger 63 x 55 x 24.5 mm waterproof `H30WP` product.

## License

The Seeed-Projects repository does not publish explicit reuse terms for these
mechanical files. `license_status: unverified`; NarysAI does not claim that the
official geometry or vendor markings are permissively licensed.
