# USB Type-C male cable connector

Dimensioned, AI-readable reconstruction of the generic USB Type-C male cable
connector shown in the linked GrabCAD model. It contains the metal plug, the
two-part overmould, the original smooth cylindrical wire tube, and the same
displayed cable length as one catalog object.

## Source and reconstruction method

Original reference: [USB C (type-c) male connector cable](https://grabcad.com/library/usb-c-type-c-male-connector-cable-1),
uploaded by Omri Datz on 2025-04-26. Its archive contains
`USB C Male connector cable.STEP`. The file is sign-in gated and the page does
not provide explicit redistribution terms, so the original STEP is not copied
into PUB.

This self-contained SCAD was rebuilt by measuring the original STEP assembly in
GrabCAD's orthographic 3D viewer. Point-to-point, edge, radius, and diameter
tools were used in millimetres. The old visually estimated `63.50 mm` model and
its ribbed strain relief were incorrect and have been replaced.

## Key-dimension verification

Values below are measured from the original reference and from the generated
model. All declared dimensions pass their stated tolerance.

| Key dimension | Original | Generated model | Deviation | Tolerance | Method |
|---|---:|---:|---:|---:|---|
| Overall displayed length | 48.77 mm | 48.77 mm | 0.00 mm | 0.02 mm | Viewer points / STL bounds |
| Exposed metal plug length | 7.24 mm | 7.24 mm | 0.00 mm | 0.02 mm | Viewer points / SCAD datum |
| Main housing length | 17.01 mm | 17.01 mm | 0.00 mm | 0.02 mm | Viewer points / SCAD datum |
| Main housing width | 10.65 mm | 10.65 mm | 0.00 mm | 0.02 mm | 4.95 mm edge + 2 x R2.85 mm / STL bounds |
| Main housing height | 5.70 mm | 5.70 mm | 0.00 mm | 0.02 mm | 2 x R2.85 mm / STL bounds |
| Smooth strain-relief length | 5.69 mm | 5.69 mm | 0.00 mm | 0.02 mm | Viewer points / SCAD datum |
| Smooth strain-relief diameter | 4.50 mm | 4.50 mm | 0.00 mm | 0.02 mm | Viewer diameter / STL section |
| Cable diameter | 3.30 mm | 3.30 mm | 0.00 mm | 0.02 mm | Viewer diameter / STL section |
| USB Type-C shell width | 8.25 mm | 8.25 mm | 0.00 mm | 0.05 mm | Nominal Type-C envelope, viewer cross-check |
| USB Type-C shell height | 2.40 mm | 2.40 mm | 0.00 mm | 0.03 mm | Nominal Type-C envelope, viewer cross-check |

The cable segment is `18.83 mm`, calculated so that the four consecutive source
segments total exactly `48.77 mm`.

## Intended use and limitations

Use the model for enclosure layout, port-access checks, cable clearance, and
website assembly previews. The exterior envelope and all dimensions in the
table are verified. The tongue and contact pads are deliberately simplified
visual details and must not be used to manufacture a standards-compliant plug.

## License

The original GrabCAD page does not state redistribution terms for the archive;
`license_status: unverified`. NarysAI does not redistribute that STEP file. This
package contains only the independently authored reconstruction.
