// KCD1-size three-position rocker switch, 3 terminals, II-O-I.
// AI-readable parametric envelope reconstructed from user-provided videos and
// cross-checked against the public KCD1 19 x 13 mm dimensional drawing.
// Units: millimetres. Panel plane: Z=0; rocker is +Z; body and pins are -Z.
// Intended for enclosure placement, panel cutouts, and clearance checks.
// NARYS_MATERIAL: housing=#17191C
// NARYS_MATERIAL: rocker=#292C31
// NARYS_MATERIAL: markings=#F2F2EE
// NARYS_MATERIAL: terminals=#B9BEC3

$fn = 64;
narys_material = is_undef(narys_material) ? "all" : narys_material;

// ---------- Principal dimensions ----------
bezel_size = [21.2, 15.3];
bezel_thickness = 2.0;
bezel_corner_r = 0.9;
bezel_top_inset = 0.8;

panel_cutout = [19.3, 13.2];
body_size = [19.3, 13.2];
body_depth = 15.0;
body_corner_r = 0.65;

rocker_size = [15.0, 11.15];
rocker_base_z = 1.55;
rocker_center_z = 4.5;
rocker_thickness = 1.35;
rocker_corner_r = 0.8;
rocker_slices = 16;

terminal_width = 2.7;
terminal_thickness = 0.5;
terminal_pitch = 5.5;
terminal_length = 5.4;
terminal_root_depth = 1.2;

clip_span = 6.4;
clip_projection = 0.95;
clip_z_top = -2.6;
clip_z_bottom = -8.0;

epsilon = 0.02;

// ---------- Reusable primitives ----------
module rounded_rect_2d(size, radius) {
    offset(r=radius)
        square([size.x - 2*radius, size.y - 2*radius], center=true);
}

module rounded_prism(z0, size, height, radius) {
    translate([0, 0, z0])
        linear_extrude(height=height)
            rounded_rect_2d(size, radius);
}

module tapered_rounded_prism(z0, lower_size, upper_size, height, radius) {
    translate([0, 0, z0])
        linear_extrude(
            height=height,
            scale=[upper_size.x/lower_size.x, upper_size.y/lower_size.y]
        )
            rounded_rect_2d(lower_size, radius);
}

// ---------- Housing and snap clips ----------
module retention_clip(side=1) {
    // Simplified spring tab on each short end of the snap-in body.
    hull() {
        translate([
            side*(body_size.x/2 - 0.25) - 0.25,
            -clip_span/2,
            clip_z_bottom
        ]) cube([0.5, clip_span, 0.7]);
        translate([
            side*(body_size.x/2 + clip_projection - 0.25) - 0.25,
            -clip_span/2,
            clip_z_top
        ]) cube([0.5, clip_span, 0.7]);
    }
}

module housing() {
    color("#17191C")
        union() {
            rounded_prism(-body_depth, body_size, body_depth, body_corner_r);

            // Bevelled front flange; maximum envelope matches the drawing.
            tapered_rounded_prism(
                0,
                bezel_size,
                bezel_size - [2*bezel_top_inset, 2*bezel_top_inset],
                bezel_thickness,
                bezel_corner_r
            );

            retention_clip(-1);
            retention_clip(1);
        }
}

// ---------- Rocker actuator ----------
function rocker_surface_z(x) =
    rocker_base_z +
    (rocker_center_z - rocker_base_z) *
    (1 - pow(abs(2*x/rocker_size.x), 2));

module rocker_slice(index) {
    slice_w = rocker_size.x / rocker_slices + epsilon;
    x = -rocker_size.x/2 + index*rocker_size.x/rocker_slices;
    z = rocker_surface_z(x);

    translate([x, 0, z - rocker_thickness])
        rounded_prism(
            0,
            [slice_w, rocker_size.y],
            rocker_thickness,
            min(rocker_corner_r, slice_w/2 - epsilon)
        );
}

module rocker() {
    color("#292C31")
        union()
            for (i=[0:rocker_slices-1])
                hull() {
                    rocker_slice(i);
                    rocker_slice(i+1);
                }
}

// ---------- II-O-I face markings ----------
module marking_bar(x, y, length=2.6, width=0.42) {
    // Raised slightly above the faceted slice interpolation so the white
    // legends remain readable in the website preview on both rocker slopes.
    z = rocker_surface_z(x) + 0.28;
    translate([x-width/2, y-length/2, z])
        cube([width, length, 0.08]);
}

module marking_ring(x, outer_d=2.45, stroke=0.42) {
    z = rocker_surface_z(x) + 0.02;
    translate([x, 0, z])
        linear_extrude(height=0.08)
            difference() {
                circle(d=outer_d);
                circle(d=outer_d-2*stroke);
            }
}

module markings() {
    color("#F2F2EE") {
        // II on the left.
        marking_bar(-5.45, 0);
        marking_bar(-4.55, 0);

        // O in the centre.
        marking_ring(0);

        // I on the right.
        marking_bar(5.0, 0);
    }
}

// ---------- Three flat blade terminals ----------
module terminal(x) {
    color("#B9BEC3")
        difference() {
            translate([
                x-terminal_width/2,
                -terminal_thickness/2,
                -body_depth-terminal_length
            ])
                cube([
                    terminal_width,
                    terminal_thickness,
                    terminal_length+terminal_root_depth
                ]);

            // Visual wiring/solder eye near the free end.
            translate([
                x-0.55,
                -terminal_thickness,
                -body_depth-terminal_length+0.8
            ])
                cube([1.1, terminal_thickness*3, 1.5]);
        }
}

module terminals() {
    for (x=[-terminal_pitch, 0, terminal_pitch]) terminal(x);
}

module kcd1_on_off_on() {
    if (narys_material == "all" || narys_material == "housing") housing();
    if (narys_material == "all" || narys_material == "rocker") rocker();
    if (narys_material == "all" || narys_material == "markings") markings();
    if (narys_material == "all" || narys_material == "terminals") terminals();
}

kcd1_on_off_on();
