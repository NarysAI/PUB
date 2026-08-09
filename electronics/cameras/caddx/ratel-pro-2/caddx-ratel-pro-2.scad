// Caddx Ratel Pro 2 FPV camera — AI-readable parametric re-render.
// Units: millimetres. Origin and axes follow the released manufacturer STEP.
// Overall reference envelope: 20.872 x 27.500 x 19.208 mm (X/Y/Z).
// This file is self-contained and imports no mesh or external CAD geometry.

$fn = 96;

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

module lens_barrel() {
    color([0.055, 0.06, 0.06]) {
        y_annulus(-19.9, -16.4, 15.0, 11.0);
        y_cylinder(-16.4, -14.9, 15.0);
        y_cylinder(-14.9, -12.0, 11.348);
        y_cylinder(-12.0, -9.0, 11.62);
        y_cylinder(-9.0, -6.1, 13.95);
        y_cylinder(-6.1, -3.45, 14.0);
        hull() {
            y_cylinder(-3.46, -3.44, 14.0);
            y_rounded_plate(-0.02, 0.0, housing_size, housing_corner);
        }
    }
}

module camera_housing() {
    color([0.08, 0.085, 0.085])
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
    color([0.04, 0.12, 0.075])
        difference() {
            translate([-camera_width/2, 2.7, -camera_height/2])
                cube([camera_width, pcb_thickness, camera_height]);
            for (x=[-7.6, 7.6], z=[-7.6, 7.6])
                translate([x, 3.25, z])
                    rotate([90, 0, 0]) cylinder(h=1.4, d=1.7, center=true);
        }
}

module rear_electronics() {
    color([0.12, 0.13, 0.13]) {
        translate([3.4886, 3.8, 6.3669]) cube([5.975, 3.8, 3.0]);
        translate([-0.5364, 3.8, 6.3669]) cube([3.975, 3.8, 3.0]);
        translate([-7.8, 3.8, -7.7]) cube([3.0, 1.2, 2.1]);
        translate([4.7, 3.8, -7.4]) cube([2.6, 1.5, 2.0]);
    }
    color([0.72, 0.72, 0.68])
        for (x=[-6.6:1.85:6.6])
            translate([x-0.325, 0.35, 9.5])
                cube([0.65, 2.0, 0.1]);
}

module caddx_ratel_pro_2() {
    lens_barrel();
    camera_housing();
    sensor_pcb();
    rear_electronics();
}

caddx_ratel_pro_2();
