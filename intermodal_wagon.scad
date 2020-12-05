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

include <truck_bits.scad>
include <constants.scad>
/*

Aiming for something halfway between an FTA and an FSA intermodal flat.

FSA have raised buffers one one end.
FTA have buffers on both ends, but I they're lower and only intended to be used with other FTAs or an FSA

Since I can't reduce the height of the bogies much, the lowest I can have buffers will be at "proper" height, but also inline with the bed, so it'll look like a FTA with buffers inline with the bed, but they'll be at the "proper" height like an end of a FSA.
I think this is good enough for my purposes.

Wishlist:

 - Attempt at real coupling hook?
 - Slight overhangs ("girder bits") on the two central arms
 - Girder bits on teh A-frames
 - Test if the yellow sticky out bits (look like tags) are printable

*/
dapol_wheels = true;
spoked = false;

//make screwholes that aren't easy to see
screwholes_for_containers = true;
//make screwholes at either end that are visible
screwholes_for_containers_at_front = false;
screwholes_for_containers_at_back = false;
screwhole_from_edge = 5;

wheel_diameter = getWheelDiameter(dapol_wheels, spoked);
box_wall_thick = 0.5;

//little bits that the iso containers lock into
container_hold_size = 1.5;
container_hold_spacing = 1;//0.5;//turns out this is exactly 1.5inches, which is exactly how short of 20feet a 20foot container is

//1.5" shy of twenty feet
twentyFootContainerLength = 20*4-0.5;
fortyFootContainerLength = 40*4;

//length=240 + buffer_mount_length*2;
//60ft
//FSA (from markings on side) real length = 19.57m -> 256.8mm (maybe with buffers?)
//FTA 20.54
//will stick to this for now
length=60*4;

//from one end in y, mirrored along x axis
//position is centre of hold in y axis
//4mm to the foot
//buffer end
hold_distances=[container_hold_size/2,
    twentyFootContainerLength-container_hold_size/2,
   twentyFootContainerLength+container_hold_spacing+container_hold_size/2,
   length/2 - container_hold_spacing/2 - container_hold_size/2,
   length/2 + container_hold_spacing/2 + container_hold_size/2,
   length - (twentyFootContainerLength+container_hold_spacing+container_hold_size/2),
   length - (twentyFootContainerLength-container_hold_size/2),
   length - container_hold_size/2
  ];

//axle_space + aprox max wheel diameter + wiggle room
bogie_length_max = 23 + 17 + 1;

//for cap over hole for m3 screws
min_thick=0.2;

width=30;
thick=3.5;
thick_bogie_area = 2;
edge_thick = 2;
girder_thick = min_thick*2.5;

buffer_section_length = 10;

bogie_from_end = bogie_length_max/2 + buffer_section_length;

//axle_height+thick from bogie
axle_to_top_of_bogie = 5.15;//4.5;

bogie_mount_height = top_of_buffer_from_top_of_rail - wheel_diameter/2 - axle_to_top_of_bogie - thick - m3_washer_thick;
//+ extra for cutting bits out
bogie_width_max = 30+5;

echo("bogie from end", bogie_from_end, "bogie height below top of buffer: ", bogie_mount_height + thick, "bogie height from underside", bogie_mount_height + thick - thick_bogie_area, "m3 screw hole depth ", bogie_mount_height + thick-min_thick);

middle_length = length - bogie_length_max-bogie_from_end*2;
underframe_height = axle_to_top_of_bogie + bogie_mount_height +thick;
underframe_middle_length = middle_length*0.8;

//want 40 feet, but bogies too big
underframe_middle_length_for_aframes = middle_length*0.9;//40*4;
//bogies are oversized, so bodge the end aframe positions
//underframe_middle_length_for_aframes_max = middle_length*0.9;
a_frame_spacing = [-underframe_middle_length_for_aframes/2,
    -10*4,
    -5*4,
    0,
    5*4,
    10*4,
    underframe_middle_length_for_aframes/2
   ];
underframe_middle_width = width/3;
underframe_middle_height = underframe_height*0.75;
a_frames = 4;
a_frame_length= 2 + 0.5;

mid_slot_width = width*0.1;

edge_slot_width = width*0.2;
edge_slot_r = width*0.25/2;
//holes near the buffer end. No idea what these are really for!
hole_r = edge_slot_width*0.4;
hole_from_end = buffer_section_length;

//i think distance between bogies is 11.93m -> 156.6mm

//to screw containers to flatbed
module holes_for_containers(holes = true){
    mid_holes = [
             -length/2 + twentyFootContainerLength - screwhole_from_edge,
             -length/2 + fortyFootContainerLength - screwhole_from_edge,
            
             length/2 - twentyFootContainerLength + screwhole_from_edge,
             length/2 - fortyFootContainerLength + screwhole_from_edge,
            ];
    front_hole = [-length/2+screwhole_from_edge];
	back_hole = [length/2-screwhole_from_edge];
	part1 = screwholes_for_containers_at_front ? concat(front_hole, mid_holes) : mid_holes;
	positions = screwholes_for_containers_at_back ? concat(back_hole, part1) : part1;
    if(holes){
            
        for(y = positions){
            echo("screw hole y", y);
            translate([0,y,0])cylinder(h=100,r=m2_thread_size_loose/2,center=true);
            
            translate([0,y,thick/2])cylinder(h=100,r=m2_washer_d /2);
        }
        
    }else{
        //extra padding for bits without substance to put hole in
        for(y = positions){
            //translate([0,y,0])cylinder(h=thick,r=m2_thread_size_loose*2/2);
        }
    }
    
    
}

module main_edge_slot(edge_slot_width, edge_slot_r){
    //main edge slot
        translate([0,0,-1])centredCube(width/2-edge_thick-edge_slot_width/2,0,edge_slot_width,underframe_middle_length_for_aframes,50);
        //curved shape at end
        hull(){
            translate([width/2-edge_thick-edge_slot_r,underframe_middle_length_for_aframes/2,0])cylinder(h=50,r=edge_slot_r, center=true);
            
            centredCube(width/2-edge_thick-edge_slot_width/2,underframe_middle_length/2,edge_slot_width,1,50);
        }
        //and other end
        mirror([0,1,0])hull(){
            translate([width/2-edge_thick-edge_slot_r,underframe_middle_length_for_aframes/2,0])cylinder(h=50,r=edge_slot_r, center=true);
            
            centredCube(width/2-edge_thick-edge_slot_width/2,underframe_middle_length/2,edge_slot_width,1,50);
        }
}


module bogie_sticky_out_bit(){
    //sticky out bit above bogies
    bogie_sticky_out_bit_size=2;
    hull(){
        centredCube(width/2+bogie_sticky_out_bit_size/2,
        length/2-bogie_from_end-bogie_sticky_out_bit_size*0.1,
        bogie_sticky_out_bit_size,
        bogie_sticky_out_bit_size*2,
        thick_bogie_area);
        
        centredCube(width/2+bogie_sticky_out_bit_size - bogie_sticky_out_bit_size*0.2,
        length/2-bogie_from_end+bogie_sticky_out_bit_size,
        bogie_sticky_out_bit_size*0.4,
        bogie_sticky_out_bit_size,
        thick_bogie_area);
    }
}
//centred on 0,0
module iso_container_hold(container_hold_size){
    //I'm sure I can produce something better than a cube, even at 0.5mm big
    centredCube(0,0,container_hold_size,container_hold_size,container_hold_size);
}

//little sticking out bits to lock into base of iso containers
module holds_on_one_side(){
    for(i=[0:len(hold_distances)-1]){
        translate([width/2+container_hold_size/2,-length/2 + hold_distances[i]]) iso_container_hold(container_hold_size);
    }
}

module bogie_space_punchout(){
    union(){
		 //space for bogies
			translate([0,length/2-bogie_from_end,thick_bogie_area])
				centredCube(0,0,bogie_width_max,bogie_length_max,thick);   
			
			translate([0,-(length/2-bogie_from_end),thick_bogie_area])
				centredCube(0,0,bogie_width_max,bogie_length_max,thick);   
			
			//tapered end to space for bogies
			translate([0,length/2-buffer_section_length,thick_bogie_area])rotate([45,0,0])translate([-width,0,0])cube([width*2,20,20]);
			mirror([0,1,0])translate([0,length/2-buffer_section_length,thick_bogie_area])rotate([45,0,0])translate([-width,0,0])cube([width*2,20,20]);
			
			translate([0,length/2-bogie_from_end-bogie_length_max/2,thick_bogie_area])rotate([45,0,0])translate([-width,0,0])cube([width*2,20,20]);
			 mirror([0,1,0])translate([0,length/2-bogie_from_end-bogie_length_max/2,thick_bogie_area])rotate([45,0,0])translate([-width,0,0])cube([width*2,20,20]);
		}
}

//join dots with a bar wide and thick (used for the girder bits)
//points = [ [x,y,z] ]
module extendoLine(points, width, thick){
		for(i =[0:len(points)-1]){
			i2 = i + 1 >= len(points) ? 0 : i+1;
			hull(){
				translate(points[i])translate([-width/2,-thick/2,-thick/2])cube([width,thick,thick]);
				translate(points[i2])translate([-width/2,-thick/2,-thick/2])cube([width,thick,thick]);
			}
		}
}

difference(){
union(){
    //main wagon, with the slots subtracted (but no a-frames or other cosmetics)
    difference(){
        union(){
            difference(){
                centredCube(0,0,width,length, thick);
                bogie_space_punchout();
            }
            translate([0,length/2-bogie_from_end,0])
                cylinder(h=bogie_mount_height+thick,r=m3_thread_d);
            
             translate([0,-(length/2-bogie_from_end),0])
                cylinder(h=bogie_mount_height+thick,r=m3_thread_d);
            
            //a-frame like underside lengthways
            hull(){
                centredCube(0,0,underframe_middle_width,underframe_middle_length,underframe_height);
                centredCube(0,0,underframe_middle_width,middle_length-thick,thick);
            }
            
            //extra girder-like bits near buffer
    mirror_x(){
		bogie_area_length_top = bogie_length_max+(thick-thick_bogie_area)*2;
		
		bogie_y = length/2-bogie_from_end;

		
		//buffer end
        centredCube(0,length/2-girder_thick/2,width+girder_thick*4,girder_thick,thick);
        //bogie_area_length = (length-middle_length+thick)/2;
		/*
		//bottom of bogie area
        centredCube(0,length/2-bogie_area_length/2,width+girder_thick*2,bogie_area_length,girder_thick);
        //top of bogie area
        translate([0,0,thick_bogie_area-girder_thick])centredCube(0,length/2-bogie_from_end,
			width+girder_thick*2,bogie_length_max,girder_thick);
		//from base to near aframe end
		centredCube(0,length/2-bogie_area_length/2-bogie_area_length/2,
			width+girder_thick*2,girder_thick,thick);
		
		hull(){
			
		}
       */
		extendoLine([
			[0,length/2-girder_thick/2,thick-girder_thick/2], //bottom of buffers	 (when upright)
			[0,length/2-girder_thick/2,girder_thick/2],//top of buffers (when upright)
			[0,bogie_y-bogie_area_length_top/2-girder_thick/2,girder_thick/2],//top of end of a-frames
			[0,length/2-girder_thick/2-bogie_from_end-bogie_area_length_top/2,thick-girder_thick/2],//bottom of end of a-frames
			[0,bogie_y-bogie_length_max/2,thick_bogie_area-girder_thick/2],//bottom of bogie area
			[0,bogie_y+bogie_length_max/2,thick_bogie_area-girder_thick/2],//bottom of buffer end bogie area
			[0,bogie_y+bogie_area_length_top/2+girder_thick/2,thick-girder_thick/2]//bottom of buffer area
		]
		, width+girder_thick*2,girder_thick);
		
		centredCube(0,length/2-buffer_section_length/2,
			width+girder_thick*2,girder_thick,thick);
		centredCube(0,length/2-+thick/2,	width+girder_thick*2,thick,thick);
		centredCube(0,length/2-buffer_section_length+thick/2,
			width+girder_thick*2,girder_thick,thick);
        
    }
            
            
        }
        
        union(){
            //holes for bogies to screw in
            mirror_x()translate([0,(length/2-bogie_from_end),0]){
                translate([0,0,min_thick])cylinder(h=100,r=m3_thread_d/2);
            }
            
            //holes for buffers
            mirror_xy(){
				translate([-buffer_distance/2,length/2,thick/2]){
					rotate([90,0,0]){
					//holes to hold buffers
					cylinder(h=buffer_holder_length*2, r=buffer_holder_d/2, $fn=200, center=true);
					}
				}
				box_start_y = length/2;
				box_end_y = length/2 - (buffer_section_length - hole_r);
				box_length = box_start_y - box_end_y;
				box_size = buffer_holder_d*3;
				//hollow out a box under the buffers
				translate([0,0,box_wall_thick])
					centredCube(buffer_distance/2,box_start_y - box_length*0.6,
				box_size,box_length/2,thick);
				echo("buffer box:",box_size,box_size,thick-box_wall_thick);
			}
			//holes for where real coupling hook would be
			
			mirror_x()translate([0,0,girder_thick])centredCube(0,length/2,width/3,girder_thick*2,thick-girder_thick*2);


            
            
            //long slot down the centre
            hull(){
                end_r = width*0.04;
                
                mirror_x()translate([0,underframe_middle_length/2,0])cylinder(h=50,r=end_r, center=true);
                translate([0,0,-1])centredCube(0,0,mid_slot_width,underframe_middle_length-end_r*2,50);
            }
            //slots either side
            
            
            
            main_edge_slot(edge_slot_width, edge_slot_r);
            mirror([1,0,0])main_edge_slot(edge_slot_width, edge_slot_r);
            
            
            
            mirror_xy()translate([(width/2 - hole_r*2),(length/2-hole_from_end),0])cylinder(r=hole_r, h=50, center=true);
        }
    }
    
    //a frames and various additional cosmetics

    //the a-frames don't get holes punched out, so do them separatly
    difference(){
        union(){
            //a_frame_spacing = underframe_middle_length_for_aframes/a_frames;
            for(i=[0:len(a_frame_spacing)]){
                translate([0, a_frame_spacing[i]])
                hull(){
                    centredCube(0,0,underframe_middle_width,a_frame_length,underframe_middle_height);
                    centredCube(0,0,width,a_frame_length,thick);
                }
            }
            //two extra in the centre
            for(i=[0:2]){
                translate([0,-a_frame_spacing/2 + i*a_frame_spacing/2])
                hull(){
                    centredCube(0,0,underframe_middle_width,a_frame_length,underframe_middle_height);
                    centredCube(0,0,width,a_frame_length,thick);
                }
            }
        }
            
        hull(){
            translate([0,0,-0.01])centredCube(0,0, mid_slot_width,length,thick);
            translate([0,0,-1])centredCube(0,0, width-edge_thick*2,length,1);
        }
    }

    //box behind the brake wheel
    //inline with bed, because just below bed printed badly
    difference(){
            centredCube(width/2-edge_thick*1.5-edge_slot_width/2,
                length/2 - 20*4+edge_slot_width/2+a_frame_length/2+container_hold_spacing,
                edge_slot_width+edge_thick*2,
                edge_slot_width,
                edge_slot_width
            );
        //make it hollow (easier to deal with the slot-in wheels getting stuck)
        
        translate([0,0,thick/2])//min_thick
            centredCube(width/2-edge_thick*1.5-edge_slot_width/2,
                length/2 - 20*4+edge_slot_width/2+a_frame_length/2+container_hold_spacing,
                edge_slot_width,
                edge_slot_width-box_wall_thick*2,
                edge_slot_width
            );
    }
    //other side doesn't have one, but we need something for the wheel to slot into
     mirror([1,0,0])   translate([0,0,min_thick])
        centredCube(width/2-edge_thick/2,
            length/2 - 20*4+edge_slot_width/2+a_frame_length/2+container_hold_spacing,
            edge_thick,
            edge_slot_width,
            edge_slot_width
        );

    //flat bits, no idea what they're for
    //wanted to make them lower than the rest of the bed, but that pritns really badly
    flat_bits_depth = 0;
    translate([0,0,flat_bits_depth]){
        difference(){
            centredCube(-(width/2-edge_thick*1.5-edge_slot_width/2),
            0,
            edge_slot_width+edge_thick*2,
            10*4-a_frame_length,
            thick
            );
            translate([0,0,-50])centredCube(0,0,width*2,a_frame_length,100);
        }
        
    }
    plaque_thick = 1;

    //info plaques
    mirror_xy()centredCube(width/2-plaque_thick/2,length*0.235,plaque_thick,a_frame_length*3,thick*2);

    mirror_xy()bogie_sticky_out_bit();
  
    mirror_y()holds_on_one_side();
    
    if(screwholes_for_containers){
        //extra material for where it's needed
                holes_for_containers(false);
            }
    
}//end massive union

    union(){
        //holes for the brake wheels to be inserted
        mirror_y()translate([width/2,
                length/2 - 20*4+edge_slot_width/2+a_frame_length/2+container_hold_spacing,
                thick]){
            rotate([0,90,0]){
            //holes to hold buffers
            cylinder(h=buffer_holder_length*2, r=buffer_holder_d/2, $fn=200, center=true);
            }
        }
		
		cylinder_hole_spacing = 2*4;
		//holes for the cylinder to be inserted
		//a-frames are 5 feet apart, so middle of the one off centre
		translate([underframe_middle_width/2, 2.5*4-cylinder_hole_spacing/2,thick+(underframe_height-thick)/2]){
            rotate([0,90,0]){
            //holes to hold buffers
            cylinder(h=buffer_holder_length*2, r=buffer_holder_d/2, $fn=200, center=true);
            }
        }
		translate([underframe_middle_width/2, 2.5*4+cylinder_hole_spacing/2,thick+(underframe_height-thick)/2]){
            rotate([0,90,0]){
            //holes to hold buffers
            cylinder(h=buffer_holder_length*2, r=buffer_holder_d/2, $fn=200, center=true);
            }
        }

		if(screwholes_for_containers){
			holes_for_containers(true);
		}
		
		
        
    }

}//end difference