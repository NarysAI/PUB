// Matek Systems BEC12S-PRO placement and clearance model.
// Units: millimetres. PCB lower face is Z=0; board center is X=0, Y=0.
// Overall envelope and input-pad pitch follow the manufacturer specification.
// Component placement is an exterior approximation of public GrabCAD renderings.
$fn = 40;

board_length = 35.0;
board_width = 24.0;
board_thickness = 1.2;
overall_height = 5.5;
corner_radius = 1.0;
input_pad_pitch = 3.81;

assert(board_length == 35.0);
assert(board_width == 24.0);
assert(overall_height == 5.5);
assert(input_pad_pitch == 3.81);

module rounded_box_xy(size, radius) {
    linear_extrude(height = size[2])
        hull()
            for (x = [-size[0] / 2 + radius, size[0] / 2 - radius])
                for (y = [-size[1] / 2 + radius, size[1] / 2 - radius])
                    translate([x, y]) circle(r = radius);
}

module body_box(pos, size, colour) {
    color(colour)
        translate([pos[0] - size[0] / 2, pos[1] - size[1] / 2, pos[2]])
            cube(size);
}

module smd_pad(pos, size = [2.8, 2.8]) {
    color("#d9dadd")
        translate([pos[0], pos[1], board_thickness])
            cylinder(h = 0.12, d = size[0]);
    color("#25313b")
        translate([pos[0], pos[1], board_thickness + 0.11])
            cylinder(h = 0.03, d = 1.1);
}

module chip(pos, size, height = 0.75) {
    body_box([pos[0], pos[1], board_thickness], [size[0], size[1], height], "#17191d");
}

module capacitor(pos, size, height = 1.2) {
    body_box([pos[0], pos[1], board_thickness], [size[0], size[1], height], "#c5a77f");
    body_box([pos[0] - size[0] / 2 + 0.12, pos[1], board_thickness + 0.03], [0.24, size[1] + 0.05, height - 0.06], "#d9dadd");
    body_box([pos[0] + size[0] / 2 - 0.12, pos[1], board_thickness + 0.03], [0.24, size[1] + 0.05, height - 0.06], "#d9dadd");
}

module bec12s_pro() {
    // PCB: the rounded outline preserves the exact 35 x 24 mm bounding box.
    color("#145ad3") rounded_box_xy([board_length, board_width, board_thickness], corner_radius);

    // Four input/output wire pads on the left, at the specified 3.81 mm pitch.
    for (i = [-1.5 : 1 : 1.5]) smd_pad([-15.3, i * input_pad_pitch]);

    // Dominant 100-marked inductor controls the specified total height.
    body_box([-1.6, -2.8, board_thickness], [9.2, 9.2, overall_height - board_thickness], "#68696b");
    body_box([-1.6, -2.8, overall_height - 0.18], [8.4, 8.4, 0.18], "#77787a");

    // High-side power stage and protection components.
    chip([-10.7, 5.6], [5.8, 3.2], 1.25);
    capacitor([-8.1, 8.6], [2.6, 3.0], 1.55);
    capacitor([-11.0, 8.4], [2.6, 3.0], 1.55);
    chip([-5.8, 5.2], [4.1, 3.2], 1.15);
    chip([-8.4, 0.7], [5.4, 2.7], 1.0);
    capacitor([-12.0, -4.0], [1.7, 2.3], 0.8);
    capacitor([-10.0, -4.0], [1.7, 2.3], 0.8);
    capacitor([-8.0, -4.0], [1.7, 2.3], 0.8);
    capacitor([-6.0, -4.0], [1.7, 2.3], 0.8);

    // Control IC and its surrounding small passives.
    chip([7.8, 2.2], [7.2, 5.5], 1.25);
    for (y = [-0.8 : 1.0 : 5.2]) {
        capacitor([3.9, y], [1.0, 0.55], 0.45);
        capacitor([11.7, y], [1.0, 0.55], 0.45);
    }
    chip([5.2, 7.0], [3.4, 2.0], 0.85);
    capacitor([1.9, 7.4], [1.7, 1.2], 0.75);
    capacitor([0.1, 7.4], [1.4, 1.0], 0.65);
    chip([12.5, 6.6], [2.2, 1.2], 0.65);
    chip([14.3, 4.3], [1.8, 1.0], 0.55);
    chip([13.2, 1.8], [2.0, 1.0], 0.55);
    chip([12.8, -1.3], [2.0, 1.0], 0.55);

    // Enable and selectable 5.2/8/12 V solder pads.
    for (x = [8.6, 12.0, 15.0])
        body_box([x, -9.5, board_thickness], [2.2, 1.5, 0.12], "#d9dadd");
    body_box([3.4, -9.5, board_thickness], [2.1, 1.4, 0.12], "#d9dadd");
}

bec12s_pro();
