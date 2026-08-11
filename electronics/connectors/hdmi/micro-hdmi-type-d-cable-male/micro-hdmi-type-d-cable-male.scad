// Micro HDMI Type D male cable connector clearance model.
// Units: millimetres. Mating face is at X=0; cable exits toward +X.
// Independently authored for NarysAI from public interface dimensions and
// the visual reference at GrabCAD (Alexandre Willame, 2015-08-24).
$fn = 32;

plug_length = 7.0;
shell_width = 6.4;
shell_height = 2.8;

module prism_x(length, yz_points) {
    rotate([0, 90, 0])
        linear_extrude(height = length)
            polygon(points = [for (p = yz_points) [-p[1], p[0]]]);
}

module shell_profile(width, height, chamfer) {
    polygon(points = [
        [-width / 2 + chamfer, -height / 2],
        [ width / 2 - chamfer, -height / 2],
        [ width / 2, -height / 2 + chamfer],
        [ width / 2,  height / 2 - chamfer],
        [ width / 2 - chamfer,  height / 2],
        [-width / 2 + chamfer,  height / 2],
        [-width / 2,  height / 2 - chamfer],
        [-width / 2, -height / 2 + chamfer]
    ]);
}

module hdmi_shell() {
    outer = [
        [-2.65, -1.40], [2.65, -1.40], [3.20, -0.85], [3.20, 0.85],
        [2.65, 1.40], [-2.65, 1.40], [-3.20, 0.85], [-3.20, -0.85]
    ];
    inner = [
        [-2.30, -0.85], [2.30, -0.85], [2.72, -0.48], [2.72, 0.48],
        [2.30, 0.85], [-2.30, 0.85], [-2.72, 0.48], [-2.72, -0.48]
    ];

    color("#c7c9c7")
    difference() {
        prism_x(plug_length, outer);
        translate([-0.10, 0, 0]) prism_x(plug_length + 0.20, inner);
    }

    // Insulating tongue and 19 representational contacts visible at the face.
    color("#282421")
        translate([0.12, -2.28, -0.66]) cube([5.9, 4.56, 0.38]);
    color("#d7aa51")
        for (i = [0 : 18])
            translate([0.02, -2.12 + i * (4.24 / 18), -0.27])
                cube([1.10, 0.075, 0.12]);

    // Retention windows on the upper shell.
    color("#aaaead")
        for (y = [-1.45, 1.05])
            translate([3.3, y, 1.30]) cube([1.25, 0.40, 0.12]);
}

module rounded_section(x, width, height, radius) {
    for (y = [-width / 2 + radius, width / 2 - radius])
        for (z = [-height / 2 + radius, height / 2 - radius])
            translate([x, y, z]) sphere(r = radius, $fn = 24);
}

module overmould() {
    color("#18191b")
    hull() {
        rounded_section(5.8, 8.2, 4.8, 0.8);
        rounded_section(10.0, 11.5, 6.6, 1.1);
        rounded_section(24.0, 14.5, 8.4, 1.6);
        rounded_section(29.0, 11.0, 7.0, 1.3);
    }

    // Shallow top identification pad, matching the visual mass of the reference.
    color("#242629")
        translate([15.8, -3.4, 4.05]) cube([7.0, 6.8, 0.30]);
}

module strain_relief() {
    color("#151618") {
        hull() {
            rounded_section(27.5, 9.2, 6.2, 1.2);
            rounded_section(37.0, 6.8, 5.2, 1.0);
        }
        for (x = [29.5 : 2.0 : 35.5])
            translate([x, 0, 0]) rotate([0, 90, 0])
                cylinder(h = 0.65, d = 7.1, center = true, $fn = 32);
    }
}

module cable() {
    color("#111214")
        translate([36.5, 0, 0]) rotate([0, 90, 0])
            cylinder(h = 26.0, d = 4.8, $fn = 40);
}

union() {
    hdmi_shell();
    overmould();
    strain_relief();
    cable();
}
