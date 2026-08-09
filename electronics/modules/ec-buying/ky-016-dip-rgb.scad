use <_led-module-common.scad>

// Listing dimension: 19 x 15 mm PCB; upright F5 RGB LED and four pins.
led_module(
    board_length=19,
    board_width=15,
    pin_count=4,
    led_style="vertical",
    resistor_count=3
);
