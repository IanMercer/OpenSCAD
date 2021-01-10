// Pi Audio
include <PiDimensions.scad>;


module audio(params)
{
    width = params[1];
    depth = params[2];
    height = params[3];

  if (params[0] != "PiW")
  {
      // audio plug  
      translate([
      -width/2+53.5,
      -gap-depth/2+3,
      5])
      rotate([90,0,0])
      cylinder(3*side_thick,3.5,3.5, center=true);
        
      // audio socket
      translate([-width/2+53.5,
      -gap-depth/2-side_thick/2+1.5,
      5])
      sweep(4.2+2)
      rotate([90,0,0])
      cylinder(4,4.2,4.2, center=true);
      ;
      
  }
}

for (ex = examples())
    translate([0,ex[0],0])
    audio(ex[1]);
