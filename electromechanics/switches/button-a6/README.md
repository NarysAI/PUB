# Button A6

Self-contained, AI-readable OpenSCAD reference model of the generic red square
two-terminal panel pushbutton labelled **A6** in the source footage.

## Provenance

The geometry was reconstructed on 2026-08-09 from two user-provided MP4 videos:
`video_2026-08-09_19-18-13.mp4` and `video_2026-08-09_19-18-45.mp4`. The videos
show all principal sides of the physical component against a metric cutting mat;
they are not redistributed in this package. Manufacturer and exact part number
are unknown. The visible construction is consistent with a generic PBS-110-style
momentary panel pushbutton, but that identification is not treated as confirmed.

The OpenSCAD re-render was authored for NarysAI as a dimensional reference model.
It contains no imported meshes, external libraries, or copied vendor geometry.

## Accuracy and intended use

The model is intended for AI reasoning, enclosure placement, panel-layout drafts,
and clearance checks. It is not a production drawing. The nominal mounting hole
is 12.0 mm and the generated model envelope is approximately
17.32 x 16.00 x 38.20 mm. Most dimensions were estimated from perspective video
against the cutting-mat grid and should be verified on the physical component.

Critical dimensions still requiring calliper measurement are the thread diameter
and pitch, front-flange size, body depth behind the panel, and terminal spacing.
The external thread is represented by simple circumferential bands for visual and
clearance purposes; it is not a manufacturable thread profile.

The source declares three NarysAI preview materials: black housing, red actuator,
and metallic contacts. Material selection does not introduce external dependencies.

## License status

The physical component's manufacturer, part number, and design-license terms are
unknown. Redistribution and commercial use therefore require independent review;
NarysAI reports this package as `license_status: unverified`.

