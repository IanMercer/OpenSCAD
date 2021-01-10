// Dimensions for raspberry Pis

hole_offset = 3.5;
e = 0.001;

// gap between board and walls (y)
gap = 0.4;

outer_radius = 7;
inner_radius = 1;

// thickness of sides
top_thick = 1.2;
side_thick = 1.2;
hat_height = 17;
sweep_height = 10;

standoff_height = 7;
standoff_radius = 3;

corner_support_radius = 5.5;
corner_support_hole = 3;
corner_space_left = 2 * corner_support_radius;


pin_height = 2;

pin_radius = 1.1;


thickness = 1.2; // mm for board

split = top_thick
    +standoff_height
    +thickness
    +8;


// width
// depth

NAME=0;
WIDTH=1;
DEPTH=2;
HEIGHT=3;
HATS=9;
SPACE_LEFT = 10;
SPACE_RIGHT = 11;

// https://www.raspberrypi.org/documentation/hardware/raspberrypi/mechanical/rpi_MECH_3aplus.pdf

function params_pi3A() = [
  "Pi3A",
  65+.10, /* width */
  56+.10, /* depth */
  12,     /* height of highest point */
  10.6,   /* center of USB for power */
  10.6,   /* center of second USB (if none use same) */
  32.0,   /* hdmi offset */
  17.0,   /* hdmi width */
   8.0,   /* hdmi height */
   1.0,   /* hats */
   6.0,   /* space left */
   6.0,   /* space right */
];

function params_pi3B() = [
  "Pi3B",
  65+.10, /* width */
  56+.10, /* depth */
  12.0,   /* height of highest point */
  10.6,   /* center of USB for power */
  10.6,   /* center of second USB (if none use same) */
  32.0,   /* hdmi offset */
  17.0,   /* hdmi width */
   8.0,   /* hdmi height */
   1.0,   /* hats */
   6.0,   /* space left */
   16.0,  /* space right */
];

function params_piW() = [
  "PiW",
  65+.10, /* width */
  30+.10, /* depth */
  12.0,     /* height of highest point */
  54,     /* center of USB for power */
  41.4,   /* center of second USB (if none use same) */
  12.4,   /* hdmi offset */
  15.0,   /* hdmi width */
   7.0,   /* hdmi height */
   1.0,   /* hats */
   6.0,   /* space left */
   6.0,   /* space right */
];

function examples() = [
  [0, params_piW(), "red"],
  [90, params_pi3A(), "green"],
  [180, params_pi3B(), "blue"]
];

// use in a loop
//for (ex = examples())
//    translate([0,ex[0],0])
//    usb_plus(ex[1]);


// Sweeps a connector up to clear a path for it
module sweep(h=0)
{
   hull()
   {
       children();
       translate([0,0,sweep_height-h])
       children();
   }
}
