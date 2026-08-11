# Miniature three-terminal II-O-I rocker switch

Self-contained OpenSCAD exterior of the black three-position snap-in rocker
switch shown in the supplied videos and ruler photographs. The physical sample
has one row of three blade terminals and a horizontal `II-O-I` face legend.

## Provenance and identification

The geometry was reconstructed on 2026-08-11 from the user-provided videos
`video_2026-08-09_19-18-49.mp4` and `video_2026-08-09_19-19-01.mp4`, plus four
ruler photographs showing the front, base, short side and three terminals. The
media are not redistributed in this package.

The manufacturer and exact part number are not legible. The 15.0 x 10.5 mm
front, 13.8 x 9.2 mm panel opening and 10.2 mm body depth are consistent with a
miniature KCD11/RS-001G-size housing. The exact manufacturer is still unknown,
so the part is cataloged generically rather than assigned an unsupported SKU.

## Dimensions and coordinate system

The panel plane is `Z=0`. The rocker is above the panel; the body and terminals
extend in negative Z.

| Feature | Nominal size |
|---|---:|
| Front bezel | 15.0 x 10.5 mm |
| Nominal panel cutout | 13.8 x 9.2 mm |
| Main body | 13.2 x 9.0 mm |
| Body depth below panel | 10.2 mm |
| Depth to terminal tips | 16.5 mm |
| Rocker face | 10.6 x 6.5 mm |
| Terminal pitch | 5.0 mm |
| Terminal blade section | 0.40 x 3.70 mm |

The bezel dimensions and three-terminal construction come directly from the
supplied photos. Hidden dimensions were cross-checked against the public
RS-001G (KCD11) housing drawing. Panel openings still require manufacturing
clearance and verification against the physical sample before production tooling.

## Electrical interpretation

Three terminals are represented as one SPDT contact group. The internal contact
mechanism is omitted. The `II-O-I` marking indicates a three-position center-off
function, but terminal continuity was not measured; verify the switching table
with a multimeter before wiring the physical part.

## Representations and limitations

- `mini-ii-o-i.scad` is the canonical parametric exterior.
- `mini-ii-o-i.stl` is generated from the same SCAD for interchange and
  browser delivery.
- Four semantic preview materials separate housing, rocker, markings and metal
  terminals.

Microscopic mould draft, internal contacts, metallurgy, certification marks and
manufacturer-specific tolerances are outside the model scope.

## License status

The authored SCAD/STL representation and documentation are licensed under
Apache-2.0; see `LICENSE`. Rights in the physical product design and markings
remain unverified.
