// SD Card on Raspberry Pi
include <PiDimensions.scad>;

sd_card_width = 12;

module sd_card(params) {
  width = params[1];
  depth = params[2];
  space_above = 6;

  if (params[NAME] == "PiW")
  {
    // top_side of board
    translate([-width/2, 0, 3])
      cube([10,sd_card_width,6+7], center=true);
    // 5 gives room to insert
    
  }
  else
  {
    translate([-width/2, 0, 3])
      cube([12,sd_card_width,15], center=true);
    // 5 gives room to insert
  }

}

for (ex = examples())
    translate([0,ex[0],0])
    sd_card(ex[1]);
