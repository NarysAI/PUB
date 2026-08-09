# KCD1 three-position rocker switch

Self-contained, AI-readable OpenSCAD reference model of a miniature black
three-position snap-in rocker switch with three blade terminals and the face
legend **II–O–I**.

## Provenance

The geometry was reconstructed on 2026-08-09 from two user-provided MP4 videos:
`video_2026-08-09_19-18-49.mp4` and
`video_2026-08-09_19-19-01.mp4`. The footage shows the principal sides of the
physical component against a metric cutting mat; the videos are not
redistributed in this package.

Orthogonal top views occur near 00:00–00:01 and 00:19.5 in the second video.
An orthogonal bottom view occurs near 00:21.5–00:22.5 in the first video.
The observed envelope and terminal layout match the KCD1 19 x 13 mm family.
Nominal dimensions and tolerances were cross-checked against the public
[KCD1-202 dimensional drawing](https://www.finglai.com/att/comp/fl-en/switches/rocker-switches/KCD1-19x13/KCD1-202-drawing.jpg).
The exact manufacturer and SKU of the photographed sample remain unconfirmed.

The OpenSCAD re-render was authored for NarysAI. It contains no imported
meshes, external libraries, or copied vendor geometry.

## Dimensions and coordinate system

The panel plane is `Z=0`. The actuator is above the panel and the housing and
terminals extend in negative Z.

| Feature | Nominal size |
| --- | ---: |
| Front bezel | 21.2 x 15.3 mm |
| Snap-in body / nominal panel cutout | 19.3 x 13.2 mm |
| Body depth below the bezel | 15.0 mm |
| Depth to the terminal tips | 20.4 mm |
| Rocker width on the short axis | 11.15 mm |
| Blade terminal section | 2.7 x 0.5 mm |

For a real panel, add clearance appropriate to the manufacturing process,
panel material, and measured sample. The nominal body size is not a universal
finished-hole tolerance.

## Accuracy and intended use

The model is intended for AI reasoning, enclosure placement, panel-layout
drafts, connector access, and clearance checks. The bezel, body, actuator,
three terminals, and snap tabs are represented parametrically. The internal
switch mechanism, terminal metallurgy, mould draft, microscopic radii, and
manufacturer-specific snap-tab profile are intentionally omitted.

The package declares four NarysAI preview materials: housing, rocker, white
markings, and metallic terminals. Material selection introduces no external
dependencies.

## License status

The SCAD source and documentation are licensed under Apache-2.0; see
`LICENSE`. The physical component's manufacturer and industrial-design terms
are unknown. NarysAI therefore reports the physical-design provenance as
`license_status: unverified`; downstream production or commercial use requires
independent dimensional and rights review.

