/*
  WHEELTEC H30WP IMU board - approximate visual/mechanical model
  Reconstructed from a single top-view photograph.

  Coordinate system:
    X: left -> right
    Y: bottom -> top
    Z: bottom of PCB -> top
    Origin: center of PCB, bottom face

  Units: millimetres
  OpenSCAD compatibility: 2021.01+
*/

// ---------- User parameters ----------

pcb_width       = 42.5;
pcb_height      = 31.0;
pcb_thickness   = 1.60;
corner_radius   = 2.00;
mount_hole_d    = 2.20;
mount_ring_d    = 3.20;

detail          = 2;       // 0 = outline, 1 = main parts, 2 = full visual detail
show_components = true;
show_pads       = true;
show_silkscreen = true;
show_bottom_rings = true;
header_mode     = "pads";  // "pads", "pins", or "none"

$fn = $preview ? 28 : 72;
eps = 0.02;

// ---------- Palette ----------

pcb_color       = [0.025, 0.055, 0.050];
pcb_edge_color  = [0.020, 0.040, 0.036];
silk_color      = [0.92, 0.94, 0.91];
metal_color     = [0.72, 0.75, 0.74];
dark_metal      = [0.32, 0.35, 0.35];
gold_color      = [0.72, 0.54, 0.18];
chip_color      = [0.035, 0.038, 0.037];
cap_color       = [0.50, 0.51, 0.47];
passive_color   = [0.23, 0.21, 0.17];
tan_color       = [0.87, 0.54, 0.08];

// Hole centers are measured from the lower-left corner of the PCB.
// The placement arrays use the photograph's 50 x 36.3 reference grid;
// at_xy() maps that grid to the calibrated physical PCB dimensions above.
layout_width  = 50.0;
layout_height = 36.3;

mount_holes = [
    [3.47, 4.33],
    [33.59,4.33],
    [3.47,32.55],
    [33.59,32.55]
];

// ---------- Coordinate helpers ----------

module at_xy(p, z=0) {
    translate([(p[0]/layout_width-0.5)*pcb_width,
               (p[1]/layout_height-0.5)*pcb_height,
               z]) children();
}

module rounded_rect_2d(size=[10,10], r=1) {
    offset(r=r)
        square([size[0]-2*r, size[1]-2*r], center=true);
}

module rounded_box_xy(size=[10,10,1], r=1) {
    linear_extrude(height=size[2])
        rounded_rect_2d([size[0],size[1]], r);
}

module annulus(outer_d, inner_d, h=0.06) {
    difference() {
        cylinder(d=outer_d, h=h);
        translate([0,0,-eps]) cylinder(d=inner_d, h=h+2*eps);
    }
}

module pad_rect(p, size=[1.5,2.0], rot=0, h=0.07, col=metal_color) {
    color(col)
    at_xy(p, pcb_thickness+0.01)
        rotate([0,0,rot])
            rounded_box_xy([size[0],size[1],h], min(size[0],size[1])*0.16);
}

// ---------- PCB ----------

module pcb() {
    color(pcb_color)
    difference() {
        linear_extrude(height=pcb_thickness)
            rounded_rect_2d([pcb_width,pcb_height], corner_radius);

        for (h = mount_holes)
            at_xy(h,-eps)
                cylinder(d=mount_hole_d, h=pcb_thickness+2*eps);
    }

    // A very thin darker band makes the board edge readable in renders.
    color(pcb_edge_color)
    difference() {
        linear_extrude(height=0.05)
            rounded_rect_2d([pcb_width,pcb_height], corner_radius);
        linear_extrude(height=0.07)
            offset(delta=-0.22)
                rounded_rect_2d([pcb_width,pcb_height], corner_radius);
        for (h = mount_holes)
            at_xy(h,-eps) cylinder(d=mount_hole_d, h=0.1);
    }
}

module mounting_rings() {
    for (h = mount_holes) {
        color(metal_color)
        at_xy(h,pcb_thickness+0.006)
            annulus(mount_ring_d,mount_hole_d,0.055);

        if (show_bottom_rings)
            color(metal_color)
            at_xy(h,-0.055)
                annulus(mount_ring_d,mount_hole_d,0.055);
    }
}

// ---------- Generic electronic packages ----------

module smd_passive(p, size=[1.6,0.8], rot=0, body=passive_color, height=0.48) {
    term = size[0]*0.23;
    at_xy(p,pcb_thickness+height/2)
    rotate([0,0,rot]) {
        color(metal_color) {
            translate([-(size[0]-term)/2,0,0]) cube([term,size[1],height*0.72],center=true);
            translate([ +(size[0]-term)/2,0,0]) cube([term,size[1],height*0.72],center=true);
        }
        color(body)
            cube([size[0]-2*term+0.04,size[1]*0.92,height],center=true);
    }
}

module led_smd(p, size=[1.8,1.0], rot=0, lens=[0.74,0.20,0.10]) {
    smd_passive(p,size,rot,[0.86,0.84,0.73],0.50);
    color(lens)
    at_xy(p,pcb_thickness+0.52)
        rotate([0,0,rot])
            cube([size[0]*0.42,size[1]*0.62,0.16],center=true);
}

module tantalum_cap(p, rot=0) {
    at_xy(p,pcb_thickness+0.72)
    rotate([0,0,rot]) {
        color(metal_color) {
            translate([-1.92,0,-0.49]) cube([0.62,2.75,0.18],center=true);
            translate([ 1.92,0,-0.49]) cube([0.62,2.75,0.18],center=true);
        }
        color(tan_color)
            rounded_box_xy([3.90,2.90,1.55],0.28);
        color([0.96,0.78,0.30])
            translate([1.06,0,1.56]) cube([0.20,2.35,0.025],center=true);
    }
}

module qfn(p, body=[5.2,5.2], pins_per_side=7, rot=0, height=0.90) {
    pin_pitch_x = body[1]/pins_per_side;
    pin_pitch_y = body[0]/pins_per_side;
    lead_w = 0.30;
    lead_l = 0.72;

    at_xy(p,pcb_thickness+0.08)
    rotate([0,0,rot]) {
        color(metal_color) {
            for (i=[0:pins_per_side-1]) {
                oy = -body[1]/2 + pin_pitch_x/2 + i*pin_pitch_x;
                ox = -body[0]/2 + pin_pitch_y/2 + i*pin_pitch_y;
                translate([-(body[0]+lead_l)/2,oy,0.05]) cube([lead_l,lead_w,0.12],center=true);
                translate([ +(body[0]+lead_l)/2,oy,0.05]) cube([lead_l,lead_w,0.12],center=true);
                translate([ox,-(body[1]+lead_l)/2,0.05]) cube([lead_w,lead_l,0.12],center=true);
                translate([ox, +(body[1]+lead_l)/2,0.05]) cube([lead_w,lead_l,0.12],center=true);
            }
        }
        color(chip_color)
            translate([0,0,height/2]) rounded_box_xy([body[0],body[1],height],0.28);
        color([0.76,0.77,0.73])
            translate([-body[0]*0.31,body[1]*0.31,height+0.02]) cylinder(d=0.38,h=0.05);
    }
}

module soic(p, body=[3.8,5.2], pins_per_side=4, rot=0, height=1.0) {
    pitch = body[1]/pins_per_side;
    lead_l = 1.0;
    lead_w = min(0.44,pitch*0.56);

    at_xy(p,pcb_thickness+0.07)
    rotate([0,0,rot]) {
        color(metal_color)
        for (side=[-1,1])
            for (i=[0:pins_per_side-1]) {
                oy = -body[1]/2 + pitch/2 + i*pitch;
                translate([side*(body[0]+lead_l)/2,oy,0.07])
                    cube([lead_l,lead_w,0.14],center=true);
            }

        color(chip_color)
            translate([0,0,height/2]) rounded_box_xy([body[0],body[1],height],0.30);
        color([0.72,0.74,0.71])
            translate([-body[0]*0.30,body[1]*0.35,height+0.015]) cylinder(d=0.35,h=0.04);
    }
}

module tiny_sot23(p, rot=0) {
    at_xy(p,pcb_thickness+0.08)
    rotate([0,0,rot]) {
        color(metal_color) {
            translate([-1.10,-0.62,0.05]) cube([0.80,0.38,0.12],center=true);
            translate([-1.10, 0.62,0.05]) cube([0.80,0.38,0.12],center=true);
            translate([ 1.10, 0.00,0.05]) cube([0.80,0.38,0.12],center=true);
        }
        color(chip_color)
            translate([0,0,0.48]) rounded_box_xy([1.7,1.8,0.82],0.20);
    }
}

// ---------- Major board-specific parts ----------

module usb_c_receptacle() {
    p = [3.06,18.33];
    body = [7.4,9.0,3.25];

    at_xy(p,pcb_thickness+0.12) {
        color(metal_color)
        difference() {
            rounded_box_xy(body,1.0);
            translate([-body[0]/2-0.05,0,1.72])
                cube([2.0,6.30,1.62],center=true);
        }

        color([0.055,0.060,0.058])
            translate([-body[0]/2-0.02,0,1.72])
                cube([0.18,5.95,1.25],center=true);

        color(dark_metal) {
            translate([-0.3,-3.58,0.22]) cube([4.8,0.38,0.34],center=true);
            translate([-0.3, 3.58,0.22]) cube([4.8,0.38,0.34],center=true);
        }
    }

    // Shell anchor tabs and the row of signal contacts.
    color(metal_color) {
        pad_rect([5.9,13.8],[1.2,1.8]);
        pad_rect([5.9,22.4],[1.2,1.8]);
        for (i=[0:7])
            pad_rect([7.4,15.65+i*0.70],[0.52,0.32]);
    }
}

module central_sensor_package() {
    p = [18.77,18.57];

    // Gold ceramic/substrate rim.
    color(gold_color)
    at_xy(p,pcb_thickness+0.08)
        rounded_box_xy([10.0,10.0,0.36],0.55);

    // Visible perimeter contacts.
    color([0.82,0.69,0.36])
    at_xy(p,pcb_thickness+0.43) {
        for (i=[-3:3]) {
            translate([i*1.16,-4.80,0]) cube([0.55,0.55,0.16],center=true);
            translate([i*1.16, 4.80,0]) cube([0.55,0.55,0.16],center=true);
            translate([-4.80,i*1.16,0]) cube([0.55,0.55,0.16],center=true);
            translate([ 4.80,i*1.16,0]) cube([0.55,0.55,0.16],center=true);
        }
    }

    color(chip_color)
    at_xy(p,pcb_thickness+0.42)
        rounded_box_xy([9.35,9.35,0.58],0.48);

    color([0.62,0.62,0.56])
    at_xy(p,pcb_thickness+1.00)
        rounded_box_xy([8.50,8.40,0.66],0.42);

    if (detail > 1) {
        color([0.82,0.82,0.76])
        at_xy([18.77,18.57],pcb_thickness+1.675)
            linear_extrude(height=0.035)
                rotate([0,0,90])
                    text("H30WP",size=0.92,halign="center",valign="center",
                         font="Liberation Sans:style=Bold");
    }
}

module slide_switch() {
    p = [32.18,11.12];
    at_xy(p,pcb_thickness+0.08) {
        color(metal_color) {
            translate([-2.45,-0.76,0.05]) cube([0.95,0.46,0.12],center=true);
            translate([ 2.45,-0.76,0.05]) cube([0.95,0.46,0.12],center=true);
            translate([-2.45, 0.76,0.05]) cube([0.95,0.46,0.12],center=true);
            translate([ 2.45, 0.76,0.05]) cube([0.95,0.46,0.12],center=true);
        }
        color([0.10,0.105,0.10])
            translate([0,0,0.42]) rounded_box_xy([4.2,1.8,0.78],0.22);
        color([0.75,0.76,0.72])
            translate([-0.78,0,1.05]) rounded_box_xy([1.55,0.82,0.55],0.15);
    }
}

module right_contact_bank() {
    ys = [2.94,5.91,8.89,11.94,14.84,17.81,20.79];
    xs = [40.74,47.09];

    if (header_mode == "pads") {
        for (x=xs)
            for (y=ys)
                pad_rect([x,y],[2.60,1.25],0,0.075);
    }

    if (header_mode == "pins") {
        for (x=xs)
            for (y=ys) {
                pad_rect([x,y],[2.85,1.55],0,0.075,gold_color);
                color([0.75,0.62,0.24])
                at_xy([x,y],pcb_thickness+0.06)
                    translate([0,0,3.0]) cube([0.64,0.64,6.0],center=true);
            }
    }

    // Five small pads along the top edge.
    for (x=[38.4,40.75,43.1,45.45,47.8])
        pad_rect([x,33.65],[1.35,1.45],0,0.07);
}

// ---------- Component population ----------

passives_0603 = [
    // USB-C support network
    [8.8,13.7,90],[9.8,15.2,0],[9.8,16.7,0],[9.8,19.8,0],[9.8,21.3,0],
    [11.2,23.2,90],[12.6,23.2,90],

    // Upper-left and upper-middle clusters
    [13.1,31.6,0],[15.0,31.6,0],[16.8,31.6,0],[18.7,31.6,0],
    [19.3,28.4,90],[21.1,28.4,90],[23.1,28.4,90],[25.1,28.4,90],
    [17.1,26.2,0],[18.9,26.2,0],[21.0,26.1,0],[23.0,26.1,0],
    [24.9,26.1,0],[26.8,26.1,0],

    // Around central sensor
    [11.5,22.8,0],[11.5,20.9,0],[11.6,18.9,0],[11.7,16.8,0],
    [13.5,12.7,90],[15.2,12.5,90],[17.0,12.4,90],
    [24.9,12.8,90],[26.8,12.8,90],[28.6,12.8,90],

    // Center-right analog/network cluster
    [30.4,26.4,90],[31.8,26.4,90],[33.2,26.4,90],
    [29.4,23.6,0],[31.2,23.6,0],[33.0,23.6,0],
    [29.4,21.9,0],[31.2,21.9,0],[33.0,21.9,0],
    [29.4,18.9,90],[31.2,18.9,90],[33.0,18.9,90],
    [29.4,16.9,90],[31.2,16.9,90],[33.0,16.9,90],

    // Lower-left and lower-middle clusters
    [8.1,10.4,0],[10.0,10.4,0],[11.9,10.4,0],
    [7.7,7.8,90],[9.3,7.8,90],[10.9,7.8,90],
    [12.2,4.0,0],[13.9,4.0,0],[15.6,4.0,0],
    [24.6,5.2,90],[26.2,5.2,90],[27.9,5.2,90],
    [27.1,7.7,0],[28.7,7.7,0]
];

passives_0805 = [
    [12.0,29.4,90],[14.0,28.0,0],[16.1,28.0,0],
    [28.6,28.6,90],[34.7,20.6,90],[34.7,17.6,90],
    [35.2,13.7,0],[37.0,13.7,0],
    [8.0,5.2,0],[10.4,5.2,0]
];

module component_population() {
    if (detail > 0) {
        usb_c_receptacle();
        central_sensor_package();
        qfn([19.37,4.30],[5.2,5.3],7,0,0.92);
        soic([14.5,29.7],[3.5,5.0],4,0,0.95);
        soic([41.94,27.64],[3.2,5.4],5,0,1.00);
        soic([33.12,18.56],[3.1,4.5],4,0,0.82);
        tiny_sot23([27.7,29.7],90);
        tiny_sot23([25.7,8.1],0);
        slide_switch();
        tantalum_cap([10.48,29.29],90);
    }

    if (detail > 1) {
        for (p=passives_0603)
            smd_passive([p[0],p[1]],[1.55,0.78],p[2]);

        for (p=passives_0805)
            smd_passive([p[0],p[1]],[2.0,1.20],p[2],[0.18,0.16,0.12],0.58);

        led_smd([36.0,30.8],[1.8,1.0],90,[0.68,0.09,0.06]);
        led_smd([37.6,30.8],[1.8,1.0],90,[0.10,0.55,0.18]);

        // Small crystal/oscillator near the lower MCU.
        color([0.67,0.68,0.65])
        at_xy([25.8,3.2],pcb_thickness+0.08)
            rounded_box_xy([2.7,1.45,0.70],0.22);
    }
}

module exposed_pads() {
    right_contact_bank();

    // Sparse unpopulated footprints visible in the photograph.
    for (p=[[29.0,28.7],[31.0,28.7],[33.0,28.7],
            [36.4,24.3],[36.4,22.3],[36.4,20.3],
            [29.1,14.7],[31.0,14.7],[33.0,14.7]])
        pad_rect(p,[0.72,1.25],0,0.06);

    // Pads around the right-side SOIC footprint.
    for (i=[0:4]) {
        pad_rect([39.0,24.9+i*1.25],[1.05,0.46],0,0.06);
        pad_rect([44.5,24.9+i*1.25],[1.05,0.46],0,0.06);
    }
}

// ---------- Silkscreen ----------

module silk_text(label, p, size=1.25, rot=0, halign="center", valign="center") {
    color(silk_color)
    at_xy(p,pcb_thickness+0.095)
        rotate([0,0,rot])
            linear_extrude(height=0.035)
                text(label,size=size,halign=halign,valign=valign,
                     font="Liberation Sans:style=Bold");
}

module silk_line(a,b,w=0.22) {
    color(silk_color)
    hull() {
        at_xy(a,pcb_thickness+0.094) cylinder(d=w,h=0.036,$fn=18);
        at_xy(b,pcb_thickness+0.094) cylinder(d=w,h=0.036,$fn=18);
    }
}

module silk_frame(p,size=[6,4],w=0.22) {
    x0=p[0]-size[0]/2;
    x1=p[0]+size[0]/2;
    y0=p[1]-size[1]/2;
    y1=p[1]+size[1]/2;
    silk_line([x0,y0],[x1,y0],w);
    silk_line([x1,y0],[x1,y1],w);
    silk_line([x1,y1],[x0,y1],w);
    silk_line([x0,y1],[x0,y0],w);
}

module silkscreen() {
    // Branding and interface labels.
    silk_text("WHEELTEC",[18.0,8.95],2.05,180);
    silk_text("SWITCH",[32.18,8.05],1.05,0);
    silk_text("UART",[34.1,12.25],0.92,90);
    silk_text("485",[31.9,12.35],0.92,90);
    silk_text("A",[11.0,34.25],1.55,180);
    silk_text("H30WP",[22.5,34.0],0.66,180);

    // X/Y orientation marker near the upper-left hole.
    silk_line([2.65,27.7],[2.65,30.9],0.24);
    silk_line([2.65,27.7],[5.45,27.7],0.24);
    silk_line([2.65,27.7],[4.55,29.55],0.20);
    silk_text("Y",[2.65,31.55],0.85,0);
    silk_text("X",[6.0,27.7],0.85,0);
    color(silk_color)
    at_xy([2.65,27.7],pcb_thickness+0.095)
        cylinder(d=0.72,h=0.036,$fn=20);

    // Footprint outlines and polarity/orientation marks.
    silk_frame([32.18,11.12],[6.7,3.9],0.20);
    silk_frame([33.12,18.56],[5.0,6.2],0.19);
    silk_frame([41.94,27.64],[5.8,7.4],0.18);
    silk_line([27.7,15.2],[36.5,15.2],0.18);
    silk_line([27.7,14.55],[27.7,15.2],0.18);
    silk_line([36.5,14.55],[36.5,15.2],0.18);

    // Small reference marks that remain legible at normal preview scale.
    silk_text("U",[28.2,24.7],0.70,0);
    silk_text("R",[37.0,16.1],0.70,0);
    silk_text("C",[13.4,25.1],0.70,0);
}

// ---------- Assembly ----------

module wheeltec_h30wp_board() {
    pcb();
    mounting_rings();

    if (show_pads)
        exposed_pads();

    if (show_components)
        component_population();

    if (show_silkscreen && detail > 0)
        silkscreen();
}

wheeltec_h30wp_board();
