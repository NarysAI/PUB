// KCD1-203-compatible three-position rocker switch, 6 terminals, II-O-I.
// Parametric exterior reconstructed from user-provided video and ruler photos.
// Dimensions are cross-checked against the public KCD1-202/203 family drawing.
// Units: millimetres. Panel plane: Z=0; rocker is +Z; body and pins are -Z.
// Intended for panel layout, enclosure placement, wiring clearance and preview.
// NARYS_MATERIAL: housing=#17191C
// NARYS_MATERIAL: rocker=#292C31
// NARYS_MATERIAL: markings=#F2F2EE
// NARYS_MATERIAL: terminals=#B9BEC3

$fn = 48;
narys_material = is_undef(narys_material) ? "all" : narys_material;

// ---------- Principal dimensions ----------
bezel_size = [21.2, 15.3];
bezel_thickness = 2.0;
bezel_corner_r = 0.75;
bezel_opening = [17.2, 11.8];

panel_cutout = [19.3, 13.2];
body_size = [19.3, 13.2];
body_depth = 15.0;
body_corner_r = 0.55;

rocker_size = [15.4, 11.15];
rocker_edge_z = 4.65;
rocker_center_z = 3.70;
rocker_thickness = 1.55;
rocker_corner_r = 0.65;
rocker_slices = 18;

terminal_width = 2.7;
terminal_thickness = 0.6;
terminal_pitch = 6.35;
terminal_row_pitch = 6.35;
terminal_length = 5.4;
terminal_root_depth = 1.2;

clip_span = 7.0;
clip_projection = 0.60;
clip_z_top = -2.8;
clip_z_bottom = -8.4;

epsilon = 0.03;

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

module retention_clip(side=1) {
    // Spring tab visible on each end of the photographed snap-in housing.
    color("#17191C")
        union() {
            hull() {
                translate([
                    side*(body_size.x/2 - 0.35) - 0.25,
                    -clip_span/2,
                    clip_z_bottom
                ]) cube([0.5, clip_span, 0.8]);
                translate([
                    side*(body_size.x/2 + clip_projection) - 0.25,
                    -clip_span/2,
                    clip_z_top
                ]) cube([0.5, clip_span, 0.8]);
            }
            for (z=[clip_z_top-0.5:-0.75:clip_z_top-2.0])
                translate([
                    side*(body_size.x/2 + clip_projection*0.72) - 0.32,
                    -clip_span/2 + 0.45,
                    z
                ]) cube([0.64, clip_span-0.9, 0.24]);
        }
}

// ---------- Housing ----------
module housing() {
    color("#17191C")
        union() {
            // Main moulding and slightly thicker terminal/base rail.
            rounded_prism(-body_depth, body_size, body_depth+0.15, body_corner_r);
            rounded_prism(-body_depth, [body_size.x, body_size.y+0.25], 1.55, body_corner_r);

            // Front flange is a frame, leaving the real clearance around the key.
            difference() {
                rounded_prism(0, bezel_size, bezel_thickness, bezel_corner_r);
                rounded_prism(0.35, bezel_opening, bezel_thickness, 0.55);
            }

            retention_clip(-1);
            retention_clip(1);
        }
}

// ---------- Concave rocker actuator ----------
function rocker_surface_z(x) =
    rocker_center_z +
    (rocker_edge_z - rocker_center_z) * pow(abs(2*x/rocker_size.x), 2);

module rocker_slice(index) {
    slice_w = rocker_size.x / rocker_slices + epsilon;
    x = -rocker_size.x/2 + index*rocker_size.x/rocker_slices;
    z = rocker_surface_z(x);
    translate([x, 0, z-rocker_thickness])
        rounded_prism(
            0,
            [slice_w, rocker_size.y],
            rocker_thickness,
            min(rocker_corner_r, slice_w/2-epsilon)
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
module marking_bar(x, length=2.65, width=0.43) {
    z = rocker_surface_z(x) + 0.015;
    translate([x-width/2, -length/2, z])
        cube([width, length, 0.10]);
}

module marking_ring(x=0, outer_d=2.5, stroke=0.43) {
    z = rocker_surface_z(x) + 0.015;
    translate([x, 0, z])
        linear_extrude(height=0.10)
            difference() {
                circle(d=outer_d);
                circle(d=outer_d-2*stroke);
            }
}

module markings() {
    color("#F2F2EE") {
        marking_bar(-5.15);
        marking_bar(-4.22);
        marking_ring();
        marking_bar(4.85);
    }
}

// ---------- Six stamped blade terminals ----------
module terminal_blade(x, y) {
    z0 = -body_depth-terminal_length;
    color("#B9BEC3")
        difference() {
            hull() {
                translate([x-(terminal_width-0.45)/2, y-terminal_thickness/2, z0])
                    cube([terminal_width-0.45, terminal_thickness, 0.35]);
                translate([x-terminal_width/2, y-terminal_thickness/2, z0+0.55])
                    cube([terminal_width, terminal_thickness, terminal_length+terminal_root_depth-0.55]);
            }
            // Stamped solder/connector eye near the free end.
            translate([x-0.55, y-terminal_thickness, z0+0.85])
                cube([1.10, terminal_thickness*3, 1.55]);
        }
}

module terminals() {
    for (y=[-terminal_row_pitch/2, terminal_row_pitch/2])
        for (x=[-terminal_pitch, 0, terminal_pitch])
            terminal_blade(x, y);
}

module kcd1_203_on_off_on() {
    if (narys_material == "all" || narys_material == "housing") housing();
    if (narys_material == "all" || narys_material == "rocker") rocker();
    if (narys_material == "all" || narys_material == "markings") markings();
    if (narys_material == "all" || narys_material == "terminals") terminals();
}

kcd1_203_on_off_on();
