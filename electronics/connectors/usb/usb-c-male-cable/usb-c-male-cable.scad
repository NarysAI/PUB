// USB Type-C male cable connector reconstructed from the linked GrabCAD STEP
// assembly with its built-in millimetre measurement tools.
// Datum: mating face at X=0; cable exits toward +X on the Y=Z=0 centreline.
// NARYS_MATERIAL: metal=#C7C9CA
// NARYS_MATERIAL: overmould=#242529
// NARYS_MATERIAL: cable=#141519
// NARYS_MATERIAL: tongue=#25262A
// NARYS_MATERIAL: contacts=#D5AA55
$fn = 64;
narys_material = is_undef(narys_material) ? "all" : narys_material;

// Measured key dimensions of the original assembly (millimetres).
overall_length = 48.77;
plug_length = 7.24;
housing_length = 17.01;
housing_width = 10.65;
housing_height = 5.70;
strain_relief_length = 5.69;
strain_relief_diameter = 4.50;
cable_diameter = 3.30;
cable_length = overall_length - plug_length - housing_length - strain_relief_length; // 18.83

// USB Type-C mating envelope, cross-checked in the original viewer.
shell_width = 8.25;
shell_height = 2.40;
shell_radius = 1.20;
inner_width = 7.35;
inner_height = 1.55;
inner_radius = 0.78;

housing_start = plug_length;
relief_start = housing_start + housing_length;
cable_start = relief_start + strain_relief_length;

module rounded_rect_2d(width, height, radius) {
    hull()
        for (y = [-width / 2 + radius, width / 2 - radius])
            for (z = [-height / 2 + radius, height / 2 - radius])
                translate([y, z]) circle(r = radius);
}

module rounded_prism_x(length, width, height, radius) {
    rotate([0, 90, 0])
        linear_extrude(height = length, convexity = 10)
            // The rotation maps the 2D Y axis to world Y and 2D X to world Z.
            rounded_rect_2d(height, width, radius);
}

module cylinder_x(length, diameter) {
    rotate([0, 90, 0]) cylinder(h = length, d = diameter);
}

module usb_c_shell() {
    color("#c7c9ca")
    difference() {
        rounded_prism_x(plug_length, shell_width, shell_height, shell_radius);
        translate([-0.05, 0, 0])
            rounded_prism_x(plug_length + 0.10, inner_width, inner_height, inner_radius);
    }

}

module connector_tongue() {
    // Recognizable but non-functional tongue detail.
    color("#25262a")
        translate([0.18, -3.18, -0.27]) cube([6.86, 6.36, 0.54]);
}

module connector_contacts() {
    color("#d5aa55")
        for (side = [-1, 1])
            for (i = [0 : 11])
                translate([0.20, -2.74 + i * (5.48 / 11), side * 0.30 - 0.04])
                    cube([1.12, 0.18, 0.08]);
}

module housing() {
    // The original cover is a straight 17.01 mm capsule: 4.95 mm flat span
    // with R2.85 mm ends, giving an exact 10.65 x 5.70 mm envelope.
    color("#242529")
        translate([housing_start, 0, 0])
            rounded_prism_x(housing_length, housing_width, housing_height, housing_height / 2);

    // Subtle mould-parting seams visible on the two long sides of the original.
    color("#111216") {
        translate([housing_start + 0.10, housing_width / 2 - 0.035, -0.04])
            cube([housing_length - 0.20, 0.035, 0.08]);
        translate([housing_start + 0.10, -housing_width / 2, -0.04])
            cube([housing_length - 0.20, 0.035, 0.08]);
    }
}

module smooth_strain_relief() {
    // The source uses a smooth cylindrical wire tube, not a ribbed boot.
    color("#1b1c20")
        translate([relief_start, 0, 0])
            cylinder_x(strain_relief_length, strain_relief_diameter);
}

module cable() {
    color("#141519")
        translate([cable_start, 0, 0])
            cylinder_x(cable_length, cable_diameter);
}

union() {
    if (narys_material == "all" || narys_material == "metal") usb_c_shell();
    if (narys_material == "all" || narys_material == "overmould") {
        housing();
        smooth_strain_relief();
    }
    if (narys_material == "all" || narys_material == "cable") cable();
    if (narys_material == "all" || narys_material == "tongue") connector_tongue();
    if (narys_material == "all" || narys_material == "contacts") connector_contacts();
}
