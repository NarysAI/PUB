use <_led-module-common.scad>

// Listing image does not show a dimension; 18 x 15 mm is estimated from
// the 2.54 mm header pitch and must be checked against a physical sample.
led_module(
    board_length=18,
    board_width=15,
    pin_count=4,
    led_style="horizontal",
    resistor_count=3
);
