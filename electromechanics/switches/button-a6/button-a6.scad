// Generic red square panel pushbutton, sample A6.
// AI-readable parametric envelope reconstructed from two user-provided videos.
// Units: millimetres. Panel plane: Z=0; actuator is +Z; body is -Z.
// Intended for placement and clearance checks, not production metrology.
// NARYS_MATERIAL: housing=#17191C
// NARYS_MATERIAL: actuator=#DF2118
// NARYS_MATERIAL: contacts=#B9BEC3

$fn = 96;
narys_material = is_undef(narys_material) ? "all" : narys_material;

// Principal envelope parameters. Values are video-derived estimates.
mounting_hole_d = 12.0;
barrel_d = 11.8;
barrel_length = 22.0;
rear_body_d = 10.5;
rear_body_length = 4.0;

flange_size = 16.0;
flange_thickness = 2.0;
flange_corner_r = 1.5;
bezel_d = 13.5;
bezel_height = 1.2;

actuator_size = 8.5;
actuator_height = 4.0;
actuator_corner_r = 1.2;

nut_across_flats = 15.0;
nut_thickness = 2.8;

terminal_spacing = 5.0;
terminal_width = 1.8;
terminal_thickness = 0.5;
terminal_length = 5.0;

// Cosmetic thread-band approximation; not a manufacturing thread definition.
thread_band_start = -13.5;
thread_band_end = -1.0;
thread_pitch = 1.5;
thread_ridge_height = 0.35;
thread_ridge_width = 0.45;

module rounded_square_2d(size, radius) {
    offset(r=radius)
        square([size - 2*radius, size - 2*radius], center=true);
}

module rounded_square_prism(z0, size, height, radius) {
    translate([0, 0, z0])
        linear_extrude(height=height)
            rounded_square_2d(size, radius);
}

module housing() {
    color("#17191C")
        union() {
            translate([0, 0, -barrel_length])
                cylinder(h=barrel_length, d=barrel_d);
            translate([0, 0, -barrel_length-rear_body_length])
                cylinder(h=rear_body_length, d=rear_body_d);

            for (z=[thread_band_start:thread_pitch:thread_band_end])
                translate([0, 0, z])
                    cylinder(h=thread_ridge_width, d=barrel_d+2*thread_ridge_height);

            translate([0, 0, -nut_thickness])
                rotate([0, 0, 30])
                    cylinder(h=nut_thickness, r=nut_across_flats/sqrt(3), $fn=6);
            rounded_square_prism(0, flange_size, flange_thickness, flange_corner_r);
            translate([0, 0, flange_thickness])
                cylinder(h=bezel_height, d=bezel_d);
        }
}

module actuator() {
    color("#DF2118")
        rounded_square_prism(
            flange_thickness+bezel_height,
            actuator_size,
            actuator_height,
            actuator_corner_r
        );
}

module contacts() {
    color("#B9BEC3")
        for (x=[-terminal_spacing/2, terminal_spacing/2])
            translate([
                x-terminal_width/2,
                -terminal_thickness/2,
                -barrel_length-rear_body_length-terminal_length
            ])
                cube([terminal_width, terminal_thickness, terminal_length]);
}

module button_a6() {
    if (narys_material == "all" || narys_material == "housing") housing();
    if (narys_material == "all" || narys_material == "actuator") actuator();
    if (narys_material == "all" || narys_material == "contacts") contacts();
}

button_a6();

