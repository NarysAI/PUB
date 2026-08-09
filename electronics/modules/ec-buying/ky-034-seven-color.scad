use <_led-module-common.scad>

// Listing dimension: 20 x 15 mm PCB; three-pin seven-colour module.
led_module(
    board_length=20,
    board_width=15,
    pin_count=3,
    led_style="horizontal",
    resistor_count=1
);
