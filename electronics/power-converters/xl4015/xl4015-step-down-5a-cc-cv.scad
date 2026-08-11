// Optimized exterior reference model of an XL4015 5 A CC/CV buck module.
// Units: millimetres. Coordinate system matches the retained STEP source.
$fn = 24;

board_x = 51;
board_y = 26;
board_z = 1.6;

module pcb() {
    color("#176b3a")
    difference() {
        cube([board_x, board_y, board_z]);
        for (p = [[2, 2], [2, 24], [49, 2], [49, 24]])
            translate([p[0], p[1], -0.1]) cylinder(h = board_z + 0.2, d = 2, $fn = 24);
        for (p = [[5.8, 24], [8.4, 24]])
            translate([p[0], p[1], -0.1]) cylinder(h = board_z + 0.2, d = 0.9, $fn = 18);
    }
}

module terminal_block(x, y) {
    color("#174a9c")
    difference() {
        translate([x - 3.8, y - 5.3, board_z]) cube([7.6, 10.6, 10]);
        for (dy = [-2.5, 2.5]) {
            translate([x, y + dy, 8.8]) rotate([0, 90, 0])
                cylinder(h = 8, d = 3.2, center = true, $fn = 20);
            translate([x, y + dy, 10.7]) cylinder(h = 1, d = 3.2, $fn = 20);
        }
    }
    color("#b7b9b3")
    for (dy = [-2.5, 2.5])
        translate([x, y + dy, -2.7]) cube([0.8, 0.8, 4.3], center = false);
}

module electrolytic(x, y) {
    color("#24282b") translate([x, y, board_z]) cylinder(h = 9.9, d = 10, $fn = 32);
    color("#bfc2bd") translate([x, y, 11.5]) cylinder(h = 0.6, d = 9.2, $fn = 32);
    color("#676b6b") {
        translate([x - 3.2, y - 0.18, 12.08]) cube([6.4, 0.36, 0.15]);
        translate([x - 0.18, y - 3.2, 12.08]) cube([0.36, 6.4, 0.15]);
    }
}

module trimmer(x, y) {
    color("#1856a8") translate([x - 2.4, y - 4.75, board_z]) cube([4.8, 9.5, 9.8]);
    color("#d4d6d0") translate([x, y, 11.4]) cylinder(h = 1.1, d = 3.2, $fn = 20);
    color("#666a69") translate([x - 1.15, y - 0.15, 12.45]) cube([2.3, 0.3, 0.15]);
    color("#b9b9ad") for (dy = [-2.5, 2.5])
        translate([x - 0.25, y + dy - 0.25, -1]) cube([0.5, 0.5, 2.6]);
}

module toroid_inductor() {
    color("#b76a25")
    translate([28, 5, 8.1]) rotate([90, 0, 0])
        rotate_extrude($fn = 36) translate([4.2, 0, 0]) circle(r = 2.2, $fn = 16);
}

module package_box(pos, size, body = "#25292a") {
    color(body) translate(pos) cube(size);
}

module led(x, y, c) {
    color(c) translate([x, y, board_z]) cube([2, 1.25, 0.7], center = true);
}

module xl4015_module() {
    pcb();
    terminal_block(4.7, 17.2);
    terminal_block(46.3, 8.8);
    electrolytic(9.3, 5.9);
    electrolytic(41.5, 20.0);
    trimmer(26.7, 20.7);
    trimmer(32.3, 20.7);
    toroid_inductor();

    // XL4015 regulator with exposed thermal tab.
    package_box([8.9, 12.2, board_z], [14.6, 9.8, 3.2]);
    color("#aeb1ad") translate([9.2, 17.0, 4.8]) cube([6.2, 4.5, 0.9]);
    color("#c3c5be") for (i = [0 : 4])
        translate([16.1 + i * 1.25, 12.0, board_z]) cube([0.55, 3.2, 0.35]);

    // Power diode and control electronics.
    package_box([15.0, 1.0, board_z], [6.25, 8.15, 2.65], "#303334");
    color("#bfc0b8") translate([14.7, 1.2, 2.15]) cube([0.5, 7.7, 1.5]);
    package_box([33.9, 3.5, board_z], [6.2, 5.0, 2.0]);
    package_box([29.9, 10.65, board_z], [4.0, 4.35, 1.5]);
    package_box([36.7, 11.25, board_z], [3.0, 3.1, 1.45]);

    // Status LEDs and representative small SMD passives.
    led(20.2, 23.9, "#d93030");
    led(39.8, 1.6, "#2ca25f");
    led(44.8, 1.6, "#2b6ee5");
    color("#c8b785")
    for (p = [[25, 12], [26.7, 12], [35, 17], [37, 17], [40, 12], [42, 12]])
        translate([p[0], p[1], board_z]) cube([1.1, 2.0, 0.65]);
}

xl4015_module();
