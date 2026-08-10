"""Parametric capsule-shaped metric slot for PartCAD.

``diameter`` is the slot width and ``length`` is the overall end-to-end
length.  A requested length shorter than the diameter is clamped to the
diameter, producing the smallest valid slot: a circle.
"""

import cadquery as cq


diameter = 1.0
length = 1.5

safe_diameter = max(float(diameter), 0.001)
safe_length = max(float(length), safe_diameter)
straight_length = safe_length - safe_diameter

if straight_length <= 1e-9:
    profile = cq.Sketch().circle(safe_diameter / 2.0)
else:
    profile = (
        cq.Sketch()
        .rect(straight_length, safe_diameter)
        .push([(-straight_length / 2.0, 0.0), (straight_length / 2.0, 0.0)])
        .circle(safe_diameter / 2.0, mode="a")
    )

result = cq.Workplane("XY").placeSketch(profile)
show_object(result)
