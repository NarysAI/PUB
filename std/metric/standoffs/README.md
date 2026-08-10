# Metric hexagonal threaded standoffs

AI-readable parametric envelope models for the three common hexagonal
threaded-standoff arrangements:

- `hex-standoff-female-female` (`FF`): internal thread at both ends;
- `hex-standoff-male-female` (`MF`): external thread at one end and internal
  thread at the other;
- `hex-standoff-male-male` (`MM`): external thread at both ends.

All dimensions are millimetres. NarysAI keeps exactly these three catalog
objects and provides a size configurator instead of creating hundreds of
nearly identical cards. Select a linked M2, M2.5, M3, M4, M5 or M6 thread
family, then choose the available body and thread-end dimensions.

## Coarse-thread presets

| Thread | Pitch | Width across flats | Default body | Default thread end |
| --- | ---: | ---: | ---: | ---: |
| M2 | 0.40 | 4.0 | 6 | 4 |
| M2.5 | 0.45 | 5.0 | 8 | 5 |
| M3 | 0.50 | 5.5 | 10 | 6 |
| M4 | 0.70 | 7.0 | 12 | 8 |
| M5 | 0.80 | 8.0 | 15 | 10 |
| M6 | 1.00 | 10.0 | 20 | 12 |

Widths and body lengths are manufacturer-specific rather than a single
universal standoff standard. Use the preset as a starting point and verify the
selected supplier drawing before using a model for tooling or procurement.

## Geometry and accuracy

The hex body, width across flats, body length, thread major diameter, pitch and
thread-end length/depth are dimensional. External helices are lightweight
cosmetic representations. Internal threads use the ISO coarse-thread core
envelope and an entrance chamfer; they are intentionally not manufacturing
thread profiles. Use a standards-compliant thread tool for fabrication.

## Provenance

The models were independently authored for NarysAI from published dimensional
families. No supplier CAD geometry was copied or redistributed. The catalog
links below provide real dimensional examples and downloadable manufacturer
CAD for comparison.

- Wuerth Elektronik WA-SBRII, metric internal/internal brass spacer studs:
  https://www.we-online.com/en/components/products/SBRII_BRASS_SPACER_STUD_METRIC_INTERNAL_INTERNAL
- Wuerth Elektronik WA-SBRIE, metric internal/external brass spacer studs:
  https://www.we-online.com/en/components/products/em/assembly/assembly_spacer_studs/spacer_studs_internal_external_thread
- MISUMI, metric hexagonal posts with FF, MF and MM arrangements:
  https://sg.misumi-ec.com/pdf/fa/2010/p1_1795.pdf

Supplier pages and drawings remain the property of their respective owners.
