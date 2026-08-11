// Optimized exterior reference model of the distinct GrabCAD XL4015-1 module.
// Units: millimetres. Envelope follows the linked UNIT Electronics product.
// NARYS_MATERIAL: pcb=#1479C9
// NARYS_MATERIAL: metal=#BFC4C8
// NARYS_MATERIAL: black=#25282A
// NARYS_MATERIAL: copper=#B86832
// NARYS_MATERIAL: blue=#1768B2
$fn = 32;

board_x = 55;
board_y = 25;
board_z = 1.6;

module pcb() {
    color("#1479c9")
    difference() {
        cube([board_x, board_y, board_z]);
        for (p = [[2, 2], [2, 23], [53, 2], [53, 23]])
            translate([p[0], p[1], -0.1]) cylinder(h = board_z + 0.2, d = 2.6);
        for (p = [[9, 20.5], [46, 4.5]])
            translate([p[0], p[1], -0.1]) cylinder(h = board_z + 0.2, d = 4.8);
        for (p = [[4.2, 17], [4.2, 20], [50.8, 5], [50.8, 8]])
            translate([p[0], p[1], -0.1]) cylinder(h = board_z + 0.2, d = 1.2, $fn = 18);
    }
}

module plated_hole(x, y, diameter) {
    color("#bfc4c8")
    difference() {
        translate([x, y, board_z]) cylinder(h = 0.18, d = diameter + 1.4);
        translate([x, y, board_z - 0.1]) cylinder(h = 0.4, d = diameter);
    }
}

module electrolytic(x, y) {
    color("#25282a") translate([x, y, board_z]) cylinder(h = 12.85, d = 10.2);
    color("#bfc4c8") translate([x, y, board_z + 12.85]) cylinder(h = 0.55, d = 9.6);
    color("#676b6b") {
        translate([x - 3.1, y - 0.18, board_z + 13.39]) cube([6.2, 0.36, 0.12]);
        translate([x - 0.18, y - 3.1, board_z + 13.39]) cube([0.36, 6.2, 0.12]);
    }
}

module toroid(x, y) {
    color("#b86832")
    translate([x, y, board_z + 2.4])
        rotate_extrude($fn = 40)
            translate([5.0, 0]) circle(r = 2.0, $fn = 18);
    color("#355a38")
    translate([x, y, board_z + 2.2])
        difference() {
            cylinder(h = 4.1, d = 8.4);
            translate([0, 0, -0.1]) cylinder(h = 4.3, d = 4.6);
        }
}

module trimmer(x, y) {
    color("#1768b2") translate([x - 6, y - 2.5, board_z]) cube([12, 5, 5.8]);
    color("#c7a55d") translate([x, y - 2.65, board_z + 3.1])
        rotate([90, 0, 0]) cylinder(h = 1.2, d = 2.1, $fn = 20);
}

module power_ic() {
    color("#25282a") translate([10.5, 13.2, board_z]) cube([12.5, 8.3, 3.1]);
    color("#bfc4c8") translate([10.5, 18.1, board_z + 2.8]) cube([6.3, 3.4, 0.7]);
    color("#bfc4c8")
    for (i = [0 : 4])
        translate([17.2 + i * 1.15, 12.5, board_z]) cube([0.5, 2.6, 0.35]);
}

module diode() {
    color("#303335") translate([34.4, 2.7, board_z]) cube([7.2, 5.4, 2.5]);
    color("#bfc4c8") translate([34.0, 3.0, board_z + 0.6]) cube([0.55, 4.8, 1.4]);
}

module smd(x, y, sx = 1.5, sy = 2.3, body = "#c8b785") {
    color(body) translate([x, y, board_z]) cube([sx, sy, 0.75]);
}

module xl4015_1_module() {
    pcb();
    for (p = [[2, 2, 2.6], [2, 23, 2.6], [53, 2, 2.6], [53, 23, 2.6],
              [9, 20.5, 4.8], [46, 4.5, 4.8]])
        plated_hole(p[0], p[1], p[2]);

    // The XL4015-1 layout has no screw-terminal blocks. Its two capacitors sit
    // near opposite ends, with a central flat toroidal inductor.
    electrolytic(8.5, 8.0);
    electrolytic(46.0, 16.8);
    toroid(29.0, 10.3);
    trimmer(29.5, 20.0);
    power_ic();
    diode();

    color("#e0bd35") translate([22.0, 19.2, board_z]) cube([2.0, 3.0, 1.6]);
    smd(23.5, 3.5, 2.0, 1.3, "#25282a");
    smd(39.2, 18.7, 1.3, 2.0, "#25282a");
    smd(42.0, 19.0, 1.1, 1.8);
    smd(14.0, 8.2, 1.2, 2.1);
    smd(43.0, 8.4, 1.2, 2.1);
}

xl4015_1_module();
