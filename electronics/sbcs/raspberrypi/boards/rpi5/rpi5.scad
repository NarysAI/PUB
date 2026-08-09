// Raspberry Pi 5 + Active Cooler — compact parametric reconstruction.
// Recreated from RASPBERRY_PI_5+cooler_v2_SIMPLIFIED.step.
// Units: millimetres. Coordinate system is identical to the STEP source:
// X = 85 mm board axis, Y = height above PCB, Z = 56 mm board axis.

// ---------- User parameters ----------
curve_fragments = 64;       // Increase for smoother circles.
show_pcb = true;
show_components = true;
show_headers = true;
show_cooler = true;

$fn = curve_fragments;
epsilon = 0.02;

pcb_size = [85, 1.6, 56];
pcb_corner_radius = 3;
mount_pad_radius = 3;
mount_hole_radii = [1.35, 1.35, 1.35, 1.30];
mount_holes = [
    [-39,  24.5],
    [ 19,  24.5],
    [ 19, -24.5],
    [-39, -24.5]
];

cooler_holes = [
    [-39,  19.0],
    [ 19, -18.6]
];

// min corner, size, RGB colour
component_boxes = [
    [[-35.50,  1.60, -20.70], [11.00, 1.60, 13.00], [0.18, 0.18, 0.20]],
    [[ 24.14, -2.11,   9.64], [21.47,17.22, 16.12], [0.72, 0.74, 0.76]],
    [[ 25.85, -2.21,  -8.77], [20.34,20.96, 15.34], [0.68, 0.70, 0.72]],
    [[ 28.39, -1.74, -26.78], [18.01,19.17, 15.45], [0.64, 0.66, 0.68]],
    [[-19.95,  1.05,  21.50], [ 6.50, 3.52,  7.50], [0.72, 0.74, 0.76]],
    [[ -6.55,  1.05,  21.50], [ 6.50, 3.52,  7.50], [0.72, 0.74, 0.76]],
    [[-35.77,  0.80,  21.29], [ 8.94, 3.96,  7.90], [0.72, 0.74, 0.76]],
    [[ 22.90,  1.50, -27.00], [ 3.61, 4.35,  6.00], [0.84, 0.78, 0.60]],
    [[-12.55,  1.50,  21.89], [ 5.00, 4.35,  3.61], [0.84, 0.78, 0.60]],
    [[-25.40,  1.50,  21.14], [ 4.00, 4.35,  3.61], [0.84, 0.78, 0.60]],
    [[-16.51,  1.59, -16.01], [14.52, 0.83, 10.02], [0.16, 0.16, 0.18]],
    [[ 17.29,  1.50,   0.31], [ 8.48, 1.10,  8.49], [0.16, 0.16, 0.18]],
    [[  9.90,  1.50, -12.95], [12.00, 0.70, 12.00], [0.16, 0.16, 0.18]],
    [[-40.90, -1.45,  -5.95], [11.40, 1.48, 11.95], [0.72, 0.74, 0.76]],
    [[-17.83,  1.60,  -3.19], [17.01, 3.38, 16.99], [0.20, 0.20, 0.22]],
    [[-34.48,  1.50,   9.64], [ 6.48, 0.60,  6.48], [0.16, 0.16, 0.18]],
    [[-41.20,  1.60,  -8.65], [ 3.50, 3.90, 13.70], [0.84, 0.78, 0.60]],
    [[  4.70,  1.60,  10.84], [ 3.50, 3.90, 16.70], [0.84, 0.78, 0.60]],
    [[ 10.90,  1.60,  10.84], [ 3.50, 3.90, 16.70], [0.84, 0.78, 0.60]],
    [[-42.39,  1.60,  13.10], [ 1.53, 1.00,  3.20], [0.85, 0.15, 0.10]],
    [[-42.65,  1.60,   7.28], [ 2.90, 3.50,  4.65], [0.30, 0.30, 0.32]]
];

// ---------- Reusable primitives ----------
module y_cylinder(position, height, radius) {
    translate(position)
        rotate([-90, 0, 0])
            cylinder(h=height, r=radius);
}

module rounded_pcb_blank() {
    hull()
        for (x = [-pcb_size.x/2 + pcb_corner_radius,
                   pcb_size.x/2 - pcb_corner_radius])
            for (z = [-pcb_size.z/2 + pcb_corner_radius,
                       pcb_size.z/2 - pcb_corner_radius])
                y_cylinder([x, 0, z], pcb_size.y, pcb_corner_radius);
}

module mounting_pad(position, hole_radius) {
    difference() {
        y_cylinder([position.x, -0.1, position.y], 1.7, mount_pad_radius);
        y_cylinder([position.x, -0.1-epsilon, position.y],
                   1.7+2*epsilon, hole_radius);
    }
}

// ---------- Raspberry Pi 5 board ----------
module pcb() {
    color([0.00, 0.42, 0.24])
        difference() {
            rounded_pcb_blank();

            // Copper mounting-pad clearances.
            for (p = mount_holes)
                y_cylinder([p.x, -epsilon, p.y],
                           pcb_size.y+2*epsilon, mount_pad_radius);

            // Two Active Cooler attachment holes.
            for (p = cooler_holes)
                y_cylinder([p.x, -epsilon, p.y],
                           pcb_size.y+2*epsilon, 1.45);

            // 40 GPIO plated-through holes, 2.54 mm pitch.
            for (column = [0:19], z = [-25.77, -23.23])
                y_cylinder([-34.13 + column*2.54, -epsilon, z],
                           pcb_size.y+2*epsilon, 0.5);
        }

    color([0.84, 0.66, 0.18])
        for (i = [0:len(mount_holes)-1])
            mounting_pad(mount_holes[i], mount_hole_radii[i]);
}

module board_components() {
    for (item = component_boxes)
        color(item[2])
            translate(item[0]) cube(item[1]);
}

module pin_header_40() {
    color([0.10, 0.10, 0.11])
        translate([-35.4, 1.6, -27.04]) cube([50.8, 2.2, 5.08]);

    color([0.86, 0.67, 0.18])
        for (column = [0:19], z = [-25.77, -23.23])
            translate([-34.13 + column*2.54 - 0.33, 3.8, z - 0.33])
                cube([0.66, 6.1, 0.66]);
}

module auxiliary_header_2x2() {
    color([0.10, 0.10, 0.11])
        translate([16.5, 1.6, 16.02]) cube([5.08, 2.2, 5.08]);

    color([0.86, 0.67, 0.18])
        for (column = [0:1], row = [0:1])
            translate([17.77 + column*2.54 - 0.33,
                       3.8,
                       17.29 + row*2.54 - 0.33])
                cube([0.66, 6.1, 0.66]);
}

// ---------- Active Cooler ----------
module fan_blades(center=[0.31, 6.175, -4.48]) {
    color([0.08, 0.08, 0.09])
        for (angle = [0:45:315])
            translate(center)
                rotate([0, angle, 0])
                    translate([9.5, 0, 0])
                        cube([5, 3.25, 1.5], center=true);
}

module fan_assembly() {
    // Square blower housing with circular inlet.
    color([0.08, 0.08, 0.09])
        difference() {
            translate([-15.19, 3.55, -19.98]) cube([31, 4.65, 31]);
            y_cylinder([0.31, 3.55-epsilon, -4.48],
                       4.65+2*epsilon, 12.4);
        }

    // Hub and eight radial blades.
    color([0.11, 0.11, 0.12])
        y_cylinder([0.31, 4.1, -4.48], 5.1, 7.2);
    fan_blades();

    // Three fan screws.
    color([0.42, 0.43, 0.45]) {
        y_cylinder([-11.19, 3.24, -17.78], 8.4, 2.2);
        y_cylinder([ 11.81, 3.24, -16.98], 8.4, 2.2);
        y_cylinder([ 11.81, 3.24,   8.02], 8.4, 2.2);
    }
}

module active_cooler() {
    // Aluminium base plate.
    color([0.66, 0.67, 0.69])
        translate([-42.2, 2.34, -20.48]) cube([63.5, 1.21, 42.5]);

    // Nine longitudinal fins, 2.55 mm pitch.
    color([0.72, 0.73, 0.75])
        for (fin = [0:8])
            translate([-39 + fin*2.55, 3.55, -19.4])
                cube([1.05, 6.7, 40.2]);

    fan_assembly();

    // Spring-loaded board fasteners.
    color([0.12, 0.12, 0.13]) {
        y_cylinder([-39.2, -1.02,  19.02], 14.27, 3.1);
        y_cylinder([ 18.8, -1.02, -18.58], 14.27, 3.1);
    }
}

module raspberry_pi_5_with_active_cooler() {
    if (show_pcb) pcb();
    if (show_components) board_components();
    if (show_headers) {
        pin_header_40();
        auxiliary_header_2x2();
    }
    if (show_cooler) active_cooler();
}

raspberry_pi_5_with_active_cooler();
