// USB Type-C male cable connector clearance model.
// Units: millimetres. Mating face is at X=0; cable exits toward +X.
// Independently authored for NarysAI from public USB Type-C interface
// dimensions and the visual reference by Omri Datz on GrabCAD (2025-04-26).
$fn = 40;

plug_length = 6.65;
shell_width = 8.25;
shell_height = 2.40;

module rounded_rect_2d(width, height, radius) {
    hull()
        for (y = [-width / 2 + radius, width / 2 - radius])
            for (z = [-height / 2 + radius, height / 2 - radius])
                translate([y, z]) circle(r = radius);
}

module rounded_prism_x(length, width, height, radius) {
    rotate([0, 90, 0])
        linear_extrude(height = length)
            rounded_rect_2d(width, height, radius);
}

module rounded_section(x, width, height, radius) {
    for (y = [-width / 2 + radius, width / 2 - radius])
        for (z = [-height / 2 + radius, height / 2 - radius])
            translate([x, y, z]) sphere(r = radius, $fn = 28);
}

module usb_c_shell() {
    color("#c6c9c9")
    difference() {
        rounded_prism_x(plug_length, shell_width, shell_height, 1.18);
        translate([-0.10, 0, 0])
            rounded_prism_x(plug_length + 0.20, 7.35, 1.55, 0.76);
    }

    // Central insulating tongue and representational contact pads.
    color("#242326")
        translate([0.10, -3.42, -0.28]) cube([5.75, 6.84, 0.52]);
    color("#d5a84e")
        for (side = [-1, 1])
            for (i = [0 : 11])
                translate([0.02, -2.82 + i * (5.64 / 11), side * 0.27 - 0.04])
                    cube([0.95, 0.18, 0.08]);
}

module overmould() {
    color("#1b1c1f")
    hull() {
        rounded_section(5.7, 9.2, 4.2, 0.9);
        rounded_section(9.0, 11.0, 5.7, 1.25);
        rounded_section(22.5, 12.5, 6.8, 1.55);
        rounded_section(26.0, 10.2, 6.0, 1.25);
    }

    color("#25272a")
        translate([12.0, -4.5, 3.12]) cube([9.5, 9.0, 0.22]);
}

module strain_relief() {
    color("#17181a") {
        hull() {
            rounded_section(24.8, 8.5, 5.8, 1.2);
            rounded_section(34.0, 6.3, 5.1, 1.0);
        }
        for (x = [27.5 : 2.0 : 33.5])
            translate([x, 0, 0]) rotate([0, 90, 0])
                cylinder(h = 0.55, d = 6.5, center = true, $fn = 36);
    }
}

module cable() {
    color("#111214")
        translate([33.5, 0, 0]) rotate([0, 90, 0])
            cylinder(h = 30.0, d = 4.6, $fn = 40);
}

union() {
    usb_c_shell();
    overmould();
    strain_relief();
    cable();
}
