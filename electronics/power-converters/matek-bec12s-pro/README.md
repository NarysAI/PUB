# Matek BEC12S-PRO DC-DC converter

Placement and clearance model of the Matek Systems BEC12S-PRO synchronous buck
regulator. The module accepts 9-55 V and provides selectable 5.2 V, 8 V, or
12 V output at up to 5 A continuous current.

## Provenance

- Manufacturer specification: [Matek Systems BEC12S-PRO](https://www.mateksys.com/?portfolio=bec12s-pro)
- Visual/CAD reference: [Livingstone Taonekwa's GrabCAD model](https://grabcad.com/library/matek-12s-pro-bec-9-55v-input-5v-8v-12v-5a-output-1), uploaded May 26, 2026
- Referenced original filename: `Matek Systems BEC12S PRO.stp`

The GrabCAD STEP archive requires an authenticated download and does not publish
redistribution terms. It is therefore not copied into PUB. The SCAD/STL bundle is
an independently authored exterior reconstruction based on the manufacturer
dimensions and public reference renderings. Its license status remains
`unverified`; review the source terms before production or commercial reuse.

## Dimensional comparison

The lower PCB face is the Z=0 datum and the board center is X=0, Y=0. Model
values are defined directly by named SCAD parameters and verified from the
generated STL bounds and pad-center coordinates.

| Dimension | Reference | Model | Deviation | Tolerance | Source / method |
| --- | ---: | ---: | ---: | ---: | --- |
| Overall length | 35.00 mm | 35.00 mm | 0.00 mm | 0.05 mm | Matek specification / STL X bounds |
| Overall width | 24.00 mm | 24.00 mm | 0.00 mm | 0.05 mm | Matek specification / STL Y bounds |
| Overall height | 5.50 mm | 5.50 mm | 0.00 mm | 0.05 mm | Matek specification / STL Z bounds |
| Input pad pitch | 3.81 mm | 3.81 mm | 0.00 mm | 0.01 mm | Matek specification / SCAD pad-center spacing |

The board outline, dominant inductor, controller package, protection devices,
capacitors, resistors, solder pads, and voltage-selection pads are represented
for recognition and coarse clearance. Component package dimensions and exact
PCB artwork are cosmetic approximations and must not be used for fabrication,
electrical design, or connector-fixture manufacture.
