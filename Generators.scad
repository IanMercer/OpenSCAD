// [[ creates four of something inside (or outside) a rectangle width x depth --]]
module quad_asm(width, depth, 
   oxleft, oxright, oybottom, oytop)
{
     translate([-width/2-oxleft,-depth/2-oybottom,0])
      children();
       
     translate([-width/2-oxleft,depth/2+oytop,0])
      mirror([0,1,0])
      children();
       
     translate([width/2+oxright,depth/2+oytop,0])
      mirror([1,0,0])
      mirror([0,1,0])
      children();
       
     translate([width/2+oxright,-depth/2-oybottom,0])
     mirror([1,0,0])
     children();
}

module quad_rim(width, depth, 
   oxleft, oxright, oybottom, oytop, cg)
{
    hull(){
     translate([-width/2-oxleft,cg-depth/2-oybottom,0])
      children();
       
     translate([-width/2-oxleft,depth/2+oytop-cg,0])
      mirror([0,1,0])
      children();
    }

    hull(){
    translate([cg-width/2-oxleft,depth/2+oytop,0])
      mirror([0,1,0])
      children();
        
     translate([width/2+oxright-cg,depth/2+oytop,0])
      mirror([1,0,0])
      mirror([0,1,0])
      children();
        
    }

    hull()
    {
     translate([width/2+oxright,depth/2+oytop-cg,0])
      mirror([1,0,0])
      mirror([0,1,0])
      children();
        
     translate([width/2+oxright,cg-depth/2-oybottom,0])
     mirror([1,0,0])
     children();
        
    }
    
    hull()
    {
     translate([width/2+oxright-cg,-depth/2-oybottom,0])
     mirror([1,0,0])
     children();
 
     translate([cg-width/2-oxleft,-depth/2-oybottom,0])
      children();
    }
}


// [[ creates four of something inside (or outside) a rectangle width x depth --]]
module quad(width, depth, ox, oy)
{
     translate([-width/2-ox,-depth/2-oy,0]) children();
     translate([-width/2-ox,depth/2+oy,0]) mirror([0,1,0]) children();
     translate([width/2+ox,depth/2+oy,0]) mirror([1,0,0]) mirror([0,1,0]) children();
     translate([width/2+ox,-depth/2-oy,0]) mirror([1,0,0]) children();
}


// [[ creates eight of something inside (or outside) a cube width x depth x height, z=0 --]]
module octo(w, d, h, oxleft, oxright, oybottom, oytop, oz)
{
  translate([0,0,-oz/2])
  quad_asm(w, d, oxleft, oxright, oybottom, oytop)
    children(); 
  translate([0,0,h+oz/2])
  quad_asm(w, d, oxleft, oxright, oybottom, oytop)
    children(); 
}
