use <_led-module-common.scad>

// Listing dimension: 18 x 15 mm PCB; upright F5 bi-colour LED and three pins.
led_module(
    board_length=18,
    board_width=15,
    pin_count=3,
    led_style="vertical",
    resistor_count=2
);
