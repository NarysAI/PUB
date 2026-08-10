/*
  WHEELTEC H30 Enclosed - AI-readable mechanical reference.
  Simplified from the official WHEELTEC_H30 Sensor (metal housing).stp.
  Overall envelope: 46.0 x 59.5 x 11.7 mm.
  Units: millimetres. Origin: center of base, bottom face.
*/

// NARYS_MATERIAL: housing=#D7DBDE
// NARYS_MATERIAL: pcb=#143C34
// NARYS_MATERIAL: fasteners=#636A70
// NARYS_MATERIAL: markings=#2D3338

narys_material = is_undef(narys_material) ? "all" : narys_material;
include <_h30-pcb-model.scad>

enclosure_width = 46.0;
enclosure_length = 59.5;
enclosure_height = 11.7;
body_length = 43.3;
base_thickness = 2.0;
cover_thickness = 2.0;
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

module h30_lower_housing() {
    lower_height = enclosure_height-cover_thickness-base_thickness;
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
            // USB-C service opening shown on the standard metal-housing model.
            translate([-11.0, -body_length/2-0.2, 2.0])
                rotate([-90, 0, 0])
                    hull() {
                        translate([-3.8, 0, 0]) cylinder(d=3.2, h=wall_thickness+0.4, $fn=30);
                        translate([ 3.8, 0, 0]) cylinder(d=3.2, h=wall_thickness+0.4, $fn=30);
                    }
        }
}

module h30_cover() {
    translate([0, 0, enclosure_height-cover_thickness])
        difference() {
            h30_rounded_plate(
                [enclosure_width, body_length],
                cover_thickness,
                corner_radius
            );
            for (y=[-15.0, 15.0])
                translate([0, y, -0.1])
                    cylinder(d1=3.2, d2=5.5, h=cover_thickness+0.2, $fn=40);
        }
}

module h30_cover_screws() {
    for (y=[-15.0, 15.0])
        translate([0, y, enclosure_height-0.5])
            difference() {
                cylinder(d1=5.2, d2=3.0, h=0.5, $fn=40);
                translate([-1.7, -0.25, 0.28]) cube([3.4, 0.5, 0.3]);
            }
}

module h30_top_markings() {
    translate([0, 0, enclosure_height+0.01])
        linear_extrude(height=0.12) {
            translate([0, 10.5])
                text("WHEELTEC", size=3.0, halign="center", valign="center",
                     font="Liberation Sans:style=Bold");
            translate([0, -10.0])
                text("H30", size=4.0, halign="center", valign="center",
                     font="Liberation Sans:style=Regular");
            translate([0, 0]) {
                circle(d=1.2, $fn=24);
                for (angle=[0, 120, 240])
                    rotate(angle)
                        polygon(points=[[0, 0], [7.0, -0.45], [7.0, 0.45]]);
            }
        }
}

module h30_internal_pcb() {
    // Placement follows the official assembly: PCB centered under the cover.
    translate([0, 0, 2.38])
        wheeltec_h30_pcb();
}

module wheeltec_h30_enclosed() {
    if (narys_material == "all" || narys_material == "housing")
        color("#D7DBDE") {
            h30_mounting_base();
            h30_lower_housing();
            h30_cover();
        }
    if (narys_material == "all" || narys_material == "pcb")
        h30_internal_pcb();
    if (narys_material == "all" || narys_material == "fasteners")
        color("#636A70") h30_cover_screws();
    if (narys_material == "all" || narys_material == "markings")
        color("#2D3338") h30_top_markings();
}

wheeltec_h30_enclosed();
