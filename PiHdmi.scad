// HDMI

// HDMI Connections on Raspberry Pi
include <PiDimensions.scad>;

module hdmi(params)
{
    width = params[1];
    depth = params[2];
    height = params[3];
    hdmi_offset = params[6];
    hdmi_width = params[7];
    hdmi_height = params[8];

   translate([-width/2 + hdmi_offset,
   -side_thick-depth/2+2.5,
   thickness+0.5])
   sweep(hdmi_height/2)
   cube([hdmi_width,6,hdmi_height], center=true);

// pi_w has micro HDMI
//if pi_w then
//
//hdmi_plug = translate(-width/2+hdmi_offset,
//   -side_thick-depth/2,
//   top_thick+standoff_height+board_thickness+0.2) * cube(hdmi_width*2/3,side_thick,hdmi_height/2)
//end
}


for (ex = examples())
    translate([0,ex[0],0])
    hdmi(ex[1]);
