// Caddx Ratel Pro 2 FPV camera — AI-readable parametric re-render.
// Units: millimetres. Origin and axes follow the released manufacturer STEP.
// Overall reference envelope: 20.872 x 27.500 x 19.208 mm (X/Y/Z).
// This file is self-contained and imports no mesh or external CAD geometry.
// NARYS_MATERIAL: lens_front=#303942
// NARYS_MATERIAL: lens_outer=#171C21
// NARYS_MATERIAL: lens_mid=#3B444C
// NARYS_MATERIAL: lens_focus=#222A31
// NARYS_MATERIAL: lens_rear=#465058
// NARYS_MATERIAL: transition=#30363C
// NARYS_MATERIAL: glass=#176080
// NARYS_MATERIAL: housing=#4A5259
// NARYS_MATERIAL: pcb=#1C824A
// NARYS_MATERIAL: connector=#D7D9D8
// NARYS_MATERIAL: components=#282E33
// NARYS_MATERIAL: contacts=#D6A83B

$fn = 96;
narys_material = is_undef(narys_material) ? "all" : narys_material;

camera_width = 19.0;
camera_height = 19.0;
pcb_thickness = 1.1;
housing_size = 19.208;
housing_corner = 1.1;

module y_cylinder(y_min, y_max, diameter) {
    translate([0, y_max, 0])
        rotate([90, 0, 0])
            cylinder(h=y_max-y_min, d=diameter);
}

module y_annulus(y_min, y_max, outer_diameter, inner_diameter) {
    difference() {
        y_cylinder(y_min, y_max, outer_diameter);
        translate([0, 0.01, 0])
            y_cylinder(y_min-0.01, y_max+0.01, inner_diameter);
    }
}

module rounded_square_2d(size, radius) {
    offset(r=radius)
        square([size-2*radius, size-2*radius], center=true);
}

module y_rounded_plate(y_min, y_max, size, radius) {
    translate([0, y_max, 0])
        rotate([90, 0, 0])
            linear_extrude(height=y_max-y_min)
                rounded_square_2d(size, radius);
}

module lens_front() {
    color("#303942") {
        y_annulus(-19.9, -16.4, 15.0, 11.0);
        y_cylinder(-16.4, -14.9, 15.0);
    }
}

module lens_outer() {
    color("#171C21")
        y_cylinder(-14.9, -12.0, 11.348);
}

module lens_mid() {
    color("#3B444C")
        y_cylinder(-12.0, -9.0, 11.62);
}

module lens_focus() {
    color("#222A31")
        y_cylinder(-9.0, -6.1, 13.95);
}

module lens_rear() {
    color("#465058")
        y_cylinder(-6.1, -3.45, 14.0);
}

module lens_transition() {
    color("#30363C")
        hull() {
            y_cylinder(-3.46, -3.44, 14.0);
            y_rounded_plate(-0.02, 0.0, housing_size, housing_corner);
        }
}

module lens_glass() {
    color("#176080")
        y_cylinder(-19.82, -19.68, 10.7);
}

module camera_housing() {
    color("#4A5259")
        difference() {
            union() {
                y_rounded_plate(0.0, 2.7, housing_size, housing_corner);
                for (x=[-9.4358, 9.4358])
                    translate([x, 1.35, 0])
                        rotate([90, 0, 0]) cylinder(h=2.0, d=2.0, center=true);
            }
            for (x=[-7.6, 7.6], z=[-7.6, 7.6])
                translate([x, 1.35, z])
                    rotate([90, 0, 0]) cylinder(h=3.0, d=1.7, center=true);
        }
}

module sensor_pcb() {
    color("#1C824A")
        difference() {
            translate([-camera_width/2, 2.7, -camera_height/2])
                cube([camera_width, pcb_thickness, camera_height]);
            for (x=[-7.6, 7.6], z=[-7.6, 7.6])
                translate([x, 3.25, z])
                    rotate([90, 0, 0]) cylinder(h=1.4, d=1.7, center=true);
        }
}

module rear_components() {
    color("#282E33") {
        translate([-7.8, 3.8, -7.7]) cube([3.0, 1.2, 2.1]);
        translate([4.7, 3.8, -7.4]) cube([2.6, 1.5, 2.0]);
    }
}

module rear_connector() {
    color("#D7D9D8") {
        translate([3.4886, 3.8, 6.3669]) cube([5.975, 3.8, 3.0]);
        translate([-0.5364, 3.8, 6.3669]) cube([3.975, 3.8, 3.0]);
    }
}

module rear_contacts() {
    color("#D6A83B")
        for (x=[-6.6:1.85:6.6])
            translate([x-0.325, 0.35, 9.5])
                cube([0.65, 2.0, 0.1]);
}

module caddx_ratel_pro_2() {
    if (narys_material == "all" || narys_material == "lens_front") lens_front();
    if (narys_material == "all" || narys_material == "lens_outer") lens_outer();
    if (narys_material == "all" || narys_material == "lens_mid") lens_mid();
    if (narys_material == "all" || narys_material == "lens_focus") lens_focus();
    if (narys_material == "all" || narys_material == "lens_rear") lens_rear();
    if (narys_material == "all" || narys_material == "transition") lens_transition();
    if (narys_material == "all" || narys_material == "glass") lens_glass();
    if (narys_material == "all" || narys_material == "housing") camera_housing();
    if (narys_material == "all" || narys_material == "pcb") sensor_pcb();
    if (narys_material == "all" || narys_material == "connector") rear_connector();
    if (narys_material == "all" || narys_material == "components") rear_components();
    if (narys_material == "all" || narys_material == "contacts") rear_contacts();
}

caddx_ratel_pro_2();
