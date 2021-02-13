/*
Copyright Luke Wallin 2020

This file is part of Luke Wallin's 3DPrintedTrains project.

The 3DPrintedTrains project is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

The 3DPrintedTrains project is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with The 3DPrintedTrains project.  If not, see <https:www.gnu.org/licenses/>.
*/

include <constants.scad>

//centred in xy plane TODO deprecate this
module centredCube(x,y,width,length, height){
    translate([x-width/2, y-length/2,0]){
        cube([width,length, height]);
    }
    
}

module axle_mount_holes(width,length, axle_height, axle_depth, groove=true){
    extra_height = axle_height*0.4;
	//echo ("axle_mount_holes width:",width,"axle_depth",axle_depth);
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
                            centred_cube(axle_depth*0.2,axle_depth*0.2,extra_height+0.01);
                        }
                    }
                }
                
            }
    
}

//single axle mount with insertion for axle, insertion facing right (+ve x)
module axle_mount(width,length, axle_height, axle_depth){
    
    extra_height = axle_height*0.4;
    
    //didn't actually want a centred cube, push it so the inside edge will be at the endge of axle_space
    translate([-width/2,0,0]){
        
        difference(){
            centred_cube(width,length, axle_height+extra_height);
            axle_mount_holes(width,length, axle_height, axle_depth);
        }
    }
    
    
}

//facing +ve x, 'width' in x direction is thickness of springs
//'length' in y direction
module cartsprings(width, length, height, springs=4){
    spring_thick = 0.4;
    //radius = (height*height - length*length/4)/(2*height);
    //hmm...
    radius = length*0.7;
    //good enough :/
    //radius = 9;
    for(i=[0:springs]){
        spring_length = (i+1)*length/springs;
        intersection(){
        translate([0,0,-radius+height]){
            
                rotate([0,-90,0]){
                    //main spring
                    difference(){
                        cylinder(h=width,r=radius-i*spring_thick);
                        cylinder(h=width*3,r=radius-spring_thick*(i+1), center=true);
                    }
                    //raised thinner bit
                    difference(){
                        cylinder(h=width+0.2,r=radius-i*spring_thick);
                        cylinder(h=width*3,r=radius-spring_thick*(i+0.5), center=true);
                    }
                }
                
            }
        
            centred_cube(width*3,spring_length, height);
        }
    }
}

//cartsprings, bracing and bearing box, 0,0 is where the axle slots into the holder
//width and length refer to the axle holder
module axle_mount_decoration(width,length, axle_height, subtract = false){
    small_thick = 0.4;
    decoration_thick = 1;
    bearing_mount_height = 3.5;
    bearing_mount_length=2.6;
	bearing_mount_back_scale = 1.4;
    
    extraMountRatio=0.8;
    mount_spring_link_y = axle_height-bearing_mount_height*(1/extraMountRatio)*0.8;

    //copy pasted...
    extra_height = axle_height*0.4;
    if(subtract){
        //carved out bit above the axle mount, above the springs
        translate([-width,0,0])centred_cube(small_thick*2,length/2,mount_spring_link_y-0.4*5);
    }else{
        
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
                translate([-width-decoration_thick/2,0, axle_height-bearing_mount_height/2]){
                    centred_cube(decoration_thick,bearing_mount_length,bearing_mount_height);
                }
                
                //ridge aroudn bearing mount
                translate([-width-decoration_thick/4,0, axle_height-bearing_mount_height*bearing_mount_back_scale/2]){
                    centred_cube(decoration_thick/2,bearing_mount_length*bearing_mount_back_scale,bearing_mount_height*(1+ (bearing_mount_back_scale-1)/2));
                }
                //sticky out bit at the bottom of hte mount
                translate([-width-decoration_thick-small_thick/2,0,axle_height+bearing_mount_height/2-small_thick])centred_cube(small_thick,small_thick,small_thick);
                //bar across the mount
                translate([-width-decoration_thick/2,0,axle_height])centred_cube(decoration_thick+small_thick,bearing_mount_length*bearing_mount_back_scale+small_thick,small_thick);
                
                
                //bit that links mount with cart springs
                translate([-width-decoration_thick*extraMountRatio,-bearing_mount_length*extraMountRatio/2, mount_spring_link_y]){
                    cube([decoration_thick*extraMountRatio,bearing_mount_length*extraMountRatio,bearing_mount_height*(1/extraMountRatio)]);
                }
                //cart springs! or at least, crude representations of
                translate([-width,0,0])cartsprings(decoration_thick, 12.6, mount_spring_link_y+decoration_thick/4);
                
            
                
            }//end of union
            //lopping off anything that sticks through the bottom
            translate([0,0, -50]){
            centred_cube(200,200,50);
            }
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
	//echo("axle_depth",axle_depth);
    
     mirror_xy() translate([-axle_space/2,-axle_distance/2,0]){
        if(just_holes){
            translate([-width/2,0,0])axle_mount_holes(width,length, axle_height, axle_depth, grooves);
        }else{
            axle_mount(width,length, axle_height, axle_depth);
        }
    }
}
module axle_holder_decoration(axle_space, x, axle_height, axle_distance, subtract = false){
    width = 2.5;
    length = 5;
    axle_depth = 1+(axle_width-axle_space)/2;
    
    mirror_xy()translate([-axle_space/2,axle_distance/2,0]){
        axle_mount_decoration(width,length, axle_height, subtract);
    }
}
coupling_mount_length=0.85*6;

//For hornby/bachmann. 0,0 is the central screwhole which should be coupling_from_edge from the edge
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
            cylinder(h=(height+base_thick)*4,r=m2_thread_size_vertical/2, $fn=200, center=true);
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

//0,0 is bottom of mount (as printed, top as finished) at the front. So 0,0 should be top centre of the base of a wagon (assumes overlap with base, unless minusHeight is used)
//facing +ve y
//extraHeight makes the slot for the coupling more tall - useful if printed in PETG rather than PLA (which droops a bit more when bridging)
module coupling_mount_dapol(minusHeight=0, extraHeight = 0){

    cylinder_from_edge = 7.5;

    wall_thick = 1;

    base_from_edge = 2.7;

    base_height = top_of_buffer_from_top_of_rail - top_of_coupling_from_top_of_rail - minusHeight;
    base_length = 6.4;

    r=2.4/2;

    coupling_width = 7.5;
    coupling_height = 1.65 + extraHeight;
    translate([0,-base_from_edge-base_length/2,0])centred_cube(coupling_width + wall_thick*2,base_length,base_height);
    translate([0,-cylinder_from_edge,base_height])cylinder(r=r,h=coupling_height);
    mirror_y()translate([coupling_width/2 + wall_thick/2,-base_from_edge-base_length/2,base_height])centred_cube(wall_thick,base_length,coupling_height+wall_thick);
    translate([0,-base_from_edge-base_length/2,base_height+coupling_height])centred_cube(coupling_width,base_length,wall_thick);

}

//just the coupling mount, for placement on anything other than a bog standard truck. (0,0,0) is top centre of coupling fixing,
//drop in replacement for coupling_mount with default arguments (extraheight of zero) for PETG add some extra height
module coupling_mount_dapol_alone(base_thick = 0, extra_height = 0){
	translate([0,0,-base_thick])coupling_mount_dapol(minusHeight=top_of_buffer_from_top_of_rail - top_of_coupling_from_top_of_rail - base_thick, extra_height);
}

//facing +ve y direction
module buffer(buffer_end_width, buffer_end_height, buffer_distance, buffer_length){
    
    
    difference(){
        centred_cube(buffer_end_width, buffer_length, buffer_end_height);
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
