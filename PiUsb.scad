// USB Connections on Raspberry Pi
include <PiDimensions.scad>;

micro_usb_height = 3;

module usbs(params) {
    width = params[WIDTH];
    depth = params[DEPTH];
    height = params[HEIGHT];
    usb_offset = params[4];
    second_usb_offset = params[5];

// primary usb power
  translate([
   -width/2+usb_offset,
   -depth/2+3, 
   thickness-.01+micro_usb_height/2])
    sweep(micro_usb_height-0.5)
  cube([
    9,10,
    micro_usb_height],center=true);
    
// secondary usb (PiW)

  translate([-width/2+second_usb_offset,
    -depth/2+3, 
   thickness-.01+micro_usb_height/2])
   sweep(micro_usb_height)
  cube([
    9,10,
    micro_usb_height],center=true);

// hole for plug
  translate([-width/2+usb_offset,
  -side_thick-depth/2-gap,
  thickness+.2])
  cube([12,side_thick+gap+6,7],center=true);
  
  // USB on side for Pi3A
  if (params[NAME]=="Pi3A")
  {
      // carve out an area above and for the side USB
  translate([
   width/2,
   4,  // 4mm north of center line 
   height/2+thickness-.01])
  cube([9,12,height],center=true);
      
      
      
  }
  
}

for (ex = examples())
    color(ex[2])
    translate([0,ex[0],0])
    usbs(ex[1]);
