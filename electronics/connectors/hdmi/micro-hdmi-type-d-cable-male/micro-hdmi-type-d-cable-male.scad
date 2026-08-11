// Micro HDMI Type D male cable connector reference model.
// Units: millimetres. Mating face is at X=0; cable exits toward +X.
// The mating interface follows the AMTEK MIHDMI-M19 manufacturer drawing.
// The cable body is a non-functional visual approximation of the GrabCAD
// reference by Alexandre Willame (2015-08-24).
$fn = 48;

plug_length = 7.15;
shell_width = 5.83;
shell_height = 2.20;
shell_lower_width = 4.65;
upper_corner_radius = 0.25;
contact_pitch = 0.40;
contact_stagger = 0.20;
contact_field_span = 3.60;

assert(shell_width == 5.83);
assert(shell_height == 2.20);
assert(shell_lower_width == 4.65);
assert(plug_length == 7.15);
assert(contact_pitch * 9 == contact_field_span);

module prism_x(length, yz_points) {
    rotate([0, 90, 0])
        linear_extrude(height = length)
            polygon(points = [for (p = yz_points) [-p[1], p[0]]]);
}

function type_d_outer_points() = concat(
    [[-shell_lower_width / 2, -shell_height / 2],
     [ shell_lower_width / 2, -shell_height / 2],
     [ shell_width / 2, -0.28],
     [ shell_width / 2, shell_height / 2 - upper_corner_radius]],
    [for (a = [0 : 5 : 90])
        [shell_width / 2 - upper_corner_radius + upper_corner_radius * cos(a),
         shell_height / 2 - upper_corner_radius + upper_corner_radius * sin(a)]],
    [[-shell_width / 2 + upper_corner_radius, shell_height / 2]],
    [for (a = [90 : 5 : 180])
        [-shell_width / 2 + upper_corner_radius + upper_corner_radius * cos(a),
          shell_height / 2 - upper_corner_radius + upper_corner_radius * sin(a)]],
    [[-shell_width / 2, -0.28]]
);

function type_d_inner_points() = [
    [-1.95, -0.72], [1.95, -0.72], [2.46, -0.10], [2.46, 0.62],
    [2.25, 0.83], [-2.25, 0.83], [-2.46, 0.62], [-2.46, -0.10]
];

module metal_shell() {
    difference() {
        prism_x(plug_length, type_d_outer_points());
        translate([-0.10, 0, 0])
            prism_x(plug_length + 0.20, type_d_inner_points());
    }
}

module hdmi_shell() {
    color("#c7c9c7")
        metal_shell();

    // Drawing-controlled 3.90 mm tongue and staggered 10 + 9 contact rows.
    color("#282421")
        translate([0.12, -1.95, -0.42]) cube([5.9, 3.90, 0.30]);
    color("#d7aa51") {
        for (i = [0 : 9])
            translate([0.02, -contact_field_span / 2 + i * contact_pitch - 0.055, -0.08])
                cube([1.10, 0.11, 0.08]);
        for (i = [0 : 8])
            translate([0.02, -contact_field_span / 2 + contact_stagger + i * contact_pitch - 0.055, -0.30])
                cube([1.10, 0.11, 0.08]);
    }

    // Retention windows on the upper shell.
    color("#aaaead")
        for (y = [-1.45, 1.05])
            translate([3.3, y, 0.92]) cube([1.25, 0.40, 0.10]);
}

module rounded_section(x, width, height, radius) {
    for (y = [-width / 2 + radius, width / 2 - radius])
        for (z = [-height / 2 + radius, height / 2 - radius])
            translate([x, y, z]) sphere(r = radius, $fn = 24);
}

module overmould() {
    color("#18191b")
    hull() {
        rounded_section(5.8, 7.6, 4.8, 0.8);
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

render_target = is_undef(render_target) ? "full" : render_target;

if (render_target == "mating_shell" || render_target == 1) {
    metal_shell();
} else {
    union() {
        hdmi_shell();
        overmould();
        strain_relief();
        cable();
    }
}
