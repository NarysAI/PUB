// Parametric metric hex standoff: female thread at both ends.
// Dimensions are millimetres. Threads are represented by ISO coarse-thread
// major/core envelopes for fast, AI-readable catalog previews.

thread_diameter = is_undef(thread_diameter) ? 3.0 : thread_diameter;
thread_pitch = is_undef(thread_pitch) ? 0.5 : thread_pitch;
body_length = is_undef(body_length) ? 10.0 : body_length;
hex_width = is_undef(hex_width) ? 5.5 : hex_width;
female_depth = is_undef(female_depth) ? 6.0 : female_depth;
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

module female_thread_envelope(depth, diameter, pitch) {
    core_diameter = max(0.2, diameter - pitch);
    union() {
        cylinder(h=depth + 0.02, d=core_diameter);
        cylinder(h=min(0.6, depth), d1=diameter + 0.35, d2=core_diameter);
    }
}

color([0.74, 0.76, 0.78])
difference() {
    hex_body(body_length, hex_width, bevel);
    translate([0, 0, -0.01])
        female_thread_envelope(min(female_depth, body_length), thread_diameter, thread_pitch);
    translate([0, 0, body_length + 0.01])
        rotate([180, 0, 0])
            female_thread_envelope(min(female_depth, body_length), thread_diameter, thread_pitch);
}
