// Parameterized Raspberry Pi Cases

use <Generators.scad>;
use <PiBoard.scad>;
include <PiDimensions.scad>;

// is this a model B with ethernet?
pi_b = false;
e = 0.0001;

params = params_pi3A();


width = params[WIDTH];
height = params[HEIGHT];
depth = params[DEPTH];
space_left = params[SPACE_LEFT];
space_right = params[SPACE_RIGHT];

// is this transparent plastic needing no LED holes?
transparent = false;


hats = params[HATS];

total_height = 
   height + 
   thickness +
   hats * hat_height +
   standoff_height +
   2 * top_thick;


//---------------------------------------

// standoffs from base and from above
sextra = 1;

module part_standoff() {
   cylinder(height+top_thick*2,
    4,3, center=true, $fn=20);
}

module standoff() 
{
  hull() 
  union ()
  {
  part_standoff();
  translate([2,-4,0]) part_standoff();
  translate([-2,-4,0]) part_standoff();
//  translate(-corner_space_left-4,10,0) * one_standoff(),
  };
}

// subtract the board and hat from the standoff
//standoff = D(standoff, translate(0,0,top_thick+standoff_height) * cube(200,200,hat_space));


// pins that stick up from standoffs and hold board in place
module pin() 
{
 translate([0,0,top_thick+standoff_height-pin_height])
 cylinder(
   pin_height*2,
   pin_radius, pin_radius, center=true, $fn=50);
}

module pins ()
{
  quad(width, depth, -hole_offset, -hole_offset) {pin(); }
}


/*
-- if hat, add pins on top?
if (hat) then
-- todo - add pins before slice
--pins = U(pins, translate(0,0,hat_space) * pins)
end
*/

module supports() 
{
  translate([0,0,0]) 
  quad(width, depth, 
  -hole_offset, -hole_offset) 
    standoff();
} 

//color("red")
//supports();

// corners and mounting holes

module corner_support()
{
  union()
  {
   cylinder(total_height-2*e, 
      corner_support_radius,
      corner_support_radius);
   translate([-0.7,-1,e])
   cylinder(total_height-2*e,
     corner_support_radius*1.3,
     corner_support_radius*1.3);
  }
}
 
module corners(params)
{
  o_xleft = space_left;
  o_xright = space_right;
    
  quad_asm(width+side_thick,
    depth+side_thick,
    o_xleft, 
    o_xright, 
    -corner_support_radius, -corner_support_radius) 
    corner_support();
}

module countersink()
{ 
    translate([0,0,-2])
    cylinder(4.02, 
    corner_support_hole,
    corner_support_hole*2, 
    center=true, $fn=40);
}

// single vertical drill hole and countersink
module drill_hole() 
{
 translate([0,0,total_height])
   countersink(); 
    
 translate([0,0,0])
   mirror([0,0,1])
   countersink(); 
 
 translate([0,0,total_height/2]) 
    cylinder(total_height, corner_support_hole, 
    corner_support_hole, center=true, $fn=50);
}


/*

--led_hole_vertical = translate(-width/2,-depth/2+12, top_thick+board_thickness+0.2+standoff_height) * scale(.75,1,1)* cone(3.6,1.0,height-standoff_height+top_thick)
*/

module led_hole() {
   translate([-width/2,-depth/2+12, top_thick+board_thickness+0.2+standoff_height])
   scale([.75,1,.5])
   rotate([0,-90,0])
   cylinder(corner_space_left+side_thick+6,3.6,0.7);
}

module led_hole2() {
   translate([0,-3,0]) led_hole();
}

//if transparent then
//  led_hole = union {}
//  led_hole2 = union {}
//end

//if pi_w then
//  led_hole2 = union {}
//  led_hole = mirror(X) * led_hole
//end

//color("yellow")
//led_hole();


// take the drill holes out of the supports too
// as they may impinge
// TODO supports = difference( supports, drill_holes)

// connectors
//led_hole();

module board_space() {
  translate([0,0,standoff_height+top_thick])
    pi(params_pi3A());
}

module inside_box() 
{ 
  octo(
  width+gap,
  depth+gap, 
  total_height-2*top_thick-2*inner_radius,
  space_left +outer_radius - inner_radius, 
  space_right+outer_radius - inner_radius, 
  - inner_radius,
  - inner_radius,
  0)
    sphere(inner_radius);
}

module inside_block() {
    translate([0,0,top_thick+inner_radius]) hull() 
    { inside_box(); };
}

module box (params)
{
    difference()
    {
      hull() { corners(params); }
      inside_block();
      // not ideal, want a known thickness around edge
//      translate([0,0,6+top_thick])
//      scale([0.95,0.95,0.65])
//      hull() { corners(params); }
  }    
}

module drill_holes(params)
{ 
    o_xleft = space_left;
    o_xright = space_right;
   
   quad_asm(width+side_thick,
    depth+side_thick,
    o_xleft, o_xright,
    -corner_support_radius, -corner_support_radius)
   drill_hole();
}


module hifiberry()
{
    // screw connectors
    translate([9,
    -depth/2-gap-side_thick,
    top_thick+standoff_height+17])
    cube([31,10,8], center=true);

    // power connector    
    translate([-12,
    -depth/2-gap-side_thick,
    top_thick+standoff_height+17])
    rotate([90,0,0])
    cylinder(10,4,4, center=true, $fn=50);

    translate([-12,
    -depth/2-gap-side_thick+1.5,
    top_thick+standoff_height+15])
    cube([8,2,12],center=true);
}



module fenestration()
{
      
  w0 = -width/2 - space_left - corner_support_radius;
  w1 = width/2 + space_right + corner_support_radius;
  d0 = -depth/2 - corner_support_radius;
  d1 = depth/2 + corner_support_radius;

  difference()
  {
      cube([w1-w0,d1-d0,1], center=true);

     union()
      {
  for (i = [w0:8:w1])
  {
    d =(((i-w0)/8)%2) * 4;
    translate([i, 0, 0])
    for (j = [d0:8:d1])
    {
      translate([0,j+d,0])
        cylinder(4,4,4,center=true,$fn=6);
    }
  }
  }
  }
}


module side_fenestration()
{
translate([-width/2-space_left-corner_support_radius-gap-side_thick-1,0,0])
rotate([0,90,0])
fenestration();


translate([width/2+space_right+corner_support_radius+gap+side_thick+1,0,0])
rotate([0,90,0])
fenestration();

// back side
//translate([0,depth/2+corner_support_radius-side_thick/2,0])
//rotate([90,0,0])
//fenestration();

// connector side
//translate([0,-depth/2-corner_support_radius-side_thick/2,0])
//rotate([90,0,0])
//fenestration();
}



module case(params) {
   union()
   { 
    difference()
    {
      union()
      {
        corners(params);
        box(params);
        supports();
        inner_rim();
      };
      union()
      {
          hifiberry();
        pins();
        fenestration();
        side_fenestration();
        drill_holes(params);
        board_space();
        translate([0,0,total_height])fenestration();
      };
    };
  };
}

module inner_rim() 
{
  radius = .8;
  translate([
  0,
  0,
  top_thick + split-2])
    quad_rim(
     width,
     depth, 
     space_left + gap + side_thick/2+ corner_support_radius,
     space_right+gap+ side_thick/2+corner_support_radius,
      + side_thick/2,
      + side_thick/2, 5) {
     rotate([0,0,0])
     cylinder(6+e,
       radius-0.01,radius,
       center=true,$fn=50);
     }
 }

//color("blue")
//inner_rim();

// Now split the model into two sections

module huge_block(params) 
{ 
  translate([0,0,total_height/2+10+0.01])
  cube([width*2, depth*2, total_height+20], center=true); 
};

module huge_lower_block(params)
{
  translate([0,0,split/2])
  cube([width*2, depth*2, split], center=true);
  inner_rim(); 
}

module huge_upper_block(params) 
{ 
   difference()
    {
        huge_block(params);
        huge_lower_block(params);
    }
};

//color("orange") huge_upper_block();
//color("red") huge_lower_block();

// Used for splitting case
//color("green") upper_inner_block();

//emit(board,4)
//emit(upper_inner_block,5)


//color("green")
//inner_rim();

module upper_block_1(params) 
{
    intersection(){
        huge_upper_block(params);
        case(params);
    }
}

module lower_case(params) {
  intersection() {
    case(params);
    huge_lower_block(params);
  }
}

module upper_case(params) 
{
    intersection()
    {
        case(params);
        huge_upper_block(params);
    }
}


// seems to be off by 2 layers of 0.2mm
flipped_offset = total_height;

flip_y = width+2*side_thick+5;

module flip_top(params)
{
    translate([0,-flip_y,flipped_offset])
    rotate([180,0,0])
    upper_case(params);
}


// OBJECTS --------------------------------

//color("green") board_space();


// complete
lower_case(params);

color("red")
flip_top(params);

// For debugging, view these components

//emit(board, 5)
//emit(usb,6)
//emit(hdmi_plug,7)
//emit(usbplug,7)
//emit(usb_socket,7)
//emit(audio_plug,9)
//emit(union{usb, usbplug},5)
