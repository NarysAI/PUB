/*
  WHEELTEC H30 metal enclosure family geometry.
  Overall envelope without damper heads: 46.0 x 59.5 x 11.7 mm.
  Origin: center of mounting base, bottom face.
*/

include <_h30-pcb-model.scad>

enclosure_width = 46.0;
enclosure_length = 59.5;
enclosure_height = 11.7;
body_length = 43.3;
base_thickness = 2.0;
cover_height = 2.2;
corner_radius = 2.4;
mount_hole_diameter = 3.4;
mount_hole_x = 17.0;
mount_hole_y = 26.0;
wall_thickness = 1.8;

module h30_rounded_rect(size=[10, 10], radius=1) {
    offset(r=radius)
        square([size[0]-2*radius, size[1]-2*radius], center=true);
}

module h30_rounded_plate(size=[10, 10], height=1, radius=1) {
    linear_extrude(height=height)
        h30_rounded_rect(size, radius);
}

module h30_mounting_base() {
    difference() {
        h30_rounded_plate(
            [enclosure_width, enclosure_length],
            base_thickness,
            corner_radius
        );
        for (x=[-mount_hole_x, mount_hole_x], y=[-mount_hole_y, mount_hole_y])
            translate([x, y, -0.1])
                cylinder(d=mount_hole_diameter, h=base_thickness+0.2, $fn=40);
    }
}

module h30_main_housing() {
    lower_height = enclosure_height-cover_height-base_thickness;
    union() {
        h30_mounting_base();
        translate([0, 0, base_thickness])
            difference() {
                h30_rounded_plate(
                    [enclosure_width, body_length],
                    lower_height,
                    corner_radius
                );
                translate([0, 0, wall_thickness])
                    h30_rounded_plate(
                        [enclosure_width-2*wall_thickness,
                         body_length-2*wall_thickness],
                        lower_height,
                        max(0.8, corner_radius-wall_thickness)
                    );
                // USB-C opening centered on the front long wall.
                translate([0, -body_length/2-0.2, 2.5])
                    rotate([-90, 0, 0])
                        hull() {
                            translate([-3.8, 0, 0]) cylinder(d=3.2, h=wall_thickness+0.4, $fn=30);
                            translate([ 3.8, 0, 0]) cylinder(d=3.2, h=wall_thickness+0.4, $fn=30);
                        }
            }
    }
}

module h30_cover() {
    z0 = enclosure_height-cover_height;
    // The original enclosure has a smaller flat top and sloped shoulders.
    translate([0, 0, z0])
        hull() {
            h30_rounded_plate([enclosure_width, body_length], 0.35, corner_radius);
            translate([0, 0, cover_height-0.35])
                h30_rounded_plate([40.0, 36.0], 0.35, 1.8);
        }
}

module h30_cover_screw() {
    union() {
        cylinder(d=4.8, h=1.0, $fn=36);
        translate([0, 0, 0.8]) cylinder(d=2.8, h=5.4, $fn=30);
    }
}

module h30_four_cover_screws() {
    // Four screws enter from the underside and do not appear on the top cover.
    for (x=[-18.0, 18.0], y=[-16.0, 16.0])
        translate([x, y, 0.25]) h30_cover_screw();
}

module h30_plastic_damper_screw() {
    // Simplified nylon isolation screw: lower head, shank, upper retaining head.
    union() {
        cylinder(d=6.4, h=1.2, $fn=40);
        translate([0, 0, 0.8]) cylinder(d=3.0, h=3.0, $fn=32);
        translate([0, 0, 2.9]) cylinder(d1=5.8, d2=4.8, h=1.0, $fn=40);
    }
}

module h30_four_plastic_dampers() {
    for (x=[-mount_hole_x, mount_hole_x], y=[-mount_hole_y, mount_hole_y])
        translate([x, y, -0.65]) h30_plastic_damper_screw();
}

module h30_top_markings() {
    translate([0, 0, enclosure_height+0.01])
        linear_extrude(height=0.12) {
            translate([0, 10.0])
                text("WHEELTEC", size=3.0, halign="center", valign="center",
                     font="Liberation Sans:style=Bold");
            translate([0, -9.0])
                text("H30", size=4.0, halign="center", valign="center",
                     font="Liberation Sans:style=Regular");
            circle(d=1.2, $fn=24);
            for (angle=[0, 120, 240])
                rotate(angle)
                    polygon(points=[[0, 0], [7.0, -0.45], [7.0, 0.45]]);
        }
}

module h30_internal_pcb() {
    translate([0, 0, 2.38]) wheeltec_h30_pcb();
}
