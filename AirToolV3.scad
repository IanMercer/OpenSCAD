// This is a cross section of the air-tool connector
// It models just one side of it as the shape will be created
// by extruding this profile

module profile(){
polygon([
 [0,0],        // start on center line
 [9.5,0],      // nut on bottom
 [9.5,22.5],
 [6.5,24.5],   // 2mm transition to 6.5mm
 [6.5,34.5],   // 10mm at 6.5mm radius
 [4.5,38.5],   // 4mm transition to 4.5mm
 [4.5,39.5],   // 1mm at 4.5 * THIS IS THE CRITICAL SUPPORT *
 [6.5,41.5],   // 2m transition back to 6.5mm radius
 [6.5,44],     // 2.5mm at 6.5mm radius
 [4.7,46],     // 2mm transition back to 4.7mm
 [4.6,55],     // clear above (extend if necessary)
 [0,55]        // back to center line
]);
}

// Spin the profile through 180 to create a rounded end
module round_end() { rotate_extrude(angle=180, $fn=100) profile();}

// Slide the profile down one side
module edge() { rotate([90,0,0]) linear_extrude(50) profile(); }

// Combine the rounded end and two copies of the sides
module air_tool() { round_end(); edge(); mirror([1,0,0]) edge(); }

// Orient it to subtract from the solid body we are about to create
module oriented_air_tool() { translate([10,0,20]) rotate([260,0,270]) air_tool(); }

// body
module body()
{
color("red") rotate([90,-90,0]) linear_extrude(30, center=true) polygon(points=[
    [7,-5],  // top right
    [44.5,-30],  // top right
    [44.5,-52.5],//top left
    [-0,-60], // bottom left
    [0,-5], // bottom right
    ]);
}

module screw_hole(h, x)
{
    color("blue") translate([x,0,h-7]) cylinder(7,2,5,$fn=20); translate([x,0,-0.001]) cylinder(h+1,2,2,$fn=20);
}

//oriented_air_tool();

difference(){
body();
    union() { oriented_air_tool(); screw_hole(12, 16); screw_hole(11, 39); }
}