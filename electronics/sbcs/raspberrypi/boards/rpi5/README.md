# /pub/electronics/sbcs/raspberrypi/boards/rpi5

Raspberry Pi 5 models.

## Parts

### rpi5

Canonical parametric OpenSCAD model of the Raspberry Pi 5 with the official
Active Cooler. The source exposes switches for the PCB, components, headers,
and cooler. STEP, STL, and other exchange formats should be generated from this
source when required instead of being maintained as independent source models.

### rpi5-active-cooler

Compatibility alias for `rpi5`.

## Local source provenance

- `rpi5.scad` was copied byte-for-byte from
  `Origins/Raspbery 5/USE/Simple/RASPBERRY_PI_5+cooler_v2_SIMPLIFIED.scad`.

Mounting interfaces and ports are intentionally not declared yet. Add them
after validating the SCAD coordinate system in PartCAD.
