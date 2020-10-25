
//centred in xy plane
module centredCube(x,y,width,length, height){
    translate([x-width/2, y-length/2,0]){
        cube([width,length, height]);
    }
    
}

module axle_mount_holes(width,length, axle_height, axle_depth, groove){
    extra_height = axle_height*0.4;
    union(){
                //cone for axle to rest in
                 translate([width/2+0.01,0,axle_height]){
                    rotate([0,-90,0]){
                        cylinder(h=axle_depth,r1=axle_depth/2, r2=0,$fn=200);
                    }
                }
                if(groove){
                    //groove to help slot axle in
                    translate([width/2,0,axle_height]){
                        rotate([0,0,45]){
                            centredCube(0,0,axle_depth*0.2,axle_depth*0.2,extra_height+0.01);
                        }
                    }
                }
                
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
            axle_mount_holes(width,length, axle_height, axle_depth);
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
            radius = 9;
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
module decorative_brake_mounts(x, length, height, lever_y, edge, thick){
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

module axle_holder(axle_space, x, axle_height, axle_distance, just_holes=false, grooves =true, width=2.5){
    
    length = 5;
    axle_depth = 1+(axle_width-axle_space)/2;
    
     mirror_xy() translate([-axle_space/2,-axle_distance/2,0]){
        if(just_holes){
            translate([-width/2,0,0])axle_mount_holes(width,length, axle_height, axle_depth, grooves);
        }else{
            axle_mount(width,length, axle_height, axle_depth);
        }
    }
}
module axle_holder_decoration(axle_space, x, axle_height, axle_distance){
    width = 2.5;
    length = 5;
    axle_depth = 1+(axle_width-axle_space)/2;
    
    translate([-axle_space/2,-axle_distance/2,0]){
        axle_mount_decoration(width,length, axle_height, axle_depth);
    }
    
    translate([-axle_space/2,axle_distance/2,0]){
        axle_mount_decoration(width,length, axle_height, axle_depth);
    }
    
    rotate([0,0,180]){
        translate([-axle_space/2,-axle_distance/2,0]){
            axle_mount_decoration(width,length, axle_height, axle_depth);
        }
        
        translate([-axle_space/2,axle_distance/2,0]){
            axle_mount_decoration(width,length, axle_height, axle_depth);
        }
    }  
}
coupling_mount_length=0.85*6;

module coupling_mount(height, base_thick = 0){
   
    side_holders_top_r = 0.85;
	side_holders_base_r = 2.5/2;
    top_r_distance=14+side_holders_top_r;
	base_width = top_r_distance+side_holders_base_r*2;
	base_length = side_holders_top_r*6;
	
    difference(){
		union(){
			cylinder(h=height,r=side_holders_top_r*6/2, $fn=200);
			if(base_thick > 0){
		translate([-base_width/2,-base_length/2,-base_thick])cube([base_width,base_length,base_thick]);
	}
		}
       
        translate([0,0,-0.1]){
            cylinder(h=(height+base_thick)*4,r=m2_thread_size/2, $fn=200, center=true);
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
        cylinder(h=height,r=side_holders_base_r,$fn=200);
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

//shape to exclude around a pair of wheels
module axle_hole(wheel_max_d,axle_space,wheel_centre_space){
    rotate([0,90,0]){
        difference(){
        cylinder(r=wheel_max_d/2,h=axle_space-0.5,$fn=200,center=true);
        cylinder(r=wheel_max_d/2+1,h=wheel_centre_space,$fn=200,center=true);
        }
    }
    
}
