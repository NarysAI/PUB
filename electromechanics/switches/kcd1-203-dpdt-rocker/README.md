# KCD1-203-compatible six-terminal rocker switch

Self-contained OpenSCAD exterior of the photographed black three-position
`II-O-I` snap-in rocker switch. This is a separate object from the previously
published three-terminal `kcd1-rocker` package. The photographed sample has two
rows of three blade terminals and is therefore represented as a DPDT
ON-OFF-ON switch compatible with the KCD1-203 form factor.

## Provenance and identification

The geometry was reconstructed on 2026-08-11 from the user-provided videos
`video_2026-08-09_19-18-49.mp4` and `video_2026-08-09_19-19-01.mp4`, plus four
user-provided ruler photographs showing the front, base, short side and six
terminals. The media are not redistributed in this package.

The observed face legend, 19 x 13 mm snap-in body and six-terminal arrangement
match the KCD1-203 family. Nominal dimensions were cross-checked against the
public Finglai KCD1-202/KCD1-203 dimensional drawing and the KCD1-203 product
specification. The exact manufacturer and SKU printed on the photographed
sample are not legible, so the catalog identity is deliberately
`KCD1-203-compatible`, not a manufacturer claim.

## Dimensions and coordinate system

The panel plane is `Z=0`. The rocker is above the panel; the housing and
terminals extend in negative Z.

| Feature | Nominal size |
|---|---:|
| Front bezel | 21.2 x 15.3 mm |
| Snap-in body / nominal cutout | 19.3 x 13.2 mm |
| Body depth below panel | 15.0 mm |
| Depth to terminal tips | 20.4 mm |
| Rocker short dimension | 11.15 mm |
| Blade terminal section | 2.7 x 0.6 mm |
| Terminal matrix pitch | 6.35 x 6.35 mm |

Panel openings require manufacturing clearance and must be checked against the
actual sample. The six-terminal matrix and moulded side details are suitable for
clearance and wiring layout, not tooling.

## Electrical interpretation

The package represents two independent three-terminal contact groups and the
three stable `II-O-I` positions typical of KCD1-203 DPDT ON-OFF-ON switches.
The internal moving contacts are intentionally omitted. Pin continuity was not
measured from the supplied media; verify the terminal numbering and switching
truth table with a multimeter before wiring a real circuit.

## Representations and limitations

- `kcd1-203-on-off-on.scad` is the canonical, parametric, AI-readable exterior.
- `kcd1-203-on-off-on.stl` is generated from the same SCAD for interchange and
  browser delivery.
- Four NarysAI materials separate the housing, rocker, white markings and metal
  terminals in the website preview.

Microscopic mould draft, internal contacts, terminal metallurgy, certification
marks and manufacturer-specific tolerances are outside the model scope.

## License status

The authored SCAD/STL representation and documentation are licensed under
Apache-2.0; see `LICENSE`. Rights in the physical product design and markings
are unknown, so downstream physical-design provenance remains unverified.
