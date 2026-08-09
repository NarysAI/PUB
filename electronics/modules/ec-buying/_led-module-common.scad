// Parametric envelope models for EC Buying LED breakout boards.
// Units: millimetres. Origin: PCB centre, bottom face at Z=0.

$fn = 48;

module rounded_board(length, width, thickness=1.6, radius=1.0) {
    color([0.025, 0.03, 0.03])
        linear_extrude(height=thickness)
            offset(r=radius)
                square([length-2*radius, width-2*radius], center=true);
}

module board_with_holes(length, width, hole_diameter=2.2) {
    difference() {
        rounded_board(length, width);
        for (y=[-width/2+2.2, width/2-2.2])
            translate([length/2-2.2, y, -0.1])
                cylinder(h=1.8, d=hole_diameter);
    }
}

module right_angle_header(pin_count, board_length, pitch=2.54) {
    // Plastic carrier and 0.64 mm square pins extending from the PCB edge.
    color([0.035, 0.035, 0.035])
        translate([-board_length/2+1.3, 0, 2.35])
            cube([2.5, pin_count*pitch, 2.5], center=true);
    color([0.72, 0.72, 0.68])
        for (i=[0:pin_count-1]) {
            y=(i-(pin_count-1)/2)*pitch;
            translate([-board_length/2-2.3, y, 2.35])
                cube([7.2, 0.64, 0.64], center=true);
        }
}

module smd_5050() {
    color([0.92, 0.92, 0.86])
        translate([1.0, 0, 2.35]) cube([5.0, 5.0, 1.5], center=true);
    color([0.78, 0.82, 0.76])
        translate([1.0, 0, 3.15]) cube([3.4, 3.4, 0.2], center=true);
}

module vertical_f5_led() {
    color([0.88, 0.90, 0.88, 0.72]) {
        translate([1.5, 0, 1.6]) cylinder(h=6.3, d=5.0);
        translate([1.5, 0, 7.9]) sphere(d=5.0);
    }
}

module horizontal_f5_led(board_length) {
    color([0.88, 0.90, 0.88, 0.72]) {
        translate([board_length/2-0.4, 0, 3.2])
            rotate([0, 90, 0]) cylinder(h=6.2, d=5.0);
        translate([board_length/2+5.8, 0, 3.2]) sphere(d=5.0);
    }
}

module small_resistor(position=[0,0,0]) {
    color([0.2, 0.2, 0.2])
        translate(position) cube([3.2, 1.6, 0.9], center=true);
}

module led_module(
    board_length=19,
    board_width=15,
    pin_count=4,
    led_style="smd",
    resistor_count=3
) {
    board_with_holes(board_length, board_width);
    right_angle_header(pin_count, board_length);

    if (led_style == "smd") smd_5050();
    else if (led_style == "vertical") vertical_f5_led();
    else if (led_style == "horizontal") horizontal_f5_led(board_length);

    for (i=[0:resistor_count-1])
        small_resistor([board_length/2-5.0, (i-(resistor_count-1)/2)*2.2, 2.05]);
}
