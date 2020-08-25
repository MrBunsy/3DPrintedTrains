width=35;
length=75;

wall_thick=2;
base_thick=2;

height=31;
//aiming for side height of 26;
roof_radius=30;

plank_height=2.25;
plank_indent=0.1;
support_width = 1.5;
mid_support_width = 1.1;

door_width=0.5;
door_adornments_width=1;

door_length=length/3;

//from truck base
//wall thickness + screw head size + wiggle room
top_screw_holders_from_edge = 5;
m2_thread_size=2.2;
edge=5;

//similar but trying not the same as truck_base
module centredCube(width,length, height){
    translate([-width/2, -length/2,0]){
        cube([width,length, height]);
    }
    
}

//facing +ve x
module door(){
    translate([width/2,0,0]){
        rotate([0,0,45]){
                  //  cube([plank_height,plank_height,height*3],center = true);
                }
        difference(){
            centredCube(door_width,door_length,height*3);
            union(){
                //plank effects
                for(i=[-5:5]){
                    translate([sqrt(2)*plank_height/2+door_width/2-plank_indent,i*plank_height,0]){
                        rotate([0,0,45]){
                            cube([plank_height,plank_height,height*3],center = true);
                        }
                    }
                }
            }
        }
        //centreline
        centredCube(door_adornments_width,door_adornments_width,height);
        
        //either side
        translate([0,door_length/2,0]){
            centredCube(door_adornments_width,door_adornments_width,height);
        }
        translate([0,-door_length/2,0]){
            centredCube(door_adornments_width,door_adornments_width,height);
        }
        hinge_length = door_length*0.4;
        //hinges
        translate([0,-door_length/2+hinge_length/2,height*0.1]){
            centredCube(door_adornments_width,hinge_length,door_adornments_width);
        }
        translate([0,-(-door_length/2+hinge_length/2),height*0.1]){
            centredCube(door_adornments_width,hinge_length,door_adornments_width);
        }
        translate([0,-door_length/2+hinge_length/2,height*0.65]){
            centredCube(door_adornments_width,hinge_length,door_adornments_width);
        }
        translate([0,-(-door_length/2+hinge_length/2),height*0.65]){
            centredCube(door_adornments_width,hinge_length,door_adornments_width);
        }
    }
    
}


//intersect with horizontal cylinder for roof shape
intersection(){
        
    union(){
        difference(){
            union(){
            centredCube(width,length,base_thick);

            translate([width/2-wall_thick/2,0]){
                centredCube(wall_thick,length,height);
            }

            translate([-(width/2-wall_thick/2),0]){
                centredCube(wall_thick,length,height);
            }

            translate([0,length/2-wall_thick/2,0]){
                centredCube(width,wall_thick,height);
            }

            translate([0,-(length/2-wall_thick/2),0]){
                centredCube(width,wall_thick,height);
            }
        }
        
        //subtract notches to make things look like planks
        union(){
            for(i=[1:9]){
                //subtract all the bits to make it look like planks
                translate([width/2+sqrt(2)*wall_thick/2-plank_indent,0,i*plank_height]){
                    rotate([0,45,0]){
                        cube([wall_thick,length*2,wall_thick],center=true);
                    }
                }
            
            }
            rotate([0,0,90]){
                  for(i=[1:20]){
                //subtract all the bits to make it look like planks
                translate([length/2+sqrt(2)*wall_thick/2-plank_indent,0,i*plank_height]){
                    rotate([0,45,0]){
                        cube([wall_thick,length*2,wall_thick],center=true);
                    }
                }
            
            }
            }
            
            rotate([0,0,180]){
                  for(i=[1:9]){
                //subtract all the bits to make it look like planks
                translate([width/2+sqrt(2)*wall_thick/2-plank_indent,0,i*plank_height]){
                    rotate([0,45,0]){
                        cube([wall_thick,length*2,wall_thick],center=true);
                    }
                }
            
            }
            }
            rotate([0,0,-90]){
                  for(i=[1:20]){
                //subtract all the bits to make it look like planks
                translate([length/2+sqrt(2)*wall_thick/2-plank_indent,0,i*plank_height]){
                    rotate([0,45,0]){
                        cube([wall_thick,length*2,wall_thick],center=true);
                    }
                }
            
            }
            }
            
            //subtract screw holes as well
            
        translate([-(width/2-top_screw_holders_from_edge),0,0]){
            cylinder(r=m2_thread_size/2,h=height*2,$fn=200,center=true);
        }
        translate([(width/2-top_screw_holders_from_edge),0,0]){
            cylinder(r=m2_thread_size/2,h=height*2,$fn=200,center=true);
        }
        
        translate([0,length/2-edge/2,0]){
            cylinder(h=base_thick*5,r=m2_thread_size/2, $fn=200,center=true);
        }
        translate([0,-(length/2-edge/2),0]){
            cylinder(h=base_thick*5,r=m2_thread_size/2, $fn=200,center=true);
        }
        
        }
    }
        
        //posts in corners
        translate([width/2,length/2,0]){
            centredCube(support_width,support_width,height*100);
        }
        //posts in corners
        translate([-width/2,length/2,0]){
            centredCube(support_width,support_width,height*100);
        }
        //posts in corners
        translate([-width/2,-length/2,0]){
            centredCube(support_width,support_width,height*100);
        }
        //posts in corners
        translate([width/2,-length/2,0]){
            centredCube(support_width,support_width,height*100);
        }
        
        //mid supports
        translate([width/2,(length-door_length)/2,0]){
            centredCube(mid_support_width,mid_support_width,height*100);
        }
        //mid supports
        translate([width/2,-(length-door_length)/2,0]){
            centredCube(mid_support_width,mid_support_width,height*100);
        }
        //mid supports
        translate([-width/2,(length-door_length)/2,0]){
            centredCube(mid_support_width,mid_support_width,height*100);
        }
        //mid supports
        translate([-width/2,-(length-door_length)/2,0]){
            centredCube(mid_support_width,mid_support_width,height*100);
        }
        
        //end mid supports
        translate([(width/3)/2,-length/2,0]){
            centredCube(mid_support_width,mid_support_width,height*100);
        }
        translate([(-width/3)/2,-length/2,0]){
            centredCube(mid_support_width,mid_support_width,height*100);
        }
        translate([(width/3)/2, length/2,0]){
            centredCube(mid_support_width,mid_support_width,height*100);
        }
        translate([(-width/3)/2, length/2,0]){
            centredCube(mid_support_width,mid_support_width,height*100);
        }
        
        
        rotate([0,0,180]){
            door();
        }
        
        door();
    }

    //lop off the bits that would stick outside the roof
    translate([0,0,height-roof_radius]){
        rotate([90,0,0]){
            cylinder(r=roof_radius,h=length*2,center=true,$fn=200);
        }
    }
    }
    
    


