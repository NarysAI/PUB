// Parametric metric hex standoff: male thread at both ends.
// Dimensions are millimetres. External helices are cosmetic; major diameter,
// pitch and overall envelopes are dimensional.

thread_diameter = is_undef(thread_diameter) ? 3.0 : thread_diameter;
thread_pitch = is_undef(thread_pitch) ? 0.5 : thread_pitch;
body_length = is_undef(body_length) ? 10.0 : body_length;
hex_width = is_undef(hex_width) ? 5.5 : hex_width;
male_length = is_undef(male_length) ? 6.0 : male_length;
bevel = is_undef(bevel) ? 0.25 : bevel;

$fn = 48;

module hex_body(length, width, edge_bevel) {
    radius = width / sqrt(3);
    safe_bevel = min(edge_bevel, length / 4);
    union() {
        cylinder(h=safe_bevel, r1=radius - safe_bevel, r2=radius, $fn=6);
        translate([0, 0, safe_bevel])
            cylinder(h=length - 2 * safe_bevel, r=radius, $fn=6);
        translate([0, 0, length - safe_bevel])
            cylinder(h=safe_bevel, r1=radius, r2=radius - safe_bevel, $fn=6);
    }
}

module external_thread(length, diameter, pitch) {
    core_diameter = max(0.2, diameter - 0.65 * pitch);
    ridge_height = (diameter - core_diameter) / 2;
    cylinder(h=length, d=core_diameter);
    linear_extrude(
        height=length,
        twist=360 * length / pitch,
        slices=max(16, ceil(length / pitch) * 12),
        convexity=12
    )
        translate([core_diameter / 2 - 0.01, 0, 0])
            polygon(points=[[0, -0.32 * pitch], [ridge_height, 0], [0, 0.32 * pitch]]);
}

color([0.74, 0.76, 0.78])
union() {
    hex_body(body_length, hex_width, bevel);
    rotate([180, 0, 0])
        external_thread(male_length, thread_diameter, thread_pitch);
    translate([0, 0, body_length])
        external_thread(male_length, thread_diameter, thread_pitch);
}
