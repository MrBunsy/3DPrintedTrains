/*
Copyright Luke Wallin 2021

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

/*
Seen three obvious variants:

 - MWA Green freightliner with thin panel for logo on side and parking break roughly centre of wagon
 - MWA-B Grey freightliner with tall panel for logo on side and parking break on one bogie
 
 not to be confused with
 - MMA Red DB different numbers of ridges, different ends but parking brake in same place as green freightliner
 
  - MJA looks similar to MWA but wagons come in pairs
 
 Plan: green freightliner design seems easiest, althouhg might still consider printing it in any of the colours
 
 
 as usual 'width' usually refers to anything in the x direction and 'length' in y
 
 ideally want 10.5mm wheels but I've only got 12.5mm, so might just raise the whole thing up a bit

*/
include <truck_bits.scad>
include <constants.scad>
include <threads.scad>

wheel_diameter = 12.5;

GEN_IN_SITU = false;
GEN_WAGON = false;
GEN_BOGIE = true;
GEN_BRAKE_WHEEL = false;
GEN_BRAKE_CYLINDER = false;
GEN_BUFFER = false;

//copying intermodal wagon
buffer_area_thick = 3.5;

bogie_distance = m2mm(8.52);
//bogie axles appear to be 2metres apart
bogie_axle_distance = m2mm(2);

bogie_inner_width = 22;

//as measured from picture
axle_to_top_of_bogie = 5.8;

//total length includes buffers
total_length = m2mm(13.97);
//these are mostly dervived from a picture I un-perspectvied and printed out at the right size

//height of the base of the wagon above rails.
//this is not measured, this is tweaked so the buffers, at centre_of_buffer_from_top_of_rail, look like they're in the right place
//the total height may therefore be 'wrong' but they'll match other OO gauge wagons
wagon_base_above_rails = 14.5;

//length of the base,not including buffers
wagon_length = m2mm(13.97-0.62*2);//168.5;//170.1;
wagon_end_flange_length = (170.1-wagon_length)/2;
//complete guess if I'm honest, same as the container wagons
wagon_width = 30;
//starting from 'base' which is the flat bit above the bogies
//wagon_height = 28.5; - possibly correct if my photo really is squashed
wagon_height = 28.5;//30;

brake_wheel_d = 7;

side_ridge_length = 2.2;
side_ridge_length2 = 3.1;
side_ridge_thicker_length = 3;
top_ridge_height = 2.8;
top_ridge_thick = top_ridge_height*0.5;
top_ridge_flange_height=5.5;
side_ridge_thick=side_ridge_length*0.5;

little_door_height = 13;
little_door_length = 10.5;
little_door_thick=0.5;
little_door_ridge_thick=0.5;
little_door_z = 10.5;//wagon_height - 10.5 - little_door_height;
little_door_hinge_length = 2;
little_door_hinge_height = 1.6;
little_door_hinge_thick = little_door_ridge_thick*2;

plaque_length = 4.9;
plaque_height = 4.1;
plaque_z = wagon_height - 7.3;
plaque_from_end = 30.1+2;//+2.75;

//the thin bits, giong to assume the others are same as sides
//too much thinner and it won't be sliced for printing
end_ridge_thick = 0.6;
end_flange_taper_height = 0.8;

side_ridge_from_end=13.5;
buffer_ledge_length = 7.4;
buffer_ledge_taper_length = side_ridge_from_end-buffer_ledge_length-side_ridge_length/2;
buffer_ledge_height = 1.5;//2;

//how much higher or lower than the main base the buffers should be
//TODO once I've got an idea of the height of bogies then this should be adjusted to meet top_of_buffer_from_top_of_rail
buffer_z_from_base = wagon_base_above_rails - centre_of_buffer_from_top_of_rail;//-0.75;

//buffer_z_from_base negative because wagon is constructed upside down
bogie_mount_height = centre_of_buffer_from_top_of_rail  -wheel_diameter/2 - axle_to_top_of_bogie  - m3_washer_thick;

echo(bogie_mount_height);

end_ridge_x = 1.5*wagon_width/7;

nameplate_length = 44.2;
nameplate_height = 10.8;
nameplate_z = 7;

end_bottom_ledge_z = wagon_height -3;//27;
//guessing a bit here
end_mid_ledge_z = end_bottom_ledge_z * 0.6;
ledge_thick = 0.4;

side_ridge_height = wagon_height-3;
side_ridge_height2 = wagon_height-0.9;

wall_thick = 1;
base_thick = 5;

min_thick = 0.2;

//facing +ve x
module side_ridge(length){
	color("green")translate([wagon_width/2+side_ridge_thick/2,0,0])hull(){
			centred_cube(side_ridge_thick,length,side_ridge_height);
			translate([-side_ridge_thick/2-0.1/2,0,0])centred_cube(0.1,length,side_ridge_height2);
		}
}

//length is up to the base of the buffer, which is further out than parts of the end
module wagon_end_indents(){
	//indent_height = wagon_height - end_bottom_ledge_z;
	mirror_x()translate([0,wagon_length/2+wagon_end_flange_length,top_ridge_height])centred_cube(wagon_width-end_ridge_thick*2,side_ridge_thick*2,end_bottom_ledge_z-top_ridge_height);
}

//facing +ve x up against the side of the wagon
module little_door(){
	translate([little_door_thick/2,0,0])union(){
		difference(){
			centred_cube(little_door_thick,little_door_length,little_door_height);
		//take out the inset
			translate([little_door_thick/2,0,little_door_ridge_thick])centred_cube(min_thick*2,little_door_length-little_door_ridge_thick*2,little_door_height-little_door_ridge_thick*2);
		}
		
		//add centre armridge thing
		translate([0,0,little_door_height/2-little_door_ridge_thick/2])centred_cube(little_door_thick,little_door_length,little_door_ridge_thick);
		
		translate([0,-little_door_length*0.1,little_door_height/2])centred_cube(little_door_thick,little_door_ridge_thick,little_door_height*0.275);
		
		hinge_pos = 0.2;
		
		//hinges
		translate([0,little_door_length/2,little_door_height*hinge_pos-little_door_hinge_height/2])centred_cube(little_door_hinge_thick,little_door_hinge_length,little_door_hinge_height);
		
		translate([0,little_door_length/2,little_door_height*(1-hinge_pos)-little_door_hinge_height/2])centred_cube(little_door_hinge_thick,little_door_hinge_length,little_door_hinge_height);
	}
		
}

// main body of the wagon
//upside down, so 0,0,0 is centre of top of wagon (the open bit)
module wagon_body(){
	difference(){
		centred_cube(wagon_width, wagon_length, wagon_height);
		union(){
			translate([0,0,-0.01])centred_cube(wagon_width-wall_thick*2, wagon_length-wall_thick*2-wagon_end_flange_length*2, wagon_height-base_thick);
			wagon_end_indents();
		}
	}
	
	//top side ridge
	color("green")mirror_y()translate([wagon_width/2+top_ridge_thick/2,0,0])centred_cube(top_ridge_thick,wagon_length+wagon_end_flange_length*2,top_ridge_height);
	//top end ridge
	mirror_x()translate([0,wagon_length/2+wagon_end_flange_length/2,0])centred_cube(wagon_width,wagon_end_flange_length,top_ridge_height);
	
	//side ridges
	//9 central ones of same thickness and distance
	//then two outer ones of thickerness but same distance
	//finfall two outmost ones same thickness as central ones, but further out
	//the 9 central ones
	//inner_ridges_distance = 90;
	//the 11 inner ridges line up with the bogies, which we do have exact positions for
	inner_ridges_distance = bogie_distance;
	inner_ridge_d = inner_ridges_distance/10;
	//inner ridges
	mirror_y()for(i=[1:9]){
		translate([0,-inner_ridges_distance/2 + inner_ridge_d*i,0])side_ridge(side_ridge_length);
	}
	//next ridges, same distance, more thick
	mirror_xy(){
		translate([0,-inner_ridges_distance/2,0])side_ridge(side_ridge_length2);
	}
	//last side ridges, different distance
	
	mirror_xy(){
		translate([0,wagon_length/2 - side_ridge_from_end,0])side_ridge(side_ridge_length);
	}
	nameplate_thick = side_ridge_thick+min_thick;
	//name plate
	color("yellow")mirror_y()translate([wagon_width/2+nameplate_thick/2,0,nameplate_z])centred_cube(nameplate_thick,nameplate_length,nameplate_height);
	
	//end flanges
	mirror_xy()hull(){
		translate([wagon_width/2+top_ridge_thick/2,wagon_length/2-end_ridge_thick/2+wagon_end_flange_length,0]){
			centred_cube(top_ridge_thick,end_ridge_thick,top_ridge_height);
			translate([-top_ridge_thick/2-0.1/2,0,0])centred_cube(0.1,end_ridge_thick,top_ridge_flange_height);
			
		}
	}
	
	//the ends
	//flanges on the sides
	mirror_xy(){
		translate([wagon_width/2-end_ridge_thick/2,wagon_length/2+wagon_end_flange_length/2,0])hull(){
			centred_cube(end_ridge_thick,wagon_end_flange_length,end_bottom_ledge_z);
			translate([0,-wagon_end_flange_length/2-0.1/2,end_bottom_ledge_z])centred_cube(end_ridge_thick,0.1,end_flange_taper_height );
		}
	}
	
	//two end vertical ridges
	mirror_xy()translate([end_ridge_x,wagon_length/2+wagon_end_flange_length-side_ridge_thick/2-min_thick,0])centred_cube(side_ridge_length,side_ridge_thick,end_bottom_ledge_z);
	
	//mid end ledge
	ledge_length = side_ridge_thick-min_thick*2;
	mirror_x()translate([0,wagon_length/2,end_mid_ledge_z])centred_cube(wagon_width,ledge_length,ledge_thick);
	//mid end vertical ledge
	//thicker so it will be sliced and printed
	mirror_x()translate([0,wagon_length/2,0])centred_cube(end_ridge_thick,ledge_length,end_mid_ledge_z);
	
	notch_width = end_ridge_x*2 -side_ridge_length - min_thick*2;
	notch_length = wagon_end_flange_length - min_thick*2;
	//bottom end ledge
	color("green")mirror_x(){
		difference(){
			translate([0,wagon_length/2,end_bottom_ledge_z-ledge_thick])centred_cube(wagon_width,side_ridge_thick+min_thick*2,ledge_thick);
			
			
			
			translate([0,wagon_length/2+wagon_end_flange_length-notch_length/2,end_bottom_ledge_z-ledge_thick*2])centred_cube(notch_width,notch_length,ledge_thick*4);
		}
	}
	
	//extra ledge for the buffers
	mirror_x() hull(){
		translate([0,wagon_length/2-buffer_ledge_length/2,wagon_height])centred_cube(wagon_width,buffer_ledge_length,buffer_ledge_height);
		translate([0,wagon_length/2-(buffer_ledge_length + buffer_ledge_taper_length)/2,wagon_height-0.1])centred_cube(wagon_width,buffer_ledge_length + buffer_ledge_taper_length,0.1);
	}
	
	//little door thing
	mirror_rotate180()translate([wagon_width/2,wagon_length/2 - side_ridge_from_end+ side_ridge_length/2 + little_door_length/2, little_door_z])little_door();
	
	//little plaque
	color("gray")mirror_rotate180()translate([wagon_width/2+min_thick/2,wagon_length/2-plaque_from_end,plaque_z])centred_cube(min_thick,plaque_length,plaque_height);
		
	
	//bogie mounts
	mirror_x()translate([0,bogie_distance/2,wagon_height])cylinder(h=bogie_mount_height,r=m3_thread_d);
	
}

module wagon(){
	difference(){
		wagon_body();
		
		union(){
			//holes for buffers
            mirror_xy(){
				translate([-buffer_distance/2,wagon_length/2,wagon_height+buffer_z_from_base]){
					rotate([90,0,0]){
					//holes to hold buffers
					cylinder(h=buffer_holder_length*2, r=buffer_holder_d/2, $fn=200, center=true);
					}
				}
			}
			
			//holes for bogie screws
			mirror_x()translate([0,bogie_distance/2,wagon_height-base_thick+min_thick*4])cylinder(h=bogie_mount_height+100,r=m3_thread_d/2);
		}
	}
}
//base and top here refer when the bogie is the real way up, z is when being constructed (upside down)
bogie_flange_width = 2.5;
bogie_centre_bottom_length = 4;
bogie_centre_top_length = 7;
bogie_centre_gap_length = bogie_centre_top_length - bogie_centre_bottom_length;
bogie_flange_thick = 0.4;
bogie_centre_top_z = 0.7;
bogie_centre_bottom_z = 6.3;
bogie_top_flat_from_centre = 10.7;
bogie_top_cylinder_r = bogie_flange_width;
bogie_top_cylinder_h = 2.1;

bogie_backing_plate_thick=1;

//TODO - readjust these all to centres, too fiddly otherwise?
//[y,z] for centre of flange thickness
bogie_top_centre = [bogie_centre_top_length/2,bogie_centre_top_z+bogie_flange_thick/2];
bogie_top_inner_wheel = [bogie_top_flat_from_centre,bogie_flange_thick/2];
bogie_top_wheel = [bogie_axle_distance/2,bogie_flange_thick/2];
bogie_top_outer_wheel = [16.3,bogie_flange_thick/2];

bogie_bottom_centre = [bogie_centre_bottom_length/2,bogie_centre_bottom_z-bogie_flange_thick/2];
bogie_bottom_inner_wheel = [bogie_axle_distance/2,bogie_top_cylinder_h-bogie_flange_thick/2];

bogie_bottom_outer_wheel = [16.3,bogie_top_cylinder_h-bogie_flange_thick/2];

bogie_arm_height = bogie_centre_bottom_z;//7.6;//is deeper but not sure I can be bothered to work out the taper and stuff

//used for the backing of the bogie flanges and for intersections
module bogie_hull_shape(width=bogie_backing_plate_thick){
	//backing plate
		
		hull(){
			//centre
			translate([width/2,0,bogie_top_centre[1]-bogie_flange_thick/2])centred_cube(width,bogie_flange_thick,bogie_flange_thick);
			
			translate([width/2,0,bogie_bottom_centre[1]-bogie_flange_thick/2])centred_cube(width,bogie_flange_thick,bogie_flange_thick);
			
			//first bend
			translate([width/2,bogie_top_centre[0]-bogie_flange_thick/2,bogie_top_centre[1]-bogie_flange_thick/2])centred_cube(width,bogie_flange_thick,bogie_flange_thick);
			
			translate([width/2,bogie_bottom_centre[0]-bogie_flange_thick/2,bogie_bottom_centre[1]-bogie_flange_thick/2])centred_cube(width,bogie_flange_thick,bogie_flange_thick);
		}
		
		hull(){
			
			//first bend
			translate([width/2,bogie_top_centre[0]-bogie_flange_thick/2,bogie_top_centre[1]-bogie_flange_thick/2])centred_cube(width,bogie_flange_thick,bogie_flange_thick);
			
			translate([width/2,bogie_bottom_centre[0]-bogie_flange_thick/2,bogie_bottom_centre[1]-bogie_flange_thick/2])centred_cube(width,bogie_flange_thick,bogie_flange_thick);
			
			//'inner wheel'
			translate([width/2,bogie_top_inner_wheel[0]-bogie_flange_thick/2,bogie_top_inner_wheel[1]-bogie_flange_thick/2])centred_cube(width,bogie_flange_thick,bogie_flange_thick);
			
			translate([width/2,bogie_bottom_inner_wheel[0]-bogie_flange_thick/2,bogie_bottom_inner_wheel[1]-bogie_flange_thick/2])centred_cube(width,bogie_flange_thick,bogie_flange_thick);
			
		}
		
		
		//above the wheel
		hull(){
			//'inner wheel'
			translate([width/2,bogie_top_inner_wheel[0],bogie_top_inner_wheel[1]-bogie_flange_thick/2])centred_cube(width,bogie_flange_thick,bogie_flange_thick);
			
			translate([width/2,bogie_bottom_inner_wheel[0],bogie_bottom_inner_wheel[1]-bogie_flange_thick/2])centred_cube(width,bogie_flange_thick,bogie_flange_thick);

			//'outer wheel'
			translate([width/2,bogie_top_outer_wheel[0]-bogie_flange_thick/2,bogie_top_outer_wheel[1]-bogie_flange_thick/2])centred_cube(width,bogie_flange_thick,bogie_flange_thick);
			
			translate([width/2,bogie_bottom_outer_wheel[0]-bogie_flange_thick/2,bogie_bottom_outer_wheel[1]-bogie_flange_thick/2])centred_cube(width,bogie_flange_thick,bogie_flange_thick);
		}
}

//facing +ve x
module bogie_edge(){
	
	mirror_x(){
		//top ledge of the edge of the bogie:
		translate([0,0,bogie_top_centre[1]-bogie_flange_thick/2])cube([bogie_flange_width,bogie_top_centre[0],bogie_flange_thick]);
		hull(){
			translate([0,bogie_top_centre[0]-bogie_flange_thick,bogie_top_centre[1]-bogie_flange_thick/2])cube([bogie_flange_width,bogie_flange_thick,bogie_flange_thick]);
			translate([0,bogie_top_inner_wheel[0]-bogie_flange_thick,0])cube([bogie_flange_width,bogie_flange_thick,bogie_flange_thick]);
		}
		translate([0,bogie_top_inner_wheel[0],0])cube([bogie_flange_width,bogie_axle_distance/2-bogie_top_inner_wheel[0],bogie_flange_thick]);
		//half a cylinder
		intersection(){
			//the cylinder
			translate([0,bogie_axle_distance/2,0])cylinder(r=bogie_top_cylinder_r,h=bogie_top_cylinder_h*2);
			//keep within confines of bogie
			union(){
				//translate([0,bogie_top_inner_wheel[0],0])cube([bogie_flange_width,10,10]);
				bogie_hull_shape(bogie_top_cylinder_r);
			}
		}
		//bogie_hull_shape(bogie_top_cylinder_r*2);
		
		//bottom ledge
		translate([0,0,bogie_bottom_centre[1]-bogie_flange_thick/2])cube([bogie_flange_width,bogie_bottom_centre[0],bogie_flange_thick]);
		
		hull(){
			translate([0,bogie_bottom_centre[0]-bogie_flange_thick,bogie_bottom_centre[1]-bogie_flange_thick/2])cube([bogie_flange_width,bogie_flange_thick,bogie_flange_thick]);
			translate([0,bogie_bottom_inner_wheel[0]-bogie_flange_thick,bogie_bottom_inner_wheel[1]-bogie_flange_thick/2])cube([bogie_flange_width,bogie_flange_thick,bogie_flange_thick]);
		}
		
		hull(){
			translate([0,bogie_bottom_inner_wheel[0]-bogie_flange_thick,bogie_bottom_inner_wheel[1]-bogie_flange_thick/2])cube([bogie_flange_width,bogie_flange_thick,bogie_flange_thick]);
			
			translate([0,bogie_bottom_outer_wheel[0]-bogie_flange_thick,bogie_bottom_outer_wheel[1]-bogie_flange_thick/2])cube([bogie_flange_width,bogie_flange_thick,bogie_flange_thick]);
		}
		
		
		bogie_hull_shape();
		
		
	}
	
	
}

module bogie(){
	
	mirror_y()translate([bogie_inner_width/2,0,0])bogie_edge();
	
	//centre arm
	centred_cube(bogie_inner_width,bogie_centre_bottom_length,bogie_arm_height);
}


if(GEN_WAGON){
	//TODO optional positioning if in situ
	optional_translate([0,0,wagon_base_above_rails + wagon_height],GEN_IN_SITU)optional_rotate([0,180,0],GEN_IN_SITU)wagon();
}

if(GEN_BOGIE){
	bogie();
}