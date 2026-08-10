# Metric hexagonal threaded standoffs

AI-readable, parametric envelope models for the three common hexagonal
threaded-standoff arrangements:

- `hex-standoff-female-female` (`FF`): internal thread at both ends;
- `hex-standoff-male-female` (`MF`): external thread at one end and internal
  thread at the other;
- `hex-standoff-male-male` (`MM`): external thread at both ends.

All dimensions are millimetres. Each model exposes thread diameter and pitch,
hex width across flats, body length, end-thread length/depth and edge bevel.
The declared range covers the common M2, M2.5, M3, M4, M5 and M6 families.

## Recommended coarse-thread presets

| Thread | Pitch | Typical width across flats |
| --- | ---: | ---: |
| M2 | 0.40 | 4.0 |
| M2.5 | 0.45 | 5.0 |
| M3 | 0.50 | 5.5 or 6.0 |
| M4 | 0.70 | 7.0 or 8.0 |
| M5 | 0.80 | 8.0 or 10.0 |
| M6 | 1.00 | 10.0 or 12.0 |

Widths and body lengths are manufacturer-specific rather than a single
universal standoff standard. Set the parameters to the selected supplier's
drawing before using a model for interference or tooling decisions.

## Geometry and accuracy

The hex body, width across flats, body length, thread major diameter, pitch and
thread-end length/depth are dimensional. External helices are lightweight
cosmetic representations. Internal threads use the ISO coarse-thread core
envelope and an entrance chamfer; they are intentionally not manufacturing
thread profiles. Use a standards-compliant thread tool for fabrication.

## Provenance

The models were independently authored for NarysAI from published dimensional
families. No supplier CAD geometry was copied or redistributed.

- MISUMI, *Hexagonal Posts — Both Ends Female Thread*, catalogue pp. 1187–1188:
  https://uk.misumi-ec.com/pdf/fa/p1187.pdf
- MISUMI, *Hexagonal Posts — One End Male, One End Female Thread*, catalogue
  pp. 1189–1190: https://uk.misumi-ec.com/pdf/fa/p1189.pdf
- Essentra, male-to-male hexagonal M4 example HSM4-8-32-3:
  https://www.essentracomponents.com/en-ca/p/male-to-male-standoff-hexagonal-insulator-nylon-brass/hsm4-8-32-3
- Essentra, male-to-female M3 example 1221465:
  https://www.essentracomponents.com/en-gb/p/standoffs/1221465
- Essentra, female-to-female M3 example MTNSP-M3-10-1:
  https://www.essentracomponents.com/en-us/p/female-to-female-standoff-hexagonal-bottom-metric-threaded-insulator-nylon-brass/mtnsp-m3-10-1

Source-code license: Apache-2.0 under the repository contribution terms.
Supplier pages and drawings remain the property of their respective owners.
