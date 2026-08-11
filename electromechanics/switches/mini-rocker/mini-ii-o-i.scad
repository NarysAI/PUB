// Miniature three-terminal II-O-I rocker switch reconstructed from ruler photos.
// Units: millimetres. Panel plane: Z=0; actuator is +Z; body and pins are -Z.
// Intended for panel layout, PCB placement, clearance checks and catalog preview.
// NARYS_MATERIAL: housing=#17191C
// NARYS_MATERIAL: rocker=#292C31
// NARYS_MATERIAL: markings=#F2F2EE
// NARYS_MATERIAL: terminals=#C3B899

$fn = 40;
narys_material = is_undef(narys_material) ? "all" : narys_material;

// Dimensions measured from the supplied ruler photographs and orthogonal video.
bezel_size = [15.0, 10.5];
bezel_thickness = 1.5;
bezel_corner_r = 0.35;
bezel_opening = [11.4, 7.3];

panel_cutout = [13.8, 9.2];
body_size = [13.2, 9.0];
body_depth = 10.2;
body_corner_r = 0.35;

rocker_size = [10.6, 6.5];
rocker_center_z = 3.25;
rocker_edge_z = 3.90;
rocker_thickness = 1.25;
rocker_corner_r = 0.32;
rocker_slices = 20;

terminal_column_pitch = 5.0;
terminal_thickness = 0.40;
terminal_width = 3.70;
terminal_length = 6.30;

clip_outer_span = 14.5;
clip_width = 5.2;
clip_z_top = -2.0;
clip_z_bottom = -7.8;
epsilon = 0.03;

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
    // Moulded snap tongue visible at each short end of the photographed body.
    color("#17191C")
        hull() {
            translate([
                side*(body_size.x/2 - 0.12) - 0.22,
                -clip_width/2,
                clip_z_bottom
            ]) cube([0.44, clip_width, 0.65]);
            translate([
                side*(clip_outer_span/2 - 0.22),
                -clip_width/2,
                clip_z_top
            ]) cube([0.44, clip_width, 0.65]);
        }
}

module housing() {
    color("#17191C")
        union() {
            rounded_prism(-body_depth, body_size, body_depth + 0.05, body_corner_r);
            rounded_prism(-body_depth, [body_size.x, body_size.y + 0.15], 1.0, body_corner_r);

            difference() {
                rounded_prism(0, bezel_size, bezel_thickness, bezel_corner_r);
                rounded_prism(0.25, bezel_opening, bezel_thickness, 0.25);
            }

            retention_clip(-1);
            retention_clip(1);
        }
}

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

module marking_bar(x, y=0, length=2.25, width=0.34) {
    z = rocker_surface_z(x) + 0.015;
    translate([x-width/2, y-length/2, z])
        cube([width, length, 0.10]);
}

module marking_ring(x=0, outer_d=2.05, stroke=0.34) {
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
        marking_bar(-3.75);
        marking_bar(-3.05);
        marking_ring(0);
        marking_bar(3.55);
    }
}

module terminal_blade(x, y) {
    tip_z = -body_depth-terminal_length;
    color("#C3B899")
        difference() {
            hull() {
                translate([x-terminal_thickness/2, y-(terminal_width-0.45)/2, tip_z])
                    cube([terminal_thickness, terminal_width-0.45, 0.35]);
                translate([x-terminal_thickness/2, y-terminal_width/2, tip_z+0.55])
                    cube([terminal_thickness, terminal_width, terminal_length-0.55]);
            }
            // Rectangular stamped eye visible near each free terminal end.
            translate([x-terminal_thickness, y-0.55, tip_z+0.85])
                cube([terminal_thickness*3, 1.10, 2.15]);
        }
}

module terminals() {
    for (x=[-terminal_column_pitch, 0, terminal_column_pitch])
        terminal_blade(x, 0);
}

module mini_ii_o_i() {
    if (narys_material == "all" || narys_material == "housing") housing();
    if (narys_material == "all" || narys_material == "rocker") rocker();
    if (narys_material == "all" || narys_material == "markings") markings();
    if (narys_material == "all" || narys_material == "terminals") terminals();
}

mini_ii_o_i();
