// Raspberry Pi Board and components

use <Generators.scad>;
include <PiDimensions.scad>;
use <PiUsb.scad>
use <PiHdmi.scad>
use <PiAudio.scad>
use <PiSdCard.scad>

// Creates a Raspberry pi centered on mounting holes

module pi_board(params)
{
    // inside dimensions excluding screw holes
    width = params[1];
    assert(width > 65, "Width must be >65");
    depth = params[2];
    assert(depth > 30, "Depth must be >30");
    
    difference()
    {
       hull() {
         quad(width, depth, -3,-3)
         {
           cylinder (thickness, 3,3, center=true, $fn=20); 
         }
       };
     // holes
     quad(width, depth, -hole_offset,-hole_offset)
     {
         translate([0,0,-thickness/2+1])
       cylinder (thickness+2, 1.4,1.4, center=true, $fn=20); 
     }
   }
}

// space around board = board + gap - board
module pi_gap(params)
{
    width = params[1];
    depth = params[2];
    
    difference()
    {
       hull() {
         quad(width+gap,
          depth+gap,
          -3,-3)
         {
           cylinder (thickness-e, 3,3, center=true, $fn=20); 
         }
       };
       
       hull() pi_board(params);
   }
}


// space above board
module pi_space_above(params)
{
    height = params[HEIGHT];
    assert(height > 10, "Height must be >10");
    hull()
    {
        translate([0,0,thickness])
        pi_gap(params);
        translate([0,0,height])
        pi_gap(params);
    };
}

// space below board
module pi_space_below(params)
{
    width = params[1];
    depth = params[2];
    height = params[HEIGHT];
    
    translate([0,0,-thickness])
    difference()
    {
      hull() pi_gap(params);
    
      // supports
      quad(width, depth, -hole_offset,-hole_offset)
       {
       translate([0,0,-thickness/2])
       cylinder (thickness+2, 2.4,2.4,center=true, $fn=20); 
     }
    }
}

// space above board
module pi_hats(params)
{
    height = params[HEIGHT];
    hats = params[HATS];
    if (hats > 0)
    hull()
    {
        translate([0,0,height])
        pi_gap(params);
        translate([0,0,height+hats*hat_height])
        pi_gap(params);
    }
}


// exploded view optional
module pi(params, explode=0)
{
    color("yellow")
    pi_board(params); // with holes

    color("blue")
    pi_gap(params);
    
    // and swept area above
    translate([0,0,explode])
    color("yellow")
    pi_space_above(params);
    
    // and swpt area below
    translate([0,0,-explode/2])
    color("red")
    pi_space_below(params);
    
    // Add connectors
    color("green")
    usbs(params);
    color("green")
    hdmi(params);
    color("green")
    audio(params);
    color("green")
    sd_card(params);
    
    color("orange")
    translate([0,0,explode*1.2])
    pi_hats(params);
 }

pi(params_pi3A(), 15);

translate([0,90,0])
pi(params_pi3B(), 20);

translate([0,180,0])
pi(params_piW(), 25);

