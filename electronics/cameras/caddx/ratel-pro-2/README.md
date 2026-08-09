# Caddx Ratel Pro 2

AI-readable parametric reference model for the Caddx Ratel Pro 2 FPV camera.

The catalog uses a self-contained OpenSCAD re-render classified as an
`electronic_component`. It recreates the lens stages, housing, sensor PCB,
mounting geometry, connectors, and principal rear component envelopes without
importing a STEP, STL, or other external mesh.

The re-render preserves the manufacturer STEP coordinate system and its overall
reference envelope of 20.872 x 27.500 x 19.208 mm. It is intended for AI
reasoning, placement, clearance, and enclosure design; verify critical interfaces
against a physical camera before manufacturing.

Validation against the previous STEP gives envelope deltas of 0.000013 mm (X),
0 mm (Y), and 0.000309 mm (Z). The watertight SCAD render differs in volume by
1.02%, renders through OpenSCAD in about 10 seconds, and contains no external
geometry imports.

The previous STEP and Fusion 360 files remain recoverable from PUB versions up
to v1.1.3 and Git history. They are removed from the current package after the
SCAD dimensional and rendering comparison so the package follows the canonical
electronic-component format policy.

The source archive did not include authorship or license terms. Redistribution
and downstream use must therefore be reviewed before production or commercial
use; NarysAI reports this object as `license_status: unverified`.
