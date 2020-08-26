//pointy bit to pointy bit of spare hornby axles
axle_width = 25.65;

//distance between the two axle holders (along the axle)
//bachman spacing
axle_space = 23.0;
//hornby is 23.0
//bachman 22.2

//distance between the two axles (perpendicular to each axle)
axle_distance = 40;

//width of the bar holding the buffers
buffer_end_width = 35;
buffer_end_height = 3.5;
//length in y axis
buffer_length = 1.5;
//how far apart the centres of the buffers are
buffer_distance = 22.2;
buffer_holder_d = 2;//1.7;
buffer_holder_length = 3;

width=30;//28;
length=75;
thick = 3.5;

//wall thickness + screw head size + wiggle room
top_screw_holders_from_edge = 5;

//1.7 tiny bit too tight
//1.9 fine for the coarse thread screws, bit tight for fine 
//2.1 seems to print fine in grey PLA, but not black... trying 2.25
//2.25 thread slipped on one screw
//trying 2.0 for a real m2, not whatever it was I was using before
m2_thread_size=2.0;
m2_head_size=4.5;


//min length required to hold the metal weight
weight_length=60+3;
//min width required to hold the metal weight
weight_width=9.7+1;
weight_depth=3;

//how deep below the "top" surface the head of a scre should sit
screw_depth = 2;


//diameter around which there can be no obstructions for the wheels
wheel_max_space = 17;

//for height of couplings and axle mounts - diameter of the thinner bit of
//the wheel that rests on the rails
//13.5 for the old coach wheels, truck wheels usually smaller (13.15)
wheel_diameter = 14.0;

axle_height = 5;


edge=5;
edge_ends=5;

//centred in xy plane
module centredCube(x,y,width,length, height){
    translate([x-width/2, y-length/2,0]){
        cube([width,length, height]);
    }
    
}

//single axle mount with insertion for axle, insertion facing right (+ve x)
module axle_mount(width,length, axle_height, axle_depth){
    //translate([width*0.5-0.01,0.1,axle_height]){
      //          rotate([0,-90,0]){
        //            cylinder(h=width+0.01,r1=width*0.2, r2=0,$fn=200);
          //      }
            //}
    
    extra_height = axle_height*0.4;
    
    //didn't actually want a centred cube, push it so the inside edge will be at the endge of axle_space
    translate([-width/2,0,0]){
        
        difference(){
            centredCube(0,0,width,length, axle_height+extra_height);
            union(){
                //cone for axle to rest in
                 translate([width/2+0.01,0,axle_height]){
                    rotate([0,-90,0]){
                        cylinder(h=axle_depth,r1=axle_depth/2, r2=0,$fn=200);
                    }
                }
                //groove to help slot axle in
                translate([width/2,0,axle_height]){
                    rotate([0,0,45]){
                        centredCube(0,0,axle_depth*0.2,axle_depth*0.2,extra_height+0.01);
                    }
                }
                
            }
        }
    }
    
    
}
//cartsprings, bracing and bearing box
module axle_mount_decoration(width,length, axle_height, axle_depth){
    
    decoration_thick = 1;
    bearing_mount_height = 3;
    bearing_mount_length=2;
    
    //copy pasted...
    extra_height = axle_height*0.4;
    
    //little ledge at the bottom
    
    translate([-width-decoration_thick/2, -length/2, axle_height+extra_height-decoration_thick/2]){
        cube([decoration_thick/2, length, decoration_thick/2]);
    }
    
    //try and make it look like a real axle mount
    difference(){
        union(){
            
            //some sloping side holders for the axle mount
            
            //note, sticking with length in +ve, width in +ve x
            wonkyBitAngle = 65;
            //length along the angle
            wonkyBitLength = axle_height*1.2/sin(wonkyBitAngle);
            //length in y axis
            wonkyBitYFootprint = wonkyBitLength*cos(wonkyBitAngle);
            wonkyBitZHeight = wonkyBitLength*sin(wonkyBitAngle);
            
            translate([0,-wonkyBitYFootprint-length/2,0]){
                rotate([wonkyBitAngle,0,0]){
                    //surface we want is lying flat in the xy plane
                    translate([-width, 0, -decoration_thick]){
                        cube([decoration_thick, wonkyBitLength, decoration_thick]);
                 }
                }
            }
            
            translate([decoration_thick-width*2,0,0]){
                rotate([0,0,180]){
                    translate([0,-wonkyBitYFootprint-length/2,0]){
                        rotate([wonkyBitAngle,0,0]){
                            //surface we want is lying flat in the xy plane
                            translate([-width, 0, -decoration_thick]){
                                cube([decoration_thick, wonkyBitLength, decoration_thick]);
                         }
                        }
                    }
                }
            }   
            //bearing mount
            translate([-width-decoration_thick,-bearing_mount_length/2, axle_height-bearing_mount_height/2]){
                cube([decoration_thick,bearing_mount_length,bearing_mount_height]);
            }
            
            extraMountRatio=0.8;
            
            translate([-width-decoration_thick*extraMountRatio,-bearing_mount_length*extraMountRatio/2, axle_height-bearing_mount_height*(1/extraMountRatio)*0.8]){
                cube([decoration_thick*extraMountRatio,bearing_mount_length*extraMountRatio,bearing_mount_height*(1/extraMountRatio)]);
            }
            //cart springs! or at least, crude representations of
            radius = 8;
            translate([-width-decoration_thick,0,-radius+axle_height-decoration_thick*2.2]){
                rotate([0,90,0]){
                    difference(){
                    cylinder(h=decoration_thick,r=radius,$fn=200);
                    cylinder(h=decoration_thick*3,r=radius-decoration_thick,$fn=200, center=true);
                    }
                }
            }
        
            
        }//end of union
        //lopping off anything that sticks through the bottom
        translate([-500, -500, -100]){
        cube([1000,1000,100]);
        }
    }
    
    
}

//on the +ve x side
module decorative_brake_mounts(x, length, height, lever_y, edge){
    decoration_thick = 1;
    
   
    
    wonkyBitAngle = 65;
    //length along the angle
    wonkyBitLength = height/sin(wonkyBitAngle);
    //length in y axis
    wonkyBitYFootprint = wonkyBitLength*cos(wonkyBitAngle);
    wonkyBitZHeight = wonkyBitLength*sin(wonkyBitAngle);
    
    //accidentally developed on wrong side
    mirror([1,0,0]){
    
    //A frame with centred pillar
    translate([0,-wonkyBitYFootprint/2-decoration_thick/2,wonkyBitZHeight/2]){
        rotate([wonkyBitAngle,0,0]){
            //put it so it's inline with the surface plane
            translate([0,0,-decoration_thick]){
                centredCube(x, 0, decoration_thick*2,wonkyBitLength,decoration_thick);
            }
        }
    }
    centredCube(x, 0, decoration_thick*2,decoration_thick,height);
    translate([0,wonkyBitYFootprint/2+decoration_thick/2,wonkyBitZHeight/2]){
        rotate([-wonkyBitAngle,0,0]){
            //put it so it's inline with the surface plane
            translate([0,0,-decoration_thick]){
                centredCube(x, 0, decoration_thick*2,wonkyBitLength,decoration_thick);
            }
        }
    }
    
    //"brake pad" bits
    centredCube(x,length/2,decoration_thick*2,decoration_thick,height);
    centredCube(x,-length/2,decoration_thick*2,decoration_thick,height);
    
    //levers to push brake pads
    //these should be at an angle, but not sure that will print
    translate([0,0,height*0.5]){
        centredCube(x,-length/4,decoration_thick*2,length/2,decoration_thick);
    }
    
    translate([0,0,height*0.7]){
        centredCube(x,length/4,decoration_thick*2,length/2,decoration_thick);
    }
    
    //lever to control brakes
        translate([0,0,-thick/2])
        centredCube(edge,lever_y,decoration_thick*2, decoration_thick, height+thick/2);
        
        bottom_size = decoration_thick*2;
        translate([0,0, height-decoration_thick]){
            centredCube(edge-bottom_size/2,lever_y-bottom_size/2,bottom_size, bottom_size, decoration_thick);
        }
    }
}

module axle_holder(axle_space, x, axle_height){
    
    width = 2.5;
    length = 5;
    axle_depth = 1+(axle_width-axle_space)/2;
    
    translate([-axle_space/2,-axle_distance/2,0]){
        axle_mount(width,length, axle_height+thick, axle_depth);
        axle_mount_decoration(width,length, axle_height+thick, axle_depth);
    }
    
    translate([-axle_space/2,axle_distance/2,0]){
        axle_mount(width,length, axle_height+thick, axle_depth);
        axle_mount_decoration(width,length, axle_height+thick, axle_depth);
    }
    
    rotate([0,0,180]){
        translate([-axle_space/2,-axle_distance/2,0]){
            axle_mount(width,length, axle_height+thick, axle_depth);
            axle_mount_decoration(width,length, axle_height+thick, axle_depth);
        }
        
        translate([-axle_space/2,axle_distance/2,0]){
            axle_mount(width,length, axle_height+thick, axle_depth);
            axle_mount_decoration(width,length, axle_height+thick, axle_depth);
        }
    }
    
    
    
}

module coupling_mount(height){
   
    side_holders_top_r = 0.85;
    top_r_distance=14+side_holders_top_r;
    difference(){
        cylinder(h=height,r=4.8/2, $fn=200);
       
        translate([0,0,-0.1]){
            cylinder(h=height*2,r=m2_thread_size/2, $fn=200);
        }
    }
    
    translate([top_r_distance/2,0]){
        cylinder(h=height+1.2,r=side_holders_top_r,$fn=200);
        cylinder(h=height,r=2.5/2,$fn=200);
        translate([-side_holders_top_r/2,0,0]){
            cube([side_holders_top_r,side_holders_top_r*3,height]);
        }
    }
    translate([-top_r_distance/2,0]){
        cylinder(h=height+1.2,r=side_holders_top_r,$fn=200);
        cylinder(h=height,r=2.5/2,$fn=200);
        translate([-side_holders_top_r/2,0,0]){
            cube([side_holders_top_r,side_holders_top_r*3,height]);
        }
    }
    
    
}

//facing +ve y direction
module buffer(buffer_end_width, buffer_end_height, buffer_distance, buffer_length){
    
    
    difference(){
        centredCube(0,0,buffer_end_width, buffer_length, buffer_end_height);
        union(){
            translate([-buffer_distance/2,0,buffer_end_height/2]){
                rotate([90,0,0]){
                //holes to hold buffers
                cylinder(h=buffer_length*2, r=buffer_holder_d/2, $fn=200, center=true);
                }
            }
            translate([buffer_distance/2,0,buffer_end_height/2]){
                rotate([90,0,0]){
                //holes to hold buffers
                cylinder(h=buffer_length*2, r=buffer_holder_d/2, $fn=200, center=true);
                }
            }
        }
    }
    
}


difference(){

//main body of the truck
    union(){
        //base with hole in the middle
        difference(){
            translate([-width/2, -length/2,0]){
                cube([width,length,thick]);
            }
            
               translate([edge-width/2, edge_ends-length/2,-thick]){
                cube([width-edge*2,length-edge_ends*2,thick*3]);
            }
            
        }
        //girder-bits 
        //for the buffers
        girder_thick=0.5;
        centredCube(0,length/2-girder_thick/2-buffer_length,buffer_end_width,girder_thick,girder_thick);
        translate([0,0,thick-girder_thick]){
            centredCube(0,length/2-girder_thick/2-buffer_length,buffer_end_width,girder_thick,girder_thick);
        }
        rotate([0,0,180]){
            centredCube(0,length/2-girder_thick/2-buffer_length,buffer_end_width,girder_thick,girder_thick);
            translate([0,0,thick-girder_thick]){
                centredCube(0,length/2-girder_thick/2-buffer_length,buffer_end_width,girder_thick,girder_thick);
            }
        }
        //for the sides
        centredCube(width/2+girder_thick/2,0,girder_thick, length,girder_thick);
        translate([0,0,thick-girder_thick]){
            centredCube(width/2+girder_thick/2,0,girder_thick, length,girder_thick);
        }
        rotate([0,0,180]){
            centredCube(width/2+girder_thick/2,0,girder_thick, length,girder_thick);
            translate([0,0,thick-girder_thick]){
                centredCube(width/2+girder_thick/2,0,girder_thick, length,girder_thick);
            }
        }
        
        
        weightHolderLength=3;
        //extra bit to hold the metal weight
        centredCube(0,length/2-edge_ends - weightHolderLength/2,width-edge*2,weightHolderLength,weight_depth+1.5);
        centredCube(0,-(length/2-edge_ends - weightHolderLength/2),width-edge*2,weightHolderLength,weight_depth+1.5);
        
        //buffers
        translate([0,length/2-buffer_length/2,0]){
    buffer(buffer_end_width, buffer_end_height, buffer_distance, buffer_length);
}
rotate([0,0,180]){
    translate([0,length/2-buffer_length/2,0]){
        buffer(buffer_end_width, buffer_end_height, buffer_distance, buffer_length);
    }
}   
    //arm across the middle
        centredCube(0,0,width-edge,5,thick);
    
        //decorative brake system
        translate([0,0,thick]){
            decorative_brake_mounts(width/2-edge/2, axle_distance-wheel_max_space, axle_height*1.3,axle_distance/2+wheel_max_space*0.25, width/2);
            rotate([0,0,180]){
                decorative_brake_mounts(width/2-edge/2, axle_distance-wheel_max_space,axle_height*1.3, axle_distance/2+wheel_max_space*0.25, width/2);
            }
        }
    }    
    
//union of all the holes to punch out
    union(){
        //space for wheels
        translate([0,-axle_distance/2,0]){
            cube([axle_space,wheel_max_space,thick*3], center=true);
        }
        translate([0,axle_distance/2,0]){
            cube([axle_space,wheel_max_space,thick*3], center=true);
        }
        //extra deep hole for couplings
        translate([0,length/2-edge/2,-thick]){
            cylinder(h=thick*4,r=m2_thread_size/2, $fn=200);
        }
        translate([0,-(length/2-edge/2),-thick]){
            cylinder(h=thick*3,r=m2_thread_size/2, $fn=200);
        }
        //place for weight
        translate([0,0,-1]){
            centredCube(0,0,weight_width,weight_length,weight_depth+1);
        }
        

        //holes for screws in centre
        translate([width/2-top_screw_holders_from_edge,0,screw_depth]){
            cylinder(r=m2_head_size/2,h=thick*3,$fn=200);
            cylinder(r=m2_thread_size/2,h=thick*3,$fn=200,center=true);
        }
        
        
         //holes for screws in sides
        translate([-(width/2-top_screw_holders_from_edge),0,screw_depth]){
            cylinder(r=m2_head_size/2,h=thick*3,$fn=200);
            cylinder(r=m2_thread_size/2,h=thick*3,$fn=200,center=true);
        }
        
        //holes for buffers
        translate([-buffer_distance/2,length/2-buffer_length/2,buffer_end_height/2]){
            rotate([90,0,0]){
            //holes to hold buffers
            cylinder(h=buffer_holder_length*2, r=buffer_holder_d/2, $fn=200, center=true);
            }
        }
        translate([buffer_distance/2,length/2-buffer_length/2,buffer_end_height/2]){
            rotate([90,0,0]){
            //holes to hold buffers
            cylinder(h=buffer_holder_length*2, r=buffer_holder_d/2, $fn=200, center=true);
            }
        }
        translate([-buffer_distance/2,-(length/2-buffer_length/2),buffer_end_height/2]){
            rotate([90,0,0]){
            //holes to hold buffers
            cylinder(h=buffer_holder_length*2, r=buffer_holder_d/2, $fn=200, center=true);
            }
        }
        translate([buffer_distance/2,-(length/2-buffer_length/2),buffer_end_height/2]){
            rotate([90,0,0]){
            //holes to hold buffers
            cylinder(h=buffer_holder_length*2, r=buffer_holder_d/2, $fn=200, center=true);
            }
        }
        
    }
}

//2.5 from the height of the coupling, also unhelpfully called coupling_height in the coupling .scad file
coupling_height = axle_height + wheel_diameter/2 - 2.5 - 5;
//want to try and get bottom of coupling 5mm from top of the rails

translate([0,length/2-edge/2,thick]){
    coupling_mount(coupling_height);
}

translate([0,-(length/2-edge/2),thick]){
    rotate([0,0,180]){
        coupling_mount(coupling_height);
    }
}

axle_holder(axle_space, 20, axle_height);



