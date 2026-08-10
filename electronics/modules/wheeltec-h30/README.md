# WHEELTEC H30 product family

AI-readable OpenSCAD reference models for two exact variants of the WHEELTEC
H30 IMU product family.

## Exact variants

| Variant | Catalog object | Description |
| --- | --- | --- |
| H30 PCB | `h30-pcb` | Bare sensor PCB and component population. |
| H30 Enclosed | `h30-enclosed` | Complete sensor with the H30 PCB inside the standard metal housing. |

`H30 Enclosed` revision 1.3 declares `H30 PCB` as its base variant and records
the corrected physical composition: one main housing, one separate cover, four
concealed cover screws, and four plastic vibration-isolating mounting screws.
Every one of these component types is now an exact linked catalog object.

## Official geometry

The manufacturer documentation links to the public Seeed-Projects repository,
which supplies separate STEP models for the bare board and the metal-housing
sensor:

- `WHEELTEC_H30 Bare board.stp`, SHA-256
  `42686f67073fbf4bd2322039b7c5ac93042d12d1a496909862a605b38ddcc851`.
- `WHEELTEC_H30 Sensor (metal housing).stp`, SHA-256
  `54f4665afd6962b4bbeb4bd7445c316438f05d08454fff7590fdc6ad6ae3aa8d`.
- `WHEELTEC_H30 dimension diagram.pdf`, SHA-256
  `321731f3080dab8aa0cf63b04987b37ce743b686bdbb936e362a99cc1a47d979`.

FreeCAD inspection of the official metal-housing STEP gives an overall envelope
of 46.0 x 59.5 x 11.7 mm. The source assembly is incomplete: it contains only
one instance of each mounting fastener even though the physical product uses
four of each. Revision 1.4 leaves the vendor housing and cover unchanged and
copies the existing M3x4 STEP screw into the three empty cover-hole centers, so
all four cover screws are present. The `4 + 4` physical quantities remain in
the catalog BOM.

`WHEELTEC_H30 Sensor (metal housing).stp` is used byte-for-byte from the official
repository as the conversion input. `h30-enclosed.stl` is an exterior-only
FreeCAD tessellation containing the vendor housing, cover, and four cover
screws. The PCB and other hidden STEP objects are intentionally omitted. No
visible housing, cover, connector, hole, screw, or marking geometry is
remodeled or repositioned. Every SCAD representation embeds the corresponding
exact tessellation as `polyhedron` data and is self-contained:
there are no `import`, `include`, or external-file dependencies. The housing,
cover, and two fastener component files are direct tessellations of the
corresponding individual STEP objects.

SCAD and STL are explicitly marked `geometry_scope: exterior`. A future STEP
representation is `geometry_scope: interior` and is accepted only when every
component exists as an exact catalog object and its STEP name contains
`narys:<kind>/<semantic_path>`. The unchanged vendor STEP is referenced by its
official URL and SHA-256 rather than declared as a canonical STEP
representation: its internal product names do not yet contain those
identifiers. Altering those names would change the vendor file and violate the
source-preservation rule.

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
