# Micro HDMI Type D male cable connector

AI-readable placement and clearance model of a generic Micro HDMI Type D male
cable connector. The mating plug, overmould, strain relief, and a short cable
segment are represented as one catalog object.

## Source and authorship

Visual reference: [Micro HDMI Connector type D Cable Male](https://grabcad.com/library/micro-hdmi-connector-type-d-cable-male-1),
uploaded by Alexandre Willame on 2015-08-24. The source page describes a
SolidWorks 2015 model with STEP, IGES, and STL downloads. Downloading the archive
requires a GrabCAD account, so none of those source bytes are included here.

The SCAD model in this package is independently authored for NarysAI. Its mating
interface follows the AMTEK `MIHDMI-M19` manufacturer drawing; the GrabCAD
renders are used only for the cable-body appearance.

| Critical feature | Dimension |
| --- | ---: |
| Metal shell width | 5.83 mm |
| Metal shell height | 2.20 mm |
| Lower shell edge | 4.65 mm |
| Exposed shell length | 7.15 mm |
| Contact pitch within each row | 0.40 mm |
| Row stagger | 0.20 mm |
| Contact field span | 3.60 mm |

The Type D mating profile is asymmetric, with rounded `R0.25 mm` upper corners
and chamfered lower corners. The cable overmould, identification pad, strain
relief, and cable are explicitly non-functional visual approximations because no
dimensioned drawing for the referenced cable assembly is publicly available.

## Intended use and limitations

Use the dimensioned mating interface for enclosure openings, connector access,
and fit checks. The nineteen contacts preserve the drawing's two-row count,
pitch, stagger, and span, but the model remains a clearance/reference model and
does not define contact tooling or electrical compliance. Treat the approximate
cable body only as a visual and coarse-clearance envelope.

The optimized STL was generated directly from the self-contained SCAD and was
visually compared with the SCAD render and the GrabCAD reference images.

## License

The GrabCAD page does not provide explicit redistribution terms for the model
archive. `license_status: unverified`; NarysAI does not claim ownership of or a
permissive license for the referenced CAD files. This package does not contain
the sign-in-gated GrabCAD CAD archive.
