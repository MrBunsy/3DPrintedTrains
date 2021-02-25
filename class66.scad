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
include <threads.scad>



//the battery compartment in the base can print with bridging once the infil angle is perpendicular to the body, likewise with the roof of the shell
//the DC socket and switch holders still need scaffolding, as does the motor holder screwholes in the shell


//done todos:
//TODO shapes around buffers in the pipe space have gone wrong again - going to have to leave these "wrong" to have space for LEDs

//TODO fix led space so it slices without big gaps - done

//TODO mountings for pi and camera - screholes in base and a new peice? - camera done, not sure pi is worth bothering with, hot glue + tap will be fine

//TODO motor hinge point isn't in the centre of its length, so need to re-arrange hole in the base an the motor holder arm to give it the best space - not sure worth the effort
//-definitely don't bother now I've got hte motor with enough freedom of movemwent for tight curves



//still TODOs:

// TODO - the coupling is a tiny bit too low and will foul on pointwork (tried adjusting bogie_wheel_d to 14 rather than 14.3, not reprinted to test)
// - is this related to front and rear wheels on the bogie being lower to account for bending?

// TODO improve shape of rainguards?
// TODO - when printing the shell, after the bridge layer the walls are pulled inwards slightly (presumably by the contracting bridge plastic) and so the roof shape on the final printed version isn't quite right.
//not sure how to fix this. A few internal walls? actually make the roof a separate peice? buttresses?
//would like to address it, but I had to split the MWA wagon into two and that still wans't quite enoguh. might be better to twaek the design
//so the warping is in a less noticable place or countered.

//TODO - the bogies have several bits that don't print well (lots of drooping), these could easily be fixed up


//big todo - I think the wheels need slightly larger flanges and slightly more tapering, they seems to derail more easily than I'd expect.
//better idea - central axle given dummy wheels!
//need anotehr mod for the class59 motor on the other end to finish teh job

//the motor really needs to be able to wobble to cope over wonky track - might be enough to put back the original shape of the clip (with lots of space) and raise height of base
//or might need to re-think how it's held in place entirely
/*

Known variations I've not taken intoaccount:

 - full-height side grill for the grill that's on both sides
 - extra door!
 - different big vent styles in the roof
 - different placements of petrol caps
 - two other headlight styles (but given led sizes, these wouldn't be feasible)
 - fuel tank sizes (related to petrol cap placement?)
*/

//non-dummy base needs scaffolding
GEN_BASE = false;
//walls and roof together. Note that as teh bridged section of roof contracts slightly, the walls are pulled inwards and deform the shape of the roof a small amount.
GEN_SHELL = false;
//note - while separate roof and walls worked, the join between them seems to be more obvious than the problem with the shell.
GEN_WALLS = false;
GEN_ROOF = false;
//bogie will need scaffolding unless I split it out into a separate coupling arm
GEN_BOGIES = false;
GEN_MOTOR_CLIP = true;

//separate peice that will clip/glue over the LEDs at the front for the headlights that stick out and overlap base/shell
GEN_HEADLIGHTS = false;

GEN_PI_MOUNT = false;

//can't decide if to have a separate faceplate for the ends of the headlights to cover up any bits that break or not
//GEN_LIGHTS_FACEPLATE = true;
GEN_IN_PLACE = false;

//generate tiny things that won't print well
GEN_TINY_BITS = false;

//generate things not for the model, but to help it print (like walls in teh shell)
//GEN_PRINT_HELPERS = true;
LAYER_THICK = 0.2;
ANGLE = 0;

//dummy model has no motor
DUMMY = false;
COUPLING_TYPE = "dapol";

//wiki says 21.4metre long, but oes this include buffers?
//n-gauge model with buffers => 21.2m
//n-gauge model without buffers -> 20.3m, so assuming without buffers
length = m2mm(21.4-1);
width = m2mm(2.65);
end_width = width-2;
height = m2mm(3.9);

wall_height = 18.6;
wall_thick = 1.2;

//how far out the front the headlight box should extend
lights_box_length = 2;//1.75;
lights_box_faceplate_thick = 0;//lights_box_length*0.25;


//the height of the flat bit in the middle of the front
wall_front_midsection_height = 2.6;
//z height of the bottom of this section
wall_front_midsection_bottom_z = 5.5+1;
//how far out from the main body the front nose sticks
wall_front_midsection_y = 1.8;
//distance from end that the taper starts twoards the narrorer end width
end_width_start = 22;

coupling_arm_thick = 1.5;
base_thick = 5.5;
girder_thick = 0.5;
handrail_thick = girder_thick;
front_end_thick = 0.6;
//how deep the pipe space in the side of the base is, from base_top_width
base_pipe_space = 3;
crane_mount_box_length = 2;

battery_space_width = width-base_pipe_space*2-girder_thick*2;//28;//27;
dc_socket_d = 8.1;
dc_socket_thread_height = 5.6;
dc_socket_space_d = 11.2;
dc_socket_nut_space_d = 12.5;
dc_socket_switch_nut_height = 1.6;

base_bottom_width = width-4;
base_top_width = width;
//needs to be smaller than top width but larger than bottom width
buffer_width = width-3.5;

headlight_x = 11.5;

//the girder bits extend further downwards in the middle
base_arch_top_length = 90;
base_arch_bottom_length = 75;
base_arch_height = 7;

//think 11 is about accurate, need a tiny bit more space for batteries
fuel_tank_height = 11;//11;
//butted up to the end of the arch on one side
fuel_tank_length = 60;
a_frame_spacing = fuel_tank_length/4;
//I've decided the triangle things are fuel pumps. Wild guess.
fuel_pump_from_tank_ends = 16.5;
fuel_pump_length = a_frame_spacing - girder_thick;
underside_box_height = 9.5;
underside_box_length = dc_socket_space_d+wall_thick*2;
underside_box_width = base_bottom_width-base_pipe_space/2;
	
//TODO check this won't get in the way of couplings
buffer_box_length_top = 5;
buffer_box_length_bottom = 3;
buffer_box_bottom_height = 1.5;
buffer_box_height = 3;
//under the buffers, there's a front panel of the loco
buffer_front_height = 4;
buffer_front_length = 1;

//wall_thick = 2;
motor_length = 60+5;
//the bulk of the motor is not central to the wheels or rotation clip
//however this makes the screwholes and whatnot more complicated, and I'm lazy. so I've just made the length longer
//motor_length_offset_y = 2.5;
motor_centre_from_end = 45;
//doors are different at each end
//these should line up perfectly with the furthest bogie springs, but nothign enforces that
door_centre_from_fuel_end = 28;
door_centre_from_box_end = 36-girder_thick;
door_length = 6.5;//7;
door_handrail_height = 15.6;
door_handrail_z = 3;
door_and_handrails_length = door_length+handrail_thick*3.5*2;
ladder_length = 6.5;
ladder_rung_height = 0.2;
//todo think if this is right
coupling_arm_from_mount = motor_centre_from_end;
coupling_arm_width = 8;

bogie_chain_mount_length = 3;
bogie_chain_mount_height = base_thick/2;

//statement of intent
top_of_bogie_from_rails = 15;
//measurement of wheels
bogie_wheel_d = 14;//14.3;

bogie_axle_d = 2;
wheel_holder_width = 13.8;
wheel_holder_arm_width = 12;//10.4;
wheel_mount_length = bogie_wheel_d*0.5;
	
axle_to_top_of_bogie = top_of_bogie_from_rails - bogie_wheel_d/2;

bogie_width = width-2;
bogie_thick = 2.5;
//how much higher the centre wheel should be compared with the end wheels (so when the bogie bends, all wheels take the weight)
centre_bogie_wheel_offset = 1;


//centre of the base of the bit the sticks out between the bogies
centre_length = m2mm(5.9);

//bottom of the main part of the base from the track
//adding some extra in here to help with the motor clearnace
//buffers are BELOW this.
base_height_above_track = top_of_buffer_from_top_of_rail +1;//20;

echo("length, width,height", length, width,height);

//how far beyond base_thick the mount should be (this works out to be independent of wheel size, due to setting top of bogie as a constant)
bogie_mount_height = base_height_above_track - bogie_wheel_d/2 - (axle_to_top_of_bogie+m3_washer_thick);
//distance between the two end axles
bogie_end_axles_distance = 55;
//distance between the two bits which hold the pointy bits of the axles
//called axle_space in some places
bogie_axle_mount_width = 23;


/*there are now two parts to the motor holder:
 - a separate peice which clips to the top of the motor
 - screwholes in base
 
 This is because it's hard to unclip the motor.

There is a nib on one side of the Y-fork on the top of the motor so a clip the exact size results in a motor that can only 'wobble' in one directino

*/


motor_clip_above_rails = 37-1;
motor_clip_hole_d = 4.4;//4 was too tight
motor_clip_fudge_height = 0.5;//0.2;//0.5 is perfect for holding it in place but giving plenty of wobble. trying 0.2 for a lot less wobble
//making it the perfect size doesn't result in enough side to side wobble to deal with the join in the motor, so make the clip smaller by the fudge
motor_clip_thick = 4.1 - motor_clip_fudge_height;//or 4.1?
motor_clip_height_from_nib = 3.7;
motor_clip_height = 4.2;
motor_clip_nib_width = 1.5;
//for old mechanism of screwing motor into the shell
motor_clip_shell_z = motor_clip_above_rails-(bogie_wheel_d/2+axle_to_top_of_bogie+m3_washer_thick+bogie_mount_height + base_thick);
//for new mechanism of motor clip screwing into the base TODO did this take into account the nib?
//how far between 'top' (in position) of base should the clip holder bottom be?
motor_clip_base_z = motor_clip_above_rails - base_height_above_track - base_thick;
motor_width=17.3;

//old roof
//motor_holder_width = 26;
motor_holder_width = motor_clip_hole_d*3;
motor_holder_length = motor_length + motor_clip_hole_d*3;
//old roof clip
//motor_holder_screws_x = 17.3/2 + m2_thread_size;
//new base clip, relative to motor centre, mirrored xy
motor_hold_screws = [motor_clip_hole_d,motor_length/2 + motor_clip_hole_d*0.75, 0];

//5.5 isn't far enough away from the enlarged pipespace, althouhg 5.75 is plenty.
screwhole_from_edge = 5.75;
//to be mirrored in x and y
base_wall_screwholes = [[width/2-screwhole_from_edge,base_arch_top_length/2+screwhole_from_edge/2,0],[width/2-screwhole_from_edge,length/2-screwhole_from_edge*1.5,0]];
shell_screwhole_thick = 2;

//pi screwholes at end_width_start and mirror around the bogie mountpoint
pi_screwholes_from_centre = 5;

//for calculating roof shape at the front
//seems like a reasonable aproximation
front_top_r_z = -4;
//ensure circle terminates at the top of the wall
front_top_r = sqrt((wall_height-front_top_r_z)*(wall_height-front_top_r_z) + end_width*end_width/4);//height + base_thick;
roof_front_overhang = 2.5;

//there's a small ridge along teh sides from door to door
side_base_ridge_height = 1.5;
side_base_ridge_width = girder_thick;
//the door-front-door section has a double ridge
front_outer_ridge_height = girder_thick;
front_outer_ridge_width = girder_thick;
front_ridge_height = girder_thick*2;
front_ridge_width = girder_thick/2;

//fuel end grill is a double grill with relatively thin ridges
side_fuel_grill_height = 12.5;
side_fuel_grill_length = 38;
//box end grill is a single grill with wider ridges
side_box_grill_height = 12.3;
side_box_grill_length = 34;
side_box_grill_z = wall_height - side_box_grill_height - girder_thick;
side_box_grill_inset_length = side_box_grill_length+girder_thick*2;
//when facing side with fuel tank on the left, one grill is next to the left door above the base ridge
//when facing side with fuel tank on the right, one grill is next to the left grill, just below roof start, and another grill is to the right next to the door and just above the base ridge. This one is a mirror on the y axis with the other side
//positions of the gaps in whta look like modular sections
module_ys = [-60,21];

fuel_side_hatch_length = 12;
fuel_side_hatch_y = -60+9;


hoover_notch_length = 14;
hoover_end_y = length/2-door_centre_from_box_end-door_and_handrails_length*1.5-hoover_notch_length;
hoover_body_length = 28.5;
//should be high enough that we can still have a bridged section of the underside of the roof
hoover_z = 27;
hoover_arm_space_width = 10;
//length of the bit of the arm over the module with the hoover body
hoover_arm_module_length = (hoover_end_y-hoover_body_length) - (module_ys[1]-girder_thick/2);
hoover_arm_length = hoover_arm_module_length * 1.5;

hoover_to_arm_z=2;
hoover_arm_z = hoover_z + hoover_to_arm_z;
hoover_to_end_z=1.75;
hoover_head_y = module_ys[1]-girder_thick/2 - (hoover_arm_length-hoover_arm_module_length)/2;
hoover_head_extra_cutout = 0.5;

hoover_body_width = 16.5;
//arm of the hoover
hoover_arm_width = 6;

hoover_arm_mid_length = hoover_arm_length*0.4;
hoover_arm_to_body_length = hoover_arm_length*0.1;
hoover_arm_to_head_length = hoover_arm_length*0.3;
hoover_head_length = hoover_arm_length*0.2;
hoover_head_width = hoover_arm_space_width;
hoover_head_height = 2;

module motor_space(){
	intersection(){
		cylinder(r=motor_length/2,h=100,center=true);
		//only half wall thick at edges, trying to get this as wide as possible
		translate([0,0,-1])centred_cube(base_top_width-base_pipe_space*2-wall_thick,motor_length*2,100);
	}
}

//facing +ve y direction, with 0,0 at front edge
module buffers(){

	difference(){
		union(){
			//front face
			hull(){
				translate([0,-front_end_thick/2,0])centred_cube(end_width+front_outer_ridge_width*2,front_end_thick,girder_thick);
				translate([0,-front_end_thick/2,base_thick-girder_thick])centred_cube(buffer_width,front_end_thick,girder_thick);
				
			}
			
			//buffer holders
			hull(){
				//variable names use bottom to mean as printed, by mistake
				//top half of buffer box
				translate([0,-buffer_box_length_top/2,base_thick-girder_thick])centred_cube(buffer_width,buffer_box_length_top,buffer_box_bottom_height+girder_thick );
				
				//bottom half of box
				translate([0,-buffer_box_length_bottom/2,base_thick])centred_cube(buffer_width,buffer_box_length_bottom,buffer_box_height );
				
			}
			//note - this bit doesn't appear to be accurate, but all the models (n and OO) I can find do it. When trying to correct the shape I found out why - otherwise there isn't space for the LEDs!
			hull(){
				//bottom of base
				translate([0,-buffer_box_length_top/2,base_thick-girder_thick*2])centred_cube(buffer_width,buffer_box_length_top,girder_thick );
				//sloping bit at top of box
				translate([0,-buffer_box_length_top/2-girder_thick/2,0])centred_cube(base_bottom_width,buffer_box_length_top-girder_thick,girder_thick);
			}
			
			//front face
			translate([0,-buffer_front_length/2,base_thick])centred_cube(buffer_width,buffer_front_length,buffer_front_height);
		}
		//buffer holders
		mirror_y()translate([buffer_distance/2,0,base_thick+buffer_box_height/2])rotate([90,0,0])cylinder(r=buffer_holder_d/2,h=buffer_holder_length*2,center=true);
		
	}
	
}

//(upside down) 'top' of fuel tank is flat on the xy plane
module fuel_tank(){
	
	//width/5;
	little_r = width/2 - base_bottom_width/2;
	straight_section = little_r;
	
	big_r = fuel_tank_height-little_r-straight_section;
	
	intersection(){
		//translate([0,0,little_r]*2)rotate([90,0,0])cylinder(r=big_r,h=fuel_tank_length,center=true);
		hull()mirror_y()translate([width/2-big_r,0,little_r+straight_section])rotate([90,0,0])cylinder(r=big_r,h=fuel_tank_length,center=true);
		
		translate([0,0,little_r+straight_section])centred_cube(100,100,fuel_tank_height - (little_r+straight_section));
	}
	
	translate([0,0,little_r])centred_cube(width,fuel_tank_length,straight_section);
	hull()mirror_y()translate([width/2-little_r,0,little_r])rotate([90,0,0])cylinder(r=little_r,h=fuel_tank_length,center=true);
}

module fuel_caps(subtract = false){
	fuel_cap_z = 2.5;
	fuel_cap_size = 2.5;
	fuel_cap_size_inner = fuel_cap_size- girder_thick*2;
	translate([0,(fuel_tank_length-base_arch_bottom_length)/2,base_arch_height]){
		//now centred on fuel tank
		if(subtract){
			mirror_y()translate([width/2,12-fuel_tank_length/2,fuel_cap_z])centred_cube(girder_thick*2,fuel_cap_size,fuel_cap_size);
			
			mirror_y()translate([width/2,21-fuel_tank_length/2,fuel_cap_z+fuel_cap_size/2])rotate([0,90,0])cylinder(r=fuel_cap_size/2,h=girder_thick*2,center=true);
		}else{
		//I can't decide if it looks better or worse with these bits
			
	 mirror_y()translate([width/2-girder_thick/2,12-fuel_tank_length/2,fuel_cap_z+(fuel_cap_size-fuel_cap_size_inner)/2+fuel_cap_size_inner/2])rotate([0,-90,0])cylinder(r=fuel_cap_size_inner/2,h=girder_thick);
			
			mirror_y()translate([width/2-girder_thick/2,21-fuel_tank_length/2,fuel_cap_z+(fuel_cap_size-fuel_cap_size_inner)/2+fuel_cap_size_inner/2])rotate([0,-90,0])cylinder(r=fuel_cap_size_inner/2,h=girder_thick);
			
		}
	}
}


//some sort of electical workings box, next to the fuel tank
//making it larger than it would be so it can house the switch and DC socket
module underside_box(){
	
	centred_cube(underside_box_width,underside_box_length,underside_box_height);
}


module a_frame(arch = true, top_width = base_top_width){
	mirror_y()hull(){
		
		bottom_width = base_pipe_space - (top_width/2-base_bottom_width/2);
		
		translate([top_width/2-base_pipe_space/2,0,0])centred_cube(base_pipe_space,girder_thick,girder_thick);
		translate([base_bottom_width/2-bottom_width/2,0,(arch ? base_arch_height : base_thick)-girder_thick*2])centred_cube(bottom_width,girder_thick,girder_thick);
	}
}

//a-frame like bits that would hold the bogie suspension on a real train
module springs(){
	spring_width = width - girder_thick;
	bottom_width = base_pipe_space - (base_top_width/2-spring_width/2);
	//a-frame like bit
	mirror_y()hull(){
		
		
		
		translate([base_top_width/2-base_pipe_space/2,0,0])centred_cube(base_pipe_space,girder_thick,girder_thick);
		translate([spring_width/2-bottom_width/2,0,base_thick-girder_thick*1.5])centred_cube(bottom_width,girder_thick,girder_thick);
	}
	//making the semicircle half as thick as the ledge, so it should slice better (not trying to print semi-circles on thin air)
	mirror_y()translate([spring_width/2-bottom_width,0,base_thick-girder_thick/2])cylinder(h=girder_thick/2,r=bottom_width);
}

//the bit of the ladder in the base
module ladder_base(){
	rung_z = base_thick*0.6;
	mirror_y(){
		mirror_x()translate([width/2-base_pipe_space/2,door_length/2+girder_thick])centred_cube(base_pipe_space,girder_thick,base_thick);
		
		//filled-in ladder bit
		translate([width/2-base_pipe_space/2-girder_thick/2,0])centred_cube(base_pipe_space-girder_thick,ladder_length,rung_z);
		//ladder rung
		translate([width/2-base_pipe_space/2,0,rung_z-ladder_rung_height])centred_cube(base_pipe_space,ladder_length,ladder_rung_height);
	}
}
module crane_mount_box(){
	
	mirror_y()translate([width/2-base_pipe_space/2-girder_thick/2,0])difference(){
		
		centred_cube(base_pipe_space,crane_mount_box_length,base_thick);
		
		translate([girder_thick+0.01,0,base_thick/2])centred_cube(base_pipe_space-girder_thick*2,crane_mount_box_length-girder_thick*2,base_thick/2-girder_thick);
		
	}
}


module bogie_chain_mount(){
	
	mirror_y(){
	translate([width/2-base_pipe_space/2,0])centred_cube(base_pipe_space,bogie_chain_mount_length,bogie_chain_mount_height);
	
	mirror_x()hull(){
		translate([width/2-base_pipe_space/2,bogie_chain_mount_length/2 - girder_thick/2,0])centred_cube(base_pipe_space,girder_thick,bogie_chain_mount_height);
		
		
		bottom_width = base_pipe_space - (base_top_width/2-base_bottom_width/2);
		
		translate([base_bottom_width/2-bottom_width/2,bogie_chain_mount_length/2 - girder_thick/2,base_thick-girder_thick*2])centred_cube(bottom_width,girder_thick,girder_thick);
	}
	sphere_r = bogie_chain_mount_height/4;
	translate([width/2,0,bogie_chain_mount_height/2+sphere_r/2])sphere(r=sphere_r, $fn=20);
	
}
}

module fuel_pump(){
	centre_height = 0.5;
	centre_z = base_arch_height*0.5;
	mirror_y(){
		hull(){
		
			//top of triangle
			translate([base_top_width/2-base_pipe_space*1.5,0,girder_thick*2])centred_cube(base_pipe_space,fuel_pump_length,girder_thick);
			
			//most outward bit of triangle
			translate([width/2-base_pipe_space/2,0,centre_z-centre_height/2])centred_cube(base_pipe_space,fuel_pump_length,centre_height);
			
			pipe_space_x=base_top_width/2-base_pipe_space;
			bottom_pipe_space_width = base_bottom_width/2-pipe_space_x;
			//bottom bit
			translate([pipe_space_x,0,base_arch_height-girder_thick*2])centred_cube(bottom_pipe_space_width*2,girder_thick,girder_thick);
		}
		
		//bits on "top" of the triangle
		bottomxz = [width/2, centre_z-centre_height/2];
		topxz = [base_top_width/2-base_pipe_space,girder_thick*2];
		dx = topxz[0] - bottomxz[0];
		dz = topxz[1] - bottomxz[1];
		angle = atan(dz/dx);
		squarebit_width = sqrt(dx*dx + dz*dz)*0.9;
		squarebit_length = fuel_pump_length*0.4;
		farAlong = 0.75;
		
		mirror_x()translate([bottomxz[0] + dx*farAlong,fuel_pump_length/4, bottomxz[1]+dz*farAlong])rotate([0,-angle,0])translate([0,0,-girder_thick])centred_cube(squarebit_width,squarebit_length,girder_thick);
	}
	
	
}

module fuel_pump_box(){
	fuel_box_height = 4;
	fuel_box_length = 3.5;
	
	//box that's only on one side? or only on certain models?
	translate([(width/2-base_pipe_space/2 - girder_thick),-4,0])centred_cube(base_pipe_space,fuel_box_length,fuel_box_height+girder_thick);
}
//0,0 is assumed to be the centre of the fuel holder in xy, and starting at the top of the base in z
module battery_holder(subtract=true){
	//big rectangle
	translate([0,0,-0.01])centred_cube(battery_space_width*0.45,fuel_tank_length-wall_thick*2,base_arch_height+fuel_tank_height-wall_thick+0.01);
	
	battery_angle = -32;//-30;//-25;
	//calculated by eye so the end of the battery can rest on the wall while still being as low down as possible
	start_offset = 12.6+0.2*3;//13.25;//8;
	
	//battery_angle = -27.5;
	//start_offset = 7;
	battery_spacing = 0.8;//1;//2;
	//TODO chop end of far end battery by (TODO angle related) as the end of the battery doesn't need to intersect the rear wall
	difference(){
		mirror_y()union(){
			for(i=[0:3]){
				//start_offset-(i*(aaa_battery_d/cos(battery_angle)+battery_spacing))
				translate([(battery_space_width/2-aaa_battery_d/2),start_offset-fuel_tank_length/2 + (i*(aaa_battery_d/cos(battery_angle)+battery_spacing)),base_arch_height+fuel_tank_height-wall_thick])rotate([battery_angle+180,0,0])cylinder(r=aaa_battery_d/2,h=aaa_battery_length*2,center=true);
			}
		}
		union(){
			translate([0,0,base_arch_height+fuel_tank_height-wall_thick])centred_cube(width,length,100);
			translate([0,fuel_tank_length/2,0])centred_cube(width,wall_thick*2,100);
		}
		
	}
}

//large lights style, since I think that's easiest with LEDs
	lights_box_width = 7;
	lights_box_height = 4.5;
headlight_z = -3;//-lights_box_height;//-3;
//headlight box is split between base and shell. both will use this module, but slice it so they only get the half that fits on each - so it will be designed to slot together and hollow out space for LEDs
//this is for the headlight in +ve x and y quad, with 0,0 of this module lining up with centre (in x) of lights box and y lining up with the front of the loco (lenght/2), z lining up with the top of the base/bottom of the shell
//this is with +ve in the final upright position (so will be upside down for the default position of the base)
//latest plan: since the plastic between the red and white LEDs snaps offeasily, the box connected to the base and shell will be less long, and a separate plate can be glued over the top afterwards
module headlight_box(subtract = false){
	
	
	//-3 looks to be most accurate, but it prints a lot more easily if the headlights are entirely contained in the shell or the base.
	
	//note - subtraction is done after the main shape (unlike most of teh shell)
	if(subtract){
		//want it against the edge same distance it is from top and bottom
		led_edge_space = (lights_box_height - led_3mm_d)/2;
		white_led_x = lights_box_width/2 - led_edge_space - led_3mm_d/2;
		
		//space for LEDs and wires
		//white LED
		translate([white_led_x,-wall_thick,headlight_z+lights_box_height/2])led_3mm(2);
		//red LED
		//this is fairly far back, mainly so the box can be printable (walls were too thin otherwise
		//but has the advantage I can put a diffuser on the front to hide the fact I bought red-casing red LED, when really I want a clear casing red/white LED - turns out on the large-style lights the smaller light is both a daytime white and a rear red
		translate([-(lights_box_width/2-led_1_8mm_d/2-led_edge_space), -wall_thick,headlight_z+lights_box_height-led_1_8mm_d/2-led_edge_space])led_1_8mm(3,6);
		
		
		
	}else{//shorter by lights_box_faceplate_thick
			translate([-lights_box_width/2,0,headlight_z])cube([lights_box_width,lights_box_length-lights_box_faceplate_thick,lights_box_height]);
		
	}
}

module headlight_box_top(){
	headlight_wiggle_space = 0.1;
	//the blank plate above the box + some drooping
		translate([-lights_box_width/2,0,headlight_z+lights_box_height+headlight_wiggle_space])cube([lights_box_width,lights_box_length*0.75,lights_box_height]);
}

module top_headlights(subtract = true){
	top_headlight_width = 4.5;
	top_headlight_total_height = 3.3;
	top_headlight_mid_height = 2.5;
	top_headlight_top_width = 2;
	top_headlight_length = wall_front_midsection_y;
	top_headlight_z = 20;
	
	mirror_x()translate([0,length/2+top_headlight_length/2,top_headlight_z]){
		
		if(subtract){
			translate([0,-top_headlight_length/2-wall_thick,top_headlight_total_height/2])rotate([0,90,0])led_1_8mm(3,6);
		}else{
			echo("headlight");
		
			hull(){
				//bottom half
				centred_cube(top_headlight_width,top_headlight_length,top_headlight_mid_height);
				//top bit
				centred_cube(top_headlight_top_width,top_headlight_length,top_headlight_total_height);
			}
		}
	
	}
}

//looks like these are used to secure the loco when shipping
//this is a single, vertical, mounting point facing +ve y
module front_mountpoint(){
	mountpoint_size = 2.5;
	mountpoint_r = mountpoint_size*0.75/2;
	
	difference(){
		hull(){
			translate([0,girder_thick/2,0])centred_cube(girder_thick,girder_thick,mountpoint_size);
			translate([0,mountpoint_size-mountpoint_r,mountpoint_size/2])rotate([0,90,0])cylinder(r=mountpoint_r,h=girder_thick,center=true);
		}
		if(GEN_TINY_BITS){
			//these barely slice and definitely don't print
			translate([0,mountpoint_size-mountpoint_r,mountpoint_size/2])rotate([0,90,0])cylinder(r=mountpoint_r/2,h=10,center=true);
		}
	}
}

module front_mountpoints(){
	mirror_xy(){
		translate([3.75,length/2,0.75])rotate([0,-45,0])front_mountpoint();
		translate([6.75,length/2,2])rotate([0,-60,0])front_mountpoint();
	}
}

module pi_screwholes(){
	cabin_wall_y = length/2-end_width_start;
	mirror_y()translate([pi_screwholes_from_centre,cabin_wall_y,0])cylinder(r=m2_thread_size_vertical/2,h=20,center=true);
	
	//extra holes so I can invent some sort of pi mount later
	mirror_y()translate([pi_screwholes_from_centre,length/2-motor_centre_from_end - (cabin_wall_y - (length/2 - motor_centre_from_end)),0])cylinder(r=m2_thread_size_vertical/2,h=20,center=true);
}

//module of the "real" coupling, that will be entirely cosmetic
module cosmetic_coupling(presubtract = false, subtract = true, postsubtract = false){
	
	cosmetic_coupling_width = 3.5;
	cosmetic_coupling_length = 3;
	cosmetic_coupling_height = 6;
	cosmetic_coupling_z = 5;
	
	mirror_x(){
		translate([0,length/2,0]){
			if(presubtract){
				//extra space behind the front face
				translate([0,-cosmetic_coupling_length/4-girder_thick/2])centred_cube(cosmetic_coupling_width+girder_thick*2 ,cosmetic_coupling_length/2+girder_thick,buffer_front_height+base_thick);
			}
			if(subtract){
				//space in teh front face
				translate([0,0,cosmetic_coupling_z])centred_cube(cosmetic_coupling_width ,cosmetic_coupling_length,cosmetic_coupling_height);
			}else{
				
			}
		}
	}
}


module base(){
	underside_box_y = base_arch_bottom_length/2-(base_arch_bottom_length-fuel_tank_length)/2;
	difference(){
		union(){
				hull(){
					centred_cube(base_top_width,length-end_width_start*2,girder_thick);
					mirror_x()translate([0,length/2-end_width_start/2,0])centred_cube(end_width,end_width_start,girder_thick);
				}
				centred_cube(base_top_width-base_pipe_space*2,length,base_thick);
				
				mirror_x()translate([0,length/2,0])buffers();
				
				//bogie mount
				translate([0,(length/2 - motor_centre_from_end),0])cylinder(h=base_thick+bogie_mount_height,r=m3_thread_d);
				if(DUMMY){
					//second bogie mount
					translate([0,-(length/2 - motor_centre_from_end),0])cylinder(h=base_thick+bogie_mount_height,r=m3_thread_d);
				}
						
				//bottom girder bits (where the arch isn't)
				mirror_x()translate([0,(length/2-base_arch_top_length/2)/2+base_arch_top_length/2,base_thick-girder_thick])centred_cube(base_bottom_width,length/2-base_arch_top_length/2,girder_thick);
				
				//bottom arch bit
				hull(){
					mirror_x()translate([0,base_arch_top_length/2,base_thick-girder_thick])centred_cube(base_top_width-base_pipe_space*2,girder_thick,girder_thick);
					
					mirror_x()translate([0,base_arch_bottom_length/2,base_arch_height-girder_thick])centred_cube(base_top_width-base_pipe_space*2,girder_thick,girder_thick);
				}
				//bottom arch girders
				//sloping bits of girders
				mirror_x()hull(){
					translate([0,base_arch_top_length/2,base_thick-girder_thick])centred_cube(base_bottom_width,girder_thick,girder_thick);
					
					translate([0,base_arch_bottom_length/2,base_arch_height-girder_thick])centred_cube(base_bottom_width,girder_thick,girder_thick);
				}
				
				translate([0,0,base_arch_height-girder_thick])centred_cube(base_bottom_width,base_arch_bottom_length,girder_thick);
				
				//fuel tank is in the -ve y direction
				translate([0,(fuel_tank_length-base_arch_bottom_length)/2,base_arch_height])fuel_tank();
				
				//underside box in the +ve y direction
				translate([0,underside_box_y,base_arch_height])underside_box();
				
				translate([0,-base_arch_bottom_length/2+a_frame_spacing*1,0])fuel_pump();
				translate([0,-base_arch_bottom_length/2+a_frame_spacing*3,0])fuel_pump();
				fuel_pump_box();
				
				//a-frames in the arch
				for(i=[0:4]){
					translate([0,-base_arch_bottom_length/2 + a_frame_spacing/2 + i*a_frame_spacing])a_frame(true);
				}
				//rest of the a-frames
				for(i=[0:1]){
					mirror_x()translate([0,-base_arch_bottom_length/2 + a_frame_spacing/2 + (i+5)*a_frame_spacing])a_frame(false);
				}
				
				//end a-frames under the cab TODO should calculate top width properly
				mirror_x()translate([0,length/2-end_width_start/2-girder_thick])a_frame(false,(base_top_width+end_width)/2);
				
				//springs for bogies
				mirror_x(){
					translate([0,length/2 - motor_centre_from_end - bogie_wheel_d*1])springs();
					//line up with the edge of the ladder exactly
					translate([0,length/2 - door_centre_from_fuel_end - door_length/2-girder_thick])springs();
				}
				
				//sticky out box thing (mounts for loco to be crane-lifted?)
				mirror_x()translate([0,length/2 - door_centre_from_fuel_end + door_length/2+girder_thick*2 + crane_mount_box_length/2, 0])crane_mount_box();
				
				//chain holder that links to the bogie
				mirror_x()translate([0,length/2 - motor_centre_from_end, 0])bogie_chain_mount();
				
				//ladder
				translate([0,-(length/2-door_centre_from_fuel_end),0])ladder_base();
				translate([0,(length/2-door_centre_from_box_end),0])ladder_base();
				
				//mirror_xy()translate([headlight_x, length/2,0])mirror([1,0,0])rotate([0,180,0])headlight_box(false);
				
				
				front_mountpoints();
				cosmetic_coupling(true, false, false);
			}//end additive union
		
		
		union(){//subtractive union
			fuel_caps(true);
			cosmetic_coupling(false, true, false);
			
			mirror_xy()translate([headlight_x, length/2,0])mirror([1,0,0])rotate([0,180,0])headlight_box(true);
				//bigger space for wires for LEDs behind the headlightboxes
				wire_space_length1=buffer_box_length_top-wall_thick-girder_thick;
				wire_space_depth = base_thick-1;//1.75;
				
				mirror_x()translate([0,length/2-wire_space_length1/2-wall_thick,-0.001])centred_cube(end_width-wall_thick*3,wire_space_length1,wire_space_depth);
				wire_space_length2=2;
				mirror_x()translate([0,length/2-wire_space_length1-wire_space_length2/2-wall_thick,-0.001])centred_cube(width-base_pipe_space*2-girder_thick*2,wire_space_length2+0.01,wire_space_depth*0.75);
			
			pi_screwholes();
			if(!DUMMY){
				//space for motor
				translate([0,-(length/2 - motor_centre_from_end),0])motor_space();
			}else{
				//second bogie
				translate([0,-(length/2 - motor_centre_from_end),0])cylinder(h=100,r=m3_thread_d/2,center=true);
			}
			//screwhole for bogie
			translate([0,(length/2 - motor_centre_from_end),0])cylinder(h=100,r=m3_thread_d/2,center=true);
			
				
			//thinner area for bogie?
			
			if(!DUMMY){
				//hollow out fuel tank for batteries
				translate([0,(fuel_tank_length-base_arch_bottom_length)/2,0])battery_holder(true);

				//TODO custom battery holder, I think we can hold eight batteries in here if they're at the right angle or position.
				//for now, I'll leave it as it is to get the whole loco working then come back and improve this
			
				//slots for DC socket and switch in the underside box
				switch_base_z = -4;
				switch_x = -battery_space_width/4;
				socket_x = (base_top_width-base_pipe_space*2)/2-dc_socket_space_d/2-wall_thick;
				

				translate([socket_x,underside_box_y,0])cylinder(r=dc_socket_d/2,h=100);
				
				translate([socket_x,underside_box_y,-0.01])cylinder(r=dc_socket_space_d/2,h=base_arch_height+underside_box_height-dc_socket_thread_height);
				
				translate([socket_x,underside_box_y,base_arch_height+underside_box_height-dc_socket_thread_height+dc_socket_switch_nut_height])cylinder(r=dc_socket_nut_space_d/2,h=100);
				
				//switch_base_z = -(rs_switch_height - rs_switch_nut_height - base_arch_height-underside_box_height);
				
				
				
				translate([switch_x,underside_box_y,switch_base_z])rotate([0,0,90])rs_switch(1.05,10);
				
				translate([switch_x,underside_box_y,switch_base_z+rs_switch_height-rs_switch_nut_height])cylinder(r=rs_switch_nut_space_d/2+0.5,h=10);
			}else{
				//TODO coin holders for weight?
			}
			
			
			//screwholes to hold walls to base
			translate([0,0,-1])mirror_xy()for(pos = base_wall_screwholes){
				translate(pos)cylinder(r=m2_thread_size_loose/2,h=100,$fn=50);
			}
			translate([0,0,base_thick-m2_head_length])mirror_xy()for(pos = base_wall_screwholes){
				translate(pos)cylinder(r=m2_head_size/2,h=100,$fn=50);
			}
			
			if(!DUMMY){
				//screwholes for motor clip
				translate([0,-length/2+motor_centre_from_end,-1])mirror_xy()translate(motor_hold_screws)cylinder(r=m2_thread_size_loose/2,h=100,$fn=50);
				translate([0,-length/2+motor_centre_from_end,base_thick-m2_head_length])mirror_xy()translate(motor_hold_screws)cylinder(r=m2_head_size/2,h=100,$fn=50);
			}
			
			
			
			
		}//end subtractive union
		
		
	}
	//things to add in after the subtract
	
	cosmetic_coupling(false, false, true);
	fuel_caps(false);
}

module bogie_axle_holder(axle_height){
	
	
	difference(){
		union(){
			mirror_y()translate([wheel_holder_arm_width/2-bogie_thick/2,0,0])centred_cube(bogie_thick,wheel_mount_length,axle_height+bogie_axle_d);
			translate([0,0,axle_height])rotate([0,90,0])cylinder(h=wheel_holder_width,r=bogie_axle_d, center=true );
		}
		
		union(){
			//hole to hold axle
			translate([0,0,axle_height])rotate([0,90,0])cylinder(h=100,r=bogie_axle_d/2 + 0.25, center=true );
			//slot to insert axle
			translate([0,0,axle_height])centred_cube(100,bogie_axle_d,100);
			//punch out centre
			centred_cube(wheel_holder_arm_width-bogie_thick*2,100,100);
		}
	}
	
}
bogie_top_gap = 1.5;
bogie_top_gap_rear = 3.5;
bogie_top_thick = 4.75;
//bogie_inner_thick = 4.5;
bogie_chunks_length = 9.5;
//how much further inside the thinner bits are
bogie_inner_width = bogie_width-2;

bogie_cosmetic_arm_length = 3;
bogie_cosmetics_width = 1.5;
bogie_thick_width = (bogie_width - bogie_inner_width)/2 + bogie_cosmetics_width;

//horizontal suspension
module bogie_h_suspension(axle_height){
	h_suspension_holder_height = 2;
	h_suspension_length = 6;
	h_suspension_height = 1.5;
	h_suspension_y_offset = -0.7;
	notch_r = h_suspension_holder_height*2;
	dy = bogie_end_axles_distance/4 - bogie_chunks_length;
	dz = bogie_top_gap;
	angle = atan(dz/dy);
	
	//extra shape on the bottom of the "inner bits"
	difference(){
		mirror_y()translate([bogie_inner_width/2-bogie_cosmetics_width/2,0,bogie_top_gap + bogie_top_thick])centred_cube(bogie_cosmetics_width,bogie_chunks_length,h_suspension_holder_height);
		translate([0,bogie_chunks_length/2+notch_r/2,bogie_top_gap + bogie_top_thick+notch_r*0.85])rotate([0,90,0])cylinder(r=notch_r,h=width,center=true);
		
		translate([0,-bogie_chunks_length/2,bogie_top_gap + bogie_top_thick])rotate([angle,0,0])centred_cube(width,20,20);
		
	}
	//representation of the suspension
	mirror_y(){
		mirror_y()translate([bogie_inner_width/2-bogie_cosmetics_width/2+girder_thick/2, h_suspension_y_offset,axle_height-h_suspension_height/2]){
			centred_cube(bogie_cosmetics_width+girder_thick,h_suspension_length,h_suspension_height);
			translate([(bogie_cosmetics_width+girder_thick)/2,0,h_suspension_height/2]){
				rotate([90,0,0])cylinder(r=h_suspension_height/3,h=h_suspension_length*0.75,center=true);
				mirror_x(){
					translate([0,h_suspension_length*(0.5-0.25/4),-h_suspension_height/2])centred_cube(h_suspension_height,h_suspension_length*0.25/2,h_suspension_height);
				}
			}
		}
	}
}

//"front" is -ve y
module bogie_cosmetics(axle_height, box_end=true){
	
	
	end_y = bogie_end_axles_distance/2 + 1.6*bogie_wheel_d/2;
	end_y2 = end_y - 7;
	
	front_y = bogie_end_axles_distance/2 + 1.2*bogie_wheel_d/2;
	//front_chunk_y2 = bogie_end_axles_distance/2 - bogie_wheel_d*0.3;
	front_chunk_y2 = bogie_end_axles_distance/2 - bogie_chunks_length/2;
	//extra bits at front
	
	
	//arms to hold cosmetics
	mirror_x()translate([0,bogie_end_axles_distance/4,bogie_top_gap+LAYER_THICK])centred_cube(bogie_inner_width,bogie_cosmetic_arm_length,bogie_thick);
	
	//this arm looks like it might catch a bit if turning on a gradient
	//translate([0,(bogie_end_axles_distance/2 + end_y)/2 , 0])centred_cube(bogie_cosmetic_arm_length,end_y-bogie_end_axles_distance/2,bogie_top_gap_rear);
	
	//inner chunks between the wheels
	mirror_xy()translate([bogie_inner_width/2-bogie_cosmetics_width/2,bogie_end_axles_distance/4,bogie_top_gap])centred_cube(bogie_cosmetics_width, bogie_chunks_length,bogie_top_thick);
	//chunks above the wheels
	
	//triplicate_x([0,bogie_end_axles_distance/2,0])
	mirror_y()translate([bogie_width/2-bogie_thick_width/2,0,0])centred_cube(bogie_thick_width, bogie_chunks_length,bogie_top_thick);
	
	//wibbly bits
	mirror_xy(){
		//middle top to front lower
		hull(){
			//edge of middle top
			translate([bogie_width/2-bogie_thick_width/2,bogie_chunks_length/2])centred_cube(bogie_thick_width, 0.1,bogie_top_thick);
			//edge of next lower
			translate([bogie_inner_width/2-bogie_cosmetics_width/2,bogie_end_axles_distance/4-bogie_chunks_length/2+0.1/2,bogie_top_gap])centred_cube(bogie_cosmetics_width, 0.1,bogie_top_thick);
		}
		
		//front lower to end top
		hull(){
			//edge of next lower
			translate([bogie_inner_width/2-bogie_cosmetics_width/2,bogie_end_axles_distance/4+bogie_chunks_length/2-0.1/2,bogie_top_gap])centred_cube(bogie_cosmetics_width, 0.1,bogie_top_thick);
			//edge of front top
			translate([bogie_width/2-bogie_thick_width/2,bogie_end_axles_distance/2-bogie_chunks_length/2+0.1/2])centred_cube(bogie_thick_width, 0.1,bogie_top_thick);
		}
	}
	
	
	
	
	mirror_y()translate([bogie_width/2-bogie_thick_width/2,-(front_chunk_y2 + front_y)/2,0])
	difference(){
		centred_cube(bogie_thick_width,front_y-front_chunk_y2,bogie_top_thick);
		//cut a chunk out of the top of the front
		translate([0,-((front_y-front_chunk_y2)/2-girder_thick*2),-0.1])centred_cube(bogie_thick_width+0.1,girder_thick*4+0.1,girder_thick*2+0.1);
	}
	
	//extra bits at back
	mirror_y()translate([bogie_width/2-bogie_thick_width/2,(front_chunk_y2 + end_y2)/2,0])centred_cube(bogie_thick_width,end_y2-front_chunk_y2,bogie_top_thick);
	
	rear_width = bogie_inner_width-5;
	
	translate([0,end_y-bogie_cosmetics_width/2,bogie_top_gap_rear])centred_cube(rear_width,bogie_cosmetics_width,bogie_top_thick);
	
	mirror_y(){
		hull(){
			//end of back bit
			translate([rear_width/2-bogie_cosmetics_width/2,end_y-bogie_cosmetics_width/2,bogie_top_gap_rear])centred_cube(bogie_cosmetics_width,bogie_cosmetics_width,bogie_top_thick);
			//end of rear side bit
			translate([bogie_width/2-bogie_thick_width/2,end_y2-0.1/2,0])centred_cube(bogie_thick_width,0.1,bogie_top_thick);
		}
	}
	
	//horizontal suspension
	translate([0,bogie_end_axles_distance/4,0])bogie_h_suspension(axle_height);
	translate([0,-bogie_end_axles_distance/4,0])bogie_h_suspension(axle_height);
	
	//big spring bases
	//won't print well if it sticks out from a bridge, so make it longer
	spring_base_length = bogie_chunks_length+1.5;//7.5;
	spring_base_offset = -1;
	mirror_xy(){
		translate([bogie_inner_width/2-bogie_cosmetics_width/2+girder_thick/2,bogie_wheel_d+spring_base_offset,bogie_top_gap])centred_cube(bogie_cosmetics_width+girder_thick,spring_base_length,girder_thick);
	}
	
	axle_r=3.5/2;
	axle_box_size = axle_r*2.6;
	axle_holder_box_width = (bogie_thick_width+bogie_cosmetics_width)/2;
	axle_box_mini_r=axle_box_size/8;
	axle_box_base_height = axle_box_size/3;
	axle_box_base_length = axle_box_size*1.4;
	
	axle_holder_length = 9.5;
	spring_r=axle_holder_box_width/2;
	top_square_size = spring_r*2*0.75;
	
	axle_box_on_main_bogie_tall = 1.5;
	axle_box_on_main_bogie_length = 3;
	
	// ============ axle holders ===============
	mirror_y()triplicate_x([0,bogie_end_axles_distance/2,0]){
		
		translate([bogie_width/2,0,bogie_top_thick-axle_box_on_main_bogie_tall])centred_cube(girder_thick*2,axle_box_on_main_bogie_length,axle_box_on_main_bogie_tall);
		
		translate([bogie_width/2-bogie_thick_width,0,axle_height]){
			
			//(0,0) here is back of the cosmetic arm, centred on the axle in yz, facing outwards
			
			//centre of the axle
			hull(){
				rotate([0,90,0])cylinder(r=axle_r,h=bogie_thick_width);
				rotate([0,90,0])cylinder(r=axle_r*0.75,h=bogie_thick_width+girder_thick/2);
			}
			rotate([0,90,0])cylinder(r=axle_r*0.25,h=bogie_thick_width+girder_thick);
			
			//axle holder bit
			hull(){
				rotate([0,90,0])cylinder(r=axle_box_size/2,h=axle_holder_box_width);
				translate([axle_holder_box_width/2,0,0])centred_cube(axle_holder_box_width,axle_box_size,axle_box_size/2);
				mirror_x()translate([0,axle_box_size/4,-axle_box_size/2+axle_box_mini_r])rotate([0,90,0])cylinder(r=axle_box_mini_r,h=axle_holder_box_width);
			}
			//base of axle holder
			translate([axle_holder_box_width/2,0,axle_box_size/2-axle_box_base_height])centred_cube(axle_holder_box_width,axle_box_base_length,axle_box_base_height);
			
			//horizontal bar
			translate([axle_holder_box_width/2,0,-axle_r])centred_cube(axle_holder_box_width,axle_holder_length,girder_thick);
			
			//plate behind bar and behind springs
			hull(){
				//horizontal bar
				translate([axle_holder_box_width/4,0,-axle_r-3])centred_cube(axle_holder_box_width/2,axle_holder_length,girder_thick+3);
				//base
				translate([axle_holder_box_width/4,0,axle_box_size/2-axle_box_base_height])centred_cube(axle_holder_box_width/2,axle_box_base_length,axle_box_base_height);
			}
			
			//springs on top
			mirror_x()translate([axle_holder_box_width/2,axle_holder_length/2-spring_r,-axle_r])
			mirror([0,0,1])cylinder(r=spring_r,h=axle_height/2);
			//metric_thread(diameter=spring_r*2, pitch=0.7,thread_size=0.5, groove=true, length=5);
			//square bit on top
			translate([top_square_size/2,0,-axle_r])mirror([0,0,1])centred_cube(top_square_size,top_square_size,3);
			
			
		}
		
	}// ============ end axle holders ===============
	
	//horizontal bars between axle holders
	//between rear two axles
	mirror_y()translate([bogie_width/2-bogie_thick_width+axle_holder_box_width/2,bogie_end_axles_distance/4,axle_height-girder_thick/2])centred_cube(axle_holder_box_width,bogie_end_axles_distance/2,girder_thick);
	//front axle only
	mirror_y()translate([bogie_width/2-bogie_thick_width+axle_holder_box_width/2,-bogie_end_axles_distance/4-bogie_end_axles_distance/8,axle_height-girder_thick/2])centred_cube(axle_holder_box_width,bogie_end_axles_distance/4,girder_thick);
	
	
	//ladder!
	ladder_length = box_end ? 4.5 :6.5;
	ladder_height = 9;
	ladder_width = bogie_thick_width+girder_thick;
	
	//budged up to one side of the door
	ladder_y_box = -(motor_centre_from_end - door_centre_from_box_end)-door_length/2 + ladder_height/2;
	ladder_y_fuel = -(motor_centre_from_end - door_centre_from_fuel_end)+door_length/2 - ladder_height/2;
	//door_centre_from_loco_end  = box_end ? door_centre_from_box_end : door_centre_from_fuel_end;
	
	ladder_y = box_end ? ladder_y_box : ladder_y_fuel;
	
	rung_space_height = (ladder_height - girder_thick*3)/2;
	mirror_y()translate([bogie_width/2-ladder_width/2+girder_thick,ladder_y,0])
	difference(){
		centred_cube(ladder_width,ladder_length,ladder_height);
		
		union(){
			//top rung space
			translate([ladder_width/2-girder_thick/2,0,girder_thick])centred_cube(girder_thick+0.1,ladder_length-girder_thick*2,rung_space_height);
			if(box_end){
				translate([ladder_width/2-girder_thick/2,0,girder_thick*2+rung_space_height])centred_cube(girder_thick+0.1,ladder_length-girder_thick*2,rung_space_height);
			}else{
				//only the left half of the bottom rung box
				translate([ladder_width/2-girder_thick/2,-(ladder_length-girder_thick*2)/4,girder_thick*2+rung_space_height])centred_cube(girder_thick+0.1,(ladder_length-girder_thick*2)/2,rung_space_height);
			}
		}
	}
}

//fuel end or box end? only need box for motorised 66, but will need both for dummy
//main difference is position of the ladder. I'm not sure I'm going to add enoguh detail for anything else
module bogies(box_end=true){
	bogie_arm_length = bogie_wheel_d*0.75;
	
	axle_height = axle_to_top_of_bogie-centre_bogie_wheel_offset/2;
	
	
	
	difference(){
		//main arm to hold bogie together
		centred_cube(wheel_holder_arm_width,bogie_end_axles_distance+bogie_wheel_d/2,bogie_thick);
		cylinder(r=m3_thread_loose_size/2,h=100,center=true);
	}
	//center axle slightly lower (or higher from the final position), so as the bogie flexes it doesn't put all the weight on the centre wheels
	bogie_axle_holder(axle_height);
	
	mirror_x()translate([0,bogie_end_axles_distance/2,0])bogie_axle_holder(axle_height);
	//centred_cube(wheel_holder_arm_width+10,bogie_arm_length,bogie_thick);
	
	bogie_cosmetics(axle_height, box_end);
	
	
	
	
	
	//adding centre_bogie_wheel_offset/2 to make up for when teh bogie bends under the weight of the loco and raises the height of the coupling
	//note- not adding that, as it lowers the bogie too much
	coupling_arm_z = axle_to_top_of_bogie+bogie_wheel_d/2 -coupling_arm_thick-top_of_coupling_from_top_of_rail;// +centre_bogie_wheel_offset/2;
	
	//dapol coupling mount 0,0 is edge of wagon, hornby is...something else
	
	arm_inner_y = (bogie_end_axles_distance/2 + wheel_mount_length/5);
	arm_outer_y = coupling_arm_from_mount - ( COUPLING_TYPE == "dapol" ? dapol_coupling_end_from_edge : coupling_from_edge + m2_thread_size );

	coupling_arm_length = arm_outer_y - arm_inner_y;

	//arm to hold coupling
	difference(){
		translate([0,-(arm_inner_y + arm_outer_y)/2,coupling_arm_z])centred_cube(coupling_arm_width,coupling_arm_length,coupling_arm_thick);
		union(){
		//enough space near the axle
			translate([0,-bogie_end_axles_distance/2,axle_height])rotate([0,90,0])cylinder(h=wheel_holder_width,r=bogie_axle_d*0.8, center=true );
			translate([0,-bogie_end_axles_distance/2+50,axle_height-bogie_axle_d*0.8])centred_cube(100,100,100);
		}
	}
	//fill in gap under coupling arm
	translate([0,-bogie_end_axles_distance/2,0])centred_cube(coupling_arm_width,wheel_mount_length,coupling_arm_z);
	
	translate([0,-(coupling_arm_from_mount - (COUPLING_TYPE == "dapol" ? 0 : coupling_from_edge)),coupling_arm_z+coupling_arm_thick]){
		// coupling_mount(0,coupling_arm_thick);
		if(COUPLING_TYPE == "dapol"){
			//plus 0.2 extra height because these only print well in PETG and with PETG the dapol coupling bridging droops more than PLA
			mirror([0,1,0])coupling_mount_dapol_alone(coupling_arm_thick);
		}else{
			coupling_mount(0,coupling_arm_thick);
		}

	}
}

//hmm not right.
//roof_top_from_walls_base = height - bogie_mount_height- bogie_wheel_d/2-axle_to_top_of_bogie - m3_washer_thick;

roof_top_from_walls = 11-wall_thick/2;

module horn_grill(){
	corner_r = 0.5;
	mid_width = 12;
	top = wall_height +roof_top_from_walls-wall_thick/2+0.6;
	bottom = front_top_r_z + front_top_r+corner_r+0.2;
	
	clip_width = 1;
	clip_distance = 7.5;
	clip_height = 0.2;
	corners = [[-10.5/2,0,bottom],[-mid_width/2,0,top-2],[-3.5/2,0,top],
				[3.5/2,0,top],[mid_width/2,0,top-2],[10.5/2,0,bottom]];
	
	color("blue")
	difference(){
		union(){
			hull(){
				for(corner=corners){
					translate([0,length/2,0])translate(corner)rotate([-90,0,0])cylinder(r=corner_r,h=roof_front_overhang*2,$fn=20);
				}
			}
			mirror_y()translate([clip_distance/2,length/2+roof_front_overhang*1.5,bottom-clip_height-corner_r])centred_cube(clip_width,roof_front_overhang*2,clip_height);
		}
		translate([0,girder_thick,0])roof_front_chop();
	}
}


function lesswide(total_width) = width!=total_width ? (width - total_width)/2 : 0;

//function roof_corners(total_width) = for(i=[1,-1])[ for(j=[[wall_thick/2-total_width/2,0,0],[lesswide(total_width)-15,0,4],[lesswide(total_width)-12,0,7],[-2.5,0,11]]) [j*i] ];

function roof_corners(total_width=width) = [[wall_thick/2-total_width/2,0,0],[lesswide(total_width)-15,0,4],[lesswide(total_width)-11,0,8-wall_thick/3],[-1.5,0,roof_top_from_walls],
			[1.5,0,roof_top_from_walls],[11-lesswide(total_width),0,8-wall_thick/3],[15-lesswide(total_width),0,4],[total_width/2-wall_thick/2,0,0]];

//if printable, it's partially solid with the most shallow bits filled in
module roof_shape(long=1,solid=false,total_width=width,total_width2=width,printable=true){
	less_wideness = (width - total_width)/2;
	
	
	
	//corners = [[wall_thick/2-total_width/2,0,0],[less_wideness-15,0,4],[less_wideness-12,0,7],[-2.5,0,11],
	//		[2.5,0,11],[12-less_wideness,0,7],[15-less_wideness,0,4],[total_width/2-wall_thick/2,0,0]];
	corners0 = roof_corners(total_width);
	corners1 = roof_corners(total_width2);
	roof_corners_r = wall_thick/2;
	
	if(solid){
		hull(){
			for(i=[0:len(corners0)-2]){
			corners0 = [corners0[i],corners0[i+1]];
			corners1 = [corners1[i],corners1[i+1]];
			hull(){
				for(corner=corners0){
					translate([0,-long/2,0])translate(corner)rotate([90,0,0])sphere(r=roof_corners_r, $fn=20);
				}
				
				for(corner = corners1){
					translate([0,long/2,0])translate(corner)rotate([90,0,0])sphere(r=roof_corners_r, $fn=20);
				}
			}
		}
			
		}
	}else{
		//as an experiment, I've made the top bit of the roof filled in. this should make it printable without support, because it's on top of a bridge.
		for(i=printable ? [0,1,2,5,6] : [0:len(corners0)-2]){
			corners0 = [corners0[i],corners0[i+1]];
			corners1 = [corners1[i],corners1[i+1]];
			hull(){
				for(corner=corners0){
					translate([0,-long/2,0])translate(corner)rotate([90,0,0])sphere(r=roof_corners_r, $fn=20);
				}
				
				for(corner = corners1){
					translate([0,long/2])translate(corner)rotate([90,0,0])sphere(r=roof_corners_r, $fn=20);
				}
			}
		}
		if(printable){
			hull(){
				for(i=[2,3,4]){
				corners0 = [corners0[i],corners0[i+1]];
				corners1 = [corners1[i],corners1[i+1]];
				hull(){
					for(corner=corners0){
						translate([0,-long/2,0])translate(corner)rotate([90,0,0])sphere(r=roof_corners_r, $fn=20);
					}
					
					for(corner = corners1){
						translate([0,long/2,0])translate(corner)rotate([90,0,0])sphere(r=roof_corners_r, $fn=20);
					}
				}
			}
				
			}
		}
	}
}
//shape to subtract from a long roof to create the overhanging bit of roof
module roof_front_chop(){
	union(){
			//a shape that goes from the bottom edge of the roof to the overhang at the top, to chop off the overhanging bits of roof that aren't wanted				
			
			hull(){
				translate([0,50+length/2+0.75,wall_height-wall_thick*1])centred_cube(100,100,wall_thick);
				
				translate([0,width/2+length/2+roof_front_overhang,wall_height+roof_top_from_walls])centred_cube(width*2,width,wall_thick);
			}
			
			//also lop off anything that would be too low (copy pasted from front walls intersection)
			//intersection with cylinder
			translate([0,length/2,front_top_r_z])rotate([-90,0,0])cylinder(r=front_top_r,h=length*2);
				
		}
}

//for +ve x side
module shell_screwhole(from_edge=screwhole_from_edge){
	
	difference(){
		union(){
			cylinder(r=m2_thread_size*1.5,h=shell_screwhole_thick);
			translate([from_edge/2,0,0])centred_cube(from_edge,m2_thread_size*3,shell_screwhole_thick);
		}
		cylinder(r=m2_thread_size_vertical/2,h=shell_screwhole_thick*3,center=true);
		
	}
}
module basic_shell_walls(){
	//main straight sections on either side
		mirror_y()translate([width/2-wall_thick/2,0,0])centred_cube(wall_thick,length-end_width_start*2,wall_height);
		
		//tapered bits towards the fronts
		mirror_xy(){
			hull(){
				translate([width/2-wall_thick/2,length/2-end_width_start,0])cylinder(r=wall_thick/2,h=wall_height);
				translate([end_width/2-wall_thick/2,length/2,0]){
					//semi-circle with flat side facing forwards
					difference(){
						cylinder(r=wall_thick/2,h=wall_height);
						translate([0,wall_thick])centred_cube(wall_thick*2,wall_thick*2,100);
					}
				}
			}
		}
}

//if subtract is true, this is a space to be removed before inserting the object
module door_handrail(subtract=false){
	if(subtract){
		mirror_y(){
			translate([width/2-handrail_thick+5,0,door_handrail_z])centred_cube(10,handrail_thick*3,door_handrail_height);
		}
	}else{
		radius = 1;
		mid_handrail_height = door_handrail_height-handrail_thick*2;
		mirror_y(){
			translate([width/2,0,door_handrail_z+handrail_thick+radius])centred_cube(handrail_thick*2,handrail_thick,mid_handrail_height-radius*2);
			
			difference(){
				union(){
					translate([width/2-radius+handrail_thick,0,door_handrail_z+handrail_thick+radius])rotate([90,0,0])cylinder(r=radius,h=handrail_thick,center=true);
			
			
					translate([width/2-radius+handrail_thick,0,door_handrail_z+mid_handrail_height+handrail_thick-radius])rotate([90,0,0])cylinder(r=radius,h=handrail_thick,center=true);
				}
				//chop off bits taht would intrude inside
				centred_cube(width-wall_thick*2,100,100);
			}
		}
	}
}

module door_handrail_pair(subtract=false){
	mirror_x()translate([0,door_length/2+handrail_thick*2,0])door_handrail(subtract);
}


//in final positions
/*module door_handrails(subtract=false){
	translate([0,-length/2+door_centre_from_fuel_end,0])door_handrail_pair(subtract);
	
	translate([0,length/2-door_centre_from_box_end,0])door_handrail_pair(subtract);
}*/

module in_door_positions(){
	translate([0,-length/2+door_centre_from_fuel_end,0])children();
	
	translate([0,length/2-door_centre_from_box_end,0])children();
}

//outline of door, rain guard on roof and doorhandle (but not the handrails)
//note all doorhandles are on the +ve y side, and should not be mirrored along the x axis
module door(subtract=false){
	doorhandle_inset_length = 2.5;
	doorhandle_inset_height = 2;
	doorhandle_zs = [3.5,10];
	doorhandle_height = girder_thick;
	door_handrail_pair(subtract);
	mirror_y(){
		
		if(subtract){
			for(z = doorhandle_zs){
				translate([width/2,door_length/2-doorhandle_inset_length/2,z])centred_cube(handrail_thick,doorhandle_inset_length,doorhandle_inset_height);
			}
		}else{
			//get shape of roof for the rain guard
			roof = roof_corners();
			dx = roof[0][0] - roof[1][0];
			dz = roof[0][2] - roof[1][2];
			dist = sqrt(dx*dx + dz*dz);
			//angle = atan(dz/dx);
			//angle = 0;
			//tried rotating inline with the roof, but decided it's better without
			
			x=dx/dist;
			z=-dz/dist;
			
			rain_thick = 0.5;
			//in plane of first roof angle
			rain_corners = [[-door_and_handrails_length/2,rain_thick],[-door_length/2,rain_thick], [0,dist-rain_thick/2],[door_length/2,dist-rain_thick/2], [door_length/2,rain_thick], [door_and_handrails_length/2,rain_thick]];
			
			bottom_x = width/2;
			bottom_z = wall_height;
			
			
			
			for(i=[0:len(rain_corners)-2]){
				corner0 = rain_corners[i];
				corner1 = rain_corners[i+1];
				
				hull(){
					translate([bottom_x+corner0[1]*x,corner0[0],bottom_z+corner0[1]*z])centred_cube(rain_thick,rain_thick,rain_thick);
					translate([bottom_x+corner1[1]*x,corner1[0],bottom_z+corner1[1]*z])centred_cube(rain_thick,rain_thick,rain_thick);
				}
			}
			
			
			for(z = doorhandle_zs){
				translate([width/2,door_length/2-doorhandle_inset_length/2+0.2,z+doorhandle_inset_height*0.6])centred_cube(handrail_thick,doorhandle_inset_length,doorhandle_height);
			}
			
			//step at the bottom of the ladder. Not sure this will survive the brim being removed...
		//note - now doing this as part of teh front ridge	//translate([width/2+girder_thick/2,0,0])centred_cube(girder_thick,ladder_length,girder_thick);//ladder_rung_height
		}
		
	}
}

//generic grill, (0,0) is centre of grill, which faces +ve x
//defaults to fuel-end settings
module grill(subtract=false, length=side_fuel_grill_length/2, height=side_fuel_grill_height, thick=girder_thick, slats=16,horizontal_slats = 0,rim_size = girder_thick){
	if(subtract){
		centred_cube(thick*0.9,length,height);
	}else{
		
		slat_cube_r = sqrt(thick*thick*2);
		;
		slat_distance = (length-rim_size*2)/(rim_size == 0 ? slats-0.5 : slats);
		horizontal_slat_distance = (height-rim_size*2)/slats;
		difference(){
			centred_cube(thick*1,length,height);
			union(){
				if(slats > 0){
					for(i=[0:slats-1]){
						//translate([slat_cube_r-thick*0.75,-length/2+rim_size+slat_distance/2 + slat_distance*i,rim_size])rotate([0,0,45])centred_cube(thick,thick,height-rim_size*2);
						translate([thick*0.5,-length/2+rim_size+(rim_size == 0 ? slat_distance/4 : slat_distance/2) + slat_distance*i,rim_size])centred_cube(thick,slat_distance/2,height-rim_size*2);
					}
				}
				if(horizontal_slats > 0){
					for(i=[0:horizontal_slats-1]){
						translate([slat_cube_r-thick*0.75,0,rim_size+horizontal_slat_distance/2 + horizontal_slat_distance*i])rotate([0,45,0])centred_cube(thick,length-rim_size*2,thick);
					}
				}
			}
		}
	}
}

//still centred around (0,0)
module fuel_end_grills(subtract=false){
	//grills on the side
	mirror_xy()translate([width/2,side_fuel_grill_length/4,side_base_ridge_height])grill(subtract);
	
	mirror_y(){
		//grills on the roof. not quite accurte, as these grills go over the centre of the roof.
		roof = roof_corners();
		dx = roof[3][0] - roof[2][0];
		dz = roof[3][2] - roof[2][2];
		dist = sqrt(dx*dx + dz*dz);
		
		topdist = abs(roof[3][0])*2;
		
		//this is a bit of a bodge. tinker with the horizontal slats with care
		if(subtract){
			thick = girder_thick;
			slat_cube_r = sqrt(thick*thick*2);
			
			vstlats = 19;
			hslats=7;//18;
			
			vslats_dist = side_fuel_grill_length/vstlats;
			//just for the sloping sides of teh roof
			hslats_dist = dist/hslats;
			//number of slats on the top
			hslats_top = topdist/hslats_dist;
			echo(hslats_dist);
			for(i=[0:hslats-1]){
				translate([roof[2][0] +  i*hslats_dist,0,wall_height+roof[2][2]+i*hslats_dist*dz/dist])centred_cube(thick,side_fuel_grill_length-vslats_dist,thick*4);
			}
			for(i=[0:1]){
				translate([roof[3][0] +  (i+0.15)*hslats_dist,0,wall_height+roof[3][2]])centred_cube(thick,side_fuel_grill_length-vslats_dist,thick*3);
			}
			
			for(i=[0:vstlats-1]){
				translate([0,-side_fuel_grill_length/2+i*vslats_dist + vslats_dist/2]){
					hull(){
						translate([roof[2][0],0,roof[2][2]+wall_height])centred_cube(thick,thick,thick*10);
						translate([roof[2][0]+dx,0,roof[2][2]+dz+wall_height])centred_cube(thick,thick,thick*10);
					}
					hull(){
						translate([roof[2][0]+dx,0,roof[2][2]+dz+wall_height])centred_cube(thick,thick,thick*10);
						translate([0,0,roof[2][2]+dz+wall_height])centred_cube(thick,thick,thick*10);
					}
				}
			}
		}
		
		
	}
}
//only on +ve x side
module big_side_ridges(length=10){
	
	height = wall_height-side_base_ridge_height*2;
	ridges = 16;
	ridge_height = height/ridges;
	
	r=ridge_height/4;
	
	
	
	//16 ridges
	for(i=[0:ridges-1]){
		//translate([width/2,0,side_base_ridge_height*2 + i*ridge_height])rotate([90,0,0])cylinder(r=r,h=length,center=true,$fn=10);
		translate([width/2,0,side_base_ridge_height*2 + i*ridge_height])rotate([90,0,0])cube([r*2,r*2,length],center=true);
	}
	
}
//very slow, use sparingly. think it shouldn't be needed anymore
module wall_and_roof_slice(long = girder_thick,wall_gap=side_base_ridge_height,solid=false,roof_only=false){
	//walls
	if(!roof_only){
		if(solid){
			translate([0,0,wall_gap])centred_cube(width,long,wall_height-wall_gap);
		}else{
			mirror_y()translate([width/2-wall_thick/2,0,wall_gap])centred_cube(wall_thick,long,wall_height-wall_gap);
		}
	}
	//roof 
	intersection(){
		//roof slice uses spheres, so it extends slightly beyond length. intersection to prevent that
		translate([0,0,wall_height])roof_shape(long,solid,width,width,false);
		centred_cube(100,long,100);
	}
}
//ridge height - how far off the base this should start
module wall_and_roof_slice_simple(roof_only=false,ridge_height=1,length=girder_thick){
	corners = roof_corners(width);
		//square_size = module_slice_thick;
		translate([0,0,wall_height]){
			for(i=[0:len(corners)-2]){
				hull(){
					for(corner=[corners[i],corners[i+1]]){
						translate(corner)rotate([90,0,0])cylinder(r=wall_thick/2,h=length,$fn=6,center=true);
					}
				}
			}
		}
		if(!roof_only){
			//down to ridges
			mirror_y()translate([width/2-wall_thick/2,0,ridge_height])centred_cube(wall_thick,length,wall_height-ridge_height);
		}
}

module_slice_thick = girder_thick;
//where I think different modules might be attached? it's a ridge that travels up the walls and over the roof anyway
module module_slice(roof_only=false){

		//old, computationally slow way
		scale_by_x = (width+wall_thick*2-module_slice_thick)/width;
		scale_by_z = (wall_height+roof_top_from_walls+wall_thick-module_slice_thick/2)/(wall_height+roof_top_from_walls);
		
		scale([scale_by_x,1,scale_by_z])wall_and_roof_slice_simple(roof_only,side_base_ridge_height/scale_by_z);
	//wall_and_roof_slice(module_slice_thick,side_base_ridge_height/scale_by_z,false,roof_only);

		
}


module door_indent(){
//
			
			indent_y = 0;
			
			indent_r = 0.75;
			indent_height = 4;
			indent_mid_z = wall_height-3.5;
			//some sort of intent between the door and window on the fuel tank end, only on the -ve x side (and box end on -ve side)

			translate([-(width/2-girder_thick),indent_y,indent_mid_z+indent_height/2-indent_r])rotate([0,-90,0])cylinder(r=indent_r, h=wall_thick);
				
				translate([-(width/2-girder_thick),indent_y,indent_mid_z-indent_height/2+indent_r])rotate([0,-90,0])cylinder(r=indent_r, h=wall_thick);
				
				translate([-(width/2-girder_thick/2),indent_y,indent_mid_z-indent_height/2+indent_r])centred_cube(girder_thick,indent_r*2,indent_height-indent_r*2);
			
}

module box_side_grill(subtract=false){
	/*side_box_grill_height = 12.3;
side_box_grill_length = 34;
side_box_grill_z = wall_height - side_box_grill_height - girder_thick;
side_box_grill_inset_length = side_box_grill_length+girder_thick*2;*/
	
	translate([0,length/2-door_centre_from_box_end-door_and_handrails_length/2-girder_thick-side_box_grill_inset_length/2,0]){
	
		if(subtract){
			translate([-(width/2-girder_thick/2+5),0,side_base_ridge_height])centred_cube(10,side_box_grill_inset_length,wall_height-side_base_ridge_height);
		}else{
			translate([-(width/2-girder_thick/2),0,side_box_grill_z])rotate([0,0,180])grill(false,side_box_grill_length,side_box_grill_height, girder_thick,30);
		}
		
	}
		
		
}

module side_cabinet(){
	
}

//some extra space for the batteries that rest up against the edge of the motor holder
module motor_holder_battery_space(){
	mirror_y()translate([-motor_holder_width/4,motor_hold_screws[1],0])
	rotate([-45,0,-30])cube([20,20,20]);
}

//separate peice that clips onto motor and screws into the base
module motor_holder(){
	//first attempt, built into roof of shell
	//would be impossible to ever remove the motor again
	//translate([0,-(length/2 - motor_centre_from_end),0])
	/*difference(){
		intersection(){
			translate([0,0,motor_clip_shell_z])
			difference(){
				centred_cube(width-wall_thick,motor_clip_hole_d*2,motor_clip_thick);
				cylinder(r=motor_clip_hole_d/2,h=100,center=true);
			}
			//intersect with solid roof and walls to prevent poking out the sides of the roof
			wall_and_roof_slice(motor_clip_hole_d*2,0,true);
		}
		wall_and_roof_slice(motor_clip_hole_d*3,0,false);
	}*/
	//second attempt, screws into roof of shell, works but super fiddly to assemble loco
	/*
	thick = motor_clip_thick;//-motor_clip_fudge_height;
	difference(){
		centred_cube(motor_holder_width,motor_clip_hole_d*2,thick);
		union(){
			cylinder(r=motor_clip_hole_d/2,h=100,center=true);
			mirror_y(){
				translate([motor_holder_screws_x,0,0])cylinder(r=m2_thread_size/2,h=100,center=true);
				translate([motor_holder_screws_x,0,thick-m2_head_length])cylinder(r=m2_head_size/2,h=100);
				centred_cube(motor_clip_hole_d*2,50,motor_clip_fudge_height);
			}
			
		}
	}*/
	//thickess of central arm
	arm_height = 2.5;//motor_clip_height- motor_clip_fudge_height;
	//third attempt, this shape screws into the base and the motor clips into this
	//this can be much smaller than 1.5 and still give plenty of play for gradient changes
	lip_height = motor_clip_height - motor_clip_height_from_nib + motor_clip_fudge_height;
	difference(){
		union(){
			centred_cube(motor_holder_width,motor_holder_length,arm_height);
			cylinder(r=motor_clip_hole_d,h=motor_clip_thick);
		}
		union(){
			cylinder(r=motor_clip_hole_d/2,h=100,center=true);
			motor_holder_battery_space();
			translate([0,0,arm_height - lip_height])cylinder(r=motor_clip_hole_d/2 + motor_clip_nib_width,h=10);
		}
	}
	screw_depth = 10;
	difference(){
		translate([0,0,arm_height])mirror_x()centred_cube(motor_holder_width,motor_holder_length,motor_clip_base_z);
		union(){	
			//don't overlap with space for motor
			cylinder(r=motor_length/2,h=100);
			//screwholes
			translate([0,0,motor_clip_base_z+motor_clip_thick-screw_depth])mirror_xy()translate(motor_hold_screws)cylinder(r=m2_thread_size_vertical/2,h=100);
			
			//chop bits off for the batteries
			motor_holder_battery_space();

			
		}
	}
	
	
}


module class59motor_mod(){
	//the class 59 motor can wobble quite a lot (which we want for gradient changes) but
	//this can result in the cosmetics getting stuck outside the base
	//so this little bit will be glued into the back to prevent the wobble (bit like the sticky up bits
	//on the old hornby HST motor)

	main_width = 23;
	main_length=5.5;
	arm_length = 2.5;
	//bigger than needed to allow for droop
	arm_height = 1.2;
	mid_length = 3.2;
	mid_width = 8;
	base_thick = 2.6;
	height_from_base = 8.2;

	total_length = main_length + arm_length + mid_length;

	centred_cube(main_width,main_length,base_thick);
	translate([0,main_length/2+arm_length+mid_length/2,0])centred_cube(mid_width,mid_length,base_thick);
	translate([0,total_length/2-main_length/2,arm_height])centred_cube(mid_width,total_length,base_thick - arm_height);
	centred_cube(main_width,main_length,height_from_base);
}

//part of the shell with the screwholes for the motor_holder not used anymore
module motor_holder_holder(){
	translate([0,-(length/2 - motor_centre_from_end),-girder_thick*1.5])
	intersection(){
		translate([0,0,motor_clip_shell_z+motor_clip_thick+girder_thick]){
			difference(){
				mirror_y()translate([motor_holder_screws_x,0,0])cylinder(r=m2_thread_size_vertical,h=10);
				mirror_y()translate([motor_holder_screws_x,0,0])cylinder(r=m2_thread_size_vertical/2,h=100,center=true);
			}
		}
	
		//intersect with solid roof and walls to prevent poking out the sides of the roof
		wall_and_roof_slice(motor_clip_hole_d*4,0,true);
	}
}



//the two module_slices in position
module module_slices(){
	//whole body slices
	for(y=module_ys){
		translate([0,y,0])module_slice();
	}
	//roof only slices
	translate([0,length/2-door_centre_from_box_end-door_and_handrails_length/2-girder_thick,0])module_slice(true);
	//judging from photos there are different variations - some have two slices above the door handrail with the notch butted up to them, others have only one slice and a space before the notch. but it's hard to tell on some photos.
	translate([0,length/2-door_centre_from_box_end-door_and_handrails_length/2+girder_thick*2,0])module_slice(true);
	
	translate([0,hoover_end_y+hoover_notch_length-girder_thick/2,0])module_slice(true);
}



roof_notches_z = 29;
roof_notches_positions=[[module_ys[0]+18,17.5,roof_notches_z] , [length/2-door_centre_from_box_end+1.75,12,roof_notches_z], [hoover_end_y+hoover_notch_length/2,hoover_notch_length,roof_notches_z]];


module roof_notches(){
	//[y pos, length, zpos]

	for(notch = roof_notches_positions){
		translate([0,notch[0],notch[2]])centred_cube(width,notch[1],notch[2]);
	}
	
	
}

module roof_grills(){
	roof_grill_size = 5;
	//above the door. on some pictures this is clearly a grill, and on other it's just a square.

	//just a square:	//translate([0,roof_notches_positions[1][0],roof_notches_positions[1][2]])centred_cube(roof_grill_size,roof_grill_size,girder_thick);
	
	translate([0,roof_notches_positions[1][0]+roof_grill_size/2,roof_notches_positions[1][2]+girder_thick/2])rotate([0,-90,90])grill(false, roof_grill_size, roof_grill_size, girder_thick, slats=4);
	
	translate([roof_grill_size/2,roof_notches_positions[2][0]-3,roof_notches_positions[2][2]+girder_thick/2])rotate([0,-90,0])grill(false, roof_grill_size, roof_grill_size, girder_thick, 5,0,0);//7slats just doesn't slice
}

module roof_hatches(){
	
	hatch_length = 17.5;
	hatch_distance=18.8;
	roof_shape = roof_corners(width);
	dx = roof_shape[2][0] - roof_shape[3][0];
	dz = roof_shape[2][2] - roof_shape[3][2];
	hatch_width = sqrt(dx*dx+dz*dz)*0.9;
	hatch_centre_x = abs(roof_shape[2][0] + roof_shape[3][0])/2;
	hatch_centre_z = wall_height+(roof_shape[2][2] + roof_shape[3][2])/2;
	hatch_thick =girder_thick*0.75;// 0.2;//girder_thick*0.2;
	angle = atan(dz/dx);
	
	translate([0,roof_notches_positions[0][0]+roof_notches_positions[0][1]/2+hatch_length/2+hatch_distance/2 + 1,0])mirror_xy(){
		translate([hatch_centre_x,hatch_distance/2,hatch_centre_z])hull(){
			rotate([0,angle,0])centred_cube(hatch_width, hatch_length,wall_thick/2+hatch_thick);
			rotate([0,angle,0])centred_cube(0.01,0.01,wall_thick/2+hatch_thick*2.5);
		}
	}
}

//what looks like a power socket on the front
//facing +ve y, 0,0 at back centre
module front_socket(){
	box_size = 2.5;
	lid_r = box_size*0.8/2;
	lid_length = girder_thick;
	translate([-box_size/2,0,0])cube([box_size,wall_front_midsection_y-lid_length,box_size]);
	translate([0,0,box_size/2])rotate([-90,0,0])cylinder(r=lid_r,h=wall_front_midsection_y);
}

module middle_hoover_head(){
	
	
	
	translate([0,hoover_end_y-hoover_body_length-hoover_arm_to_body_length-hoover_arm_mid_length-hoover_arm_to_head_length-hoover_head_length*0.25,hoover_z+hoover_to_end_z])
	{
		hull(){
		
			mirror_y()translate([hoover_head_width/2-hoover_head_height/2,0,0])rotate([90,0,0])cylinder(r=hoover_head_height/2,h=hoover_head_length/2,center=true,$fn=50);
			//middle of head
			centred_cube(hoover_head_width/3,hoover_head_length/2,hoover_head_height);
		}	
		//extra bit underneath to help hull to main arm
		translate([0,0,-hoover_to_end_z])centred_cube(hoover_head_width,hoover_head_length/2,hoover_to_end_z);
	}
}

//for keeping the overhead lines free of leaves.
module roof_hoover(subtract=false){
	union(){
	if(subtract){
		//main body
		translate([0,hoover_end_y-hoover_body_length/2,hoover_z])centred_cube(width,hoover_body_length+0.001,20);
		//"arm"
		
		arm_y = ((hoover_end_y-hoover_body_length) + module_ys[1]-girder_thick/2)/2;
		translate([0,arm_y,hoover_z])centred_cube(hoover_arm_space_width,hoover_arm_module_length,10);
		
		
		//end of arm
		translate([0,hoover_head_y-hoover_head_extra_cutout/2,hoover_z+hoover_to_end_z])centred_cube(hoover_arm_space_width*1.2,hoover_arm_length-hoover_arm_module_length + hoover_head_extra_cutout,10);
	}else{
		difference(){
			union(){
				
					//main body of the hoover
					translate([0,hoover_end_y-hoover_body_length/2, hoover_z])scale([1,1,0.45])rotate([90,0,0])cylinder(r=hoover_body_width/2,h=hoover_body_length,center=true);
				translate([0,hoover_end_y-hoover_body_length/2, hoover_z])mirror_xy()translate([hoover_body_width/2,hoover_body_length/2-4,0])centred_cube(2,2,1);
				
				
				
				
				//body to arm
				hull(){
					//body end
					translate([0,hoover_end_y-hoover_body_length, hoover_z-1])scale([1,1,0.75])rotate([90,0,0])cylinder(r=hoover_arm_width/2,h=hoover_arm_mid_length,center=true,$fn=50);
					//arm end
					translate([0,hoover_end_y-hoover_body_length-hoover_arm_to_body_length-0.5, hoover_arm_z]){
						scale([1,1,0.75])rotate([90,0,0])cylinder(r=hoover_arm_width/2,h=1,center=true,$fn=50);
						translate([0,0,-hoover_to_arm_z])centred_cube(hoover_arm_width,1,hoover_to_arm_z);
					}
				}
				
				//mid arm
				translate([0,hoover_end_y-hoover_body_length-hoover_arm_to_body_length-hoover_arm_mid_length/2, hoover_arm_z]){
					
					scale([1,1,0.75])rotate([90,0,0])cylinder(r=hoover_arm_width/2,h=hoover_arm_mid_length,center=true,$fn=50);
					translate([0,0,-hoover_to_arm_z])centred_cube(hoover_arm_width,hoover_arm_mid_length,hoover_to_arm_z);
				}
				
				
				//head of the hoover
				
				//arm to head
				hull(){
					middle_hoover_head();
					
					//arm end
					translate([0,hoover_end_y-hoover_body_length-hoover_arm_to_body_length-hoover_arm_mid_length+0.5, hoover_arm_z]){
						scale([1,1,0.75])rotate([90,0,0])cylinder(r=hoover_arm_width/2,h=1,center=true,$fn=50);
						translate([0,0,-hoover_to_arm_z])centred_cube(hoover_arm_width,1,hoover_to_arm_z);
					}
				}
				
				middle_hoover_head();
				
				//end of hoover head
				
				hull(){
					middle_hoover_head();
					mirror_y()translate([hoover_head_width/2-hoover_head_height/2,hoover_end_y-hoover_body_length-hoover_arm_to_body_length-hoover_arm_mid_length-hoover_arm_to_head_length-hoover_head_length+hoover_head_height/2,hoover_z+hoover_to_end_z])sphere(r=hoover_head_height/2,$fn=50);
				}
				
				
				//base of head bit
				translate([0,hoover_head_y-hoover_head_extra_cutout/2,hoover_z])centred_cube(hoover_arm_space_width*1.2,hoover_arm_length-hoover_arm_module_length+hoover_head_extra_cutout,hoover_to_end_z);
			}
			union(){
				//chop off anything below the roof
				translate([0,0,hoover_z-20])centred_cube(width,length,19.5);
				//hole in the body
				translate([hoover_body_width/2-4,hoover_end_y-3.75,0])cylinder(r=3,h=height*1.5);
			}
		}
	}
}
}

front_window_width = 13.5-0.5;
front_window_height = 10.5-1;
front_window_r = 2;
front_window_z = 14+0.5;
front_window_x = 8-0.25;
side_window_length = 12;
side_window_height = 9.5-0.5;
side_window_z = 8.3+1;
side_window_y = 4.9;
side_window_bottom_corner_r=1.2;
side_window_bottom_corner_z=side_window_z+1.9;
side_window_bottom_corner_y=2.8;
side_window_top_corner_y=2.15;

module shell(){
	
	
	
	front_height = front_top_r+front_top_r_z;
	
	mirror_xy(){
		intersection(){
			for(screw=base_wall_screwholes){
				translate(screw)shell_screwhole();
			}
			//only keep what's inside the walls
			hull()basic_shell_walls();
		}
	}
	
	difference(){

		union(){
			basic_shell_walls();
			ridge_door_dist = 0.25;
			ridgepos0=length/2-door_centre_from_box_end-door_length/2 - ridge_door_dist;
			ridgepos1=-(length/2-door_centre_from_fuel_end-door_length/2) + ridge_door_dist;
			//bottom side ridges door-to-door (minus a smidge)
			mirror_y()translate([width/2,(ridgepos0+ridgepos1)/2,0])centred_cube(side_base_ridge_width*2,ridgepos0-ridgepos1,side_base_ridge_height);
			//^twice as thick just so I can lazily centre of width/2
			
			//front side ridges
			//under the doors
			//box end
			ridgepos_boxdoor=length/2-door_centre_from_box_end+door_length/2+ridge_door_dist;
			ridgepos_boxtaper = length/2-end_width_start;
			//under door and until the beginning of the taper
			mirror_y(){
				translate([width/2,(ridgepos_boxtaper+ridgepos0)/2,0])centred_cube(front_outer_ridge_width*2,ridgepos_boxtaper-ridgepos0,front_outer_ridge_height);
				//just front edge of door to taper start
				translate([width/2,(ridgepos_boxtaper+ridgepos_boxdoor)/2,0])centred_cube(front_ridge_width*2,ridgepos_boxtaper-ridgepos_boxdoor,front_ridge_height);
				hull(){
					//bodge to add extra length. it shouldn't be needed?
					translate([end_width/2,length/2,0])centred_cube(front_ridge_width*2,front_ridge_width*2,front_ridge_height);
					translate([width/2,ridgepos_boxtaper-front_ridge_width,0])centred_cube(front_ridge_width*2,front_ridge_width*2,front_ridge_height);
				}
				hull(){
					translate([end_width/2,length/2,0])centred_cube(front_outer_ridge_width*2,front_outer_ridge_width*2,front_outer_ridge_height);
					translate([width/2,ridgepos_boxtaper-front_outer_ridge_width,0])centred_cube(front_outer_ridge_width*2,front_outer_ridge_width*2,front_outer_ridge_height);
				}
			}
			//very front
			mirror_x(){
				translate([0,length/2,0])centred_cube(end_width,front_ridge_width*2,front_ridge_height);
				translate([0,length/2,0])centred_cube(end_width,front_outer_ridge_width*2,front_outer_ridge_height);
			}

			
			//fuel end
			ridgepos_fueldoor=-(length/2-door_centre_from_fuel_end+door_length/2+ridge_door_dist);
			ridgepos_fueltaper = -(length/2-end_width_start);
			//under door and until the beginning of the taper
			mirror_y(){
				translate([width/2,(ridgepos_fueltaper+ridgepos1)/2,0])centred_cube(front_outer_ridge_width*2,abs(ridgepos_fueltaper-ridgepos1),front_outer_ridge_height);
			//just front edge of door to taper start
				translate([width/2,(ridgepos_fueltaper+ridgepos_fueldoor)/2,0])centred_cube(front_ridge_width*2,abs(ridgepos_fueltaper-ridgepos_fueldoor),front_ridge_height);
				
				hull(){
					//bodge to add extra length. it shouldn't be needed?
					translate([end_width/2,-(length/2),0])centred_cube(front_ridge_width*2,front_ridge_width*2,front_ridge_height);
					translate([width/2,ridgepos_fueltaper+front_ridge_width,0])centred_cube(front_ridge_width*2,front_ridge_width*2,front_ridge_height);
					}
				hull(){
					translate([end_width/2,-(length/2),0])centred_cube(front_outer_ridge_width*2,front_outer_ridge_width*2,front_outer_ridge_height);
					translate([width/2,ridgepos_fueltaper+front_ridge_width,0])centred_cube(front_outer_ridge_width*2,front_outer_ridge_width*2,front_outer_ridge_height);
				}
				
			}
			
			
			
			//angle of taper of walls
			width_per_length = (width - end_width)/end_width_start;
			//angle of taper of top half of front
			//y_per_height = wall_front_midsection_y/(wall_height - wall_front_midsection_bottom_z-wall_front_midsection_height);
			
			wall_front_midsection_width = end_width - width_per_length*wall_front_midsection_y;
			roof_front_overhang_width = end_width - width_per_length*roof_front_overhang;
			//extra-thick front
			mirror_x(){
			
				intersection(){
				hull(){
					//wall inside the cab (raising up by ridge height)
						mirror_y()translate([end_width/2-wall_thick/2,length/2-wall_thick/2,front_ridge_height])centred_cube(wall_thick,wall_thick,front_height - front_ridge_height);
					//flat bit in the middle
						translate([0,length/2+wall_front_midsection_y-wall_thick/2,wall_front_midsection_bottom_z])centred_cube(wall_front_midsection_width,wall_thick,wall_front_midsection_height);
					}
					
				
				//intersection with cylinder
				translate([0,0,front_top_r_z])rotate([90,0,0])cylinder(r=front_top_r,h=length*2,center=true);
					}
					//wall at the bottom
					mirror_y()translate([0,length/2-wall_thick/2,0])centred_cube(end_width,wall_thick,front_ridge_height);
			}
			//main section of roof
			translate([0,0,wall_height])roof_shape(length-end_width_start*2);
			//tapered section of roof
			//TODO where roof starts to taper and where walls start to taper aren't identical - suspect I need to consider spheres for the roof_section and place them in exactly the right place
			mirror_x(){
				//note-deliberatetly leaving the front end wider than it should be for a tiny bit of side overhang
				difference(){
					union(){
						//roof top
						translate([0,length/2-end_width_start/2+roof_front_overhang/2,wall_height])roof_shape(end_width_start+roof_front_overhang,false,width,roof_front_overhang_width);
						//filled in roof at front only
						intersection(){
							//big block o' roof
							translate([0,length/2-end_width_start/2+roof_front_overhang/2,wall_height])roof_shape(end_width_start+roof_front_overhang,true,width,roof_front_overhang_width);
							//only keep what's in line with the front wall
								translate([0,length/2+50-wall_thick,0])centred_cube(100,100,100);
						}
					}
					roof_front_chop();
				}
				
				horn_grill();

			}
			//fuel_side_hatch_length = 12;
			//fuel_side_hatch_y = -60+9;
			//long side ridges
			door_railing_rear_edge_y = length/2-door_centre_from_box_end-door_and_handrails_length/2-girder_thick/2;
			middle_ridge_y = module_ys[1]+girder_thick;
			translate([0,(middle_ridge_y+door_railing_rear_edge_y)/2])big_side_ridges(door_railing_rear_edge_y-middle_ridge_y);
			
			
			hatch_end_y = module_ys[0]+fuel_side_hatch_length;
			module_y = module_ys[1]-girder_thick;
			mirror_y()translate([0,(module_y+hatch_end_y)/2,0])big_side_ridges(module_y-hatch_end_y);
			
			grill_y = door_railing_rear_edge_y - side_box_grill_inset_length - girder_thick;
			
			mirror([1,0,0])translate([0,(middle_ridge_y+grill_y)/2,0])big_side_ridges(grill_y - middle_ridge_y);
			
			mirror_xy()translate([headlight_x, length/2,0])headlight_box_top();

			top_headlights(false);
			mirror_x()translate([0,length/2,front_ridge_height])front_socket();
		}
			
		
		
		//subtract windows
		union(){
			//front windows
			mirror_xy()translate([front_window_x,0,front_window_z])rotate([90,0,0])rounded_cube(front_window_width,front_window_height,length,front_window_r,$fn);
			
			//side windows
			mirror_x()hull(){
				//main square bit
				translate([0,side_window_y+length/2-end_width_start+side_window_length/2,side_window_z])centred_cube(width*2,side_window_length,side_window_height);
				//top of front edge
				translate([0,side_window_y+length/2-end_width_start+side_window_length+side_window_top_corner_y,side_window_z+side_window_height-side_window_bottom_corner_r])rotate([0,90,0])cylinder(r=side_window_bottom_corner_r,h=width*2,center=true);
				//bottom of front end
				translate([0,side_window_y+length/2-end_width_start+side_window_length+side_window_bottom_corner_y,side_window_bottom_corner_z])rotate([0,90,0])cylinder(r=side_window_bottom_corner_r,h=width*2,center=true);
			}
			//in_door_positions()door_handrail_pair(true);
			translate([0,-length/2+door_centre_from_fuel_end+door_and_handrails_length/2+side_fuel_grill_length/2,0])fuel_end_grills(true);
			in_door_positions()door(true);
			
			//door_railing_front_edge_y = -length/2+door_centre_from_fuel_end-door_length/2-handrail_thick*2;
			taper_start_y = -length/2+end_width_start;
			window_back_edge_y = side_window_y-length/2+side_window_length;
			indent_y = (taper_start_y+window_back_edge_y)/2;
			
			module_slices();
			
			translate([0,indent_y,0])door_indent();
			
			rotate([0,0,180])translate([0,indent_y,0])door_indent();
			box_side_grill(true);
			//notch in roof
			roof_notches();
			
			mirror_xy()translate([headlight_x, length/2,0]){
				headlight_box(true);
				headlight_box(false);
			}
			
			top_headlights(true);
			roof_hoover(true);
		}
	
	}
	//things to add after subtractions
	
	roof_hoover(false);
	
	roof_grills();
	
	box_side_grill();
	
	roof_hatches();
	
	//in_door_positions()door_handrail_pair(false);
	in_door_positions()door(false);
	translate([0,-length/2+door_centre_from_fuel_end+door_and_handrails_length/2+side_fuel_grill_length/2])fuel_end_grills();
	
	
}
roof = roof_corners(width);
roof_start_z = wall_height + roof[2][2]-wall_thick/2;
//this is most definitely a bodge. but it might work
roof_walls_overlap_width = abs(roof[2][0])*2+wall_thick*2+0.675;
roof_walls_overlap = 0;//0.4;

module wall_roof_diff(shrinkby=0){
	union(){
		translate([0,0,-1])centred_cube(width*1.5,length*1.5,roof_start_z+1);
		mirror_x()translate([0,length/2-end_width_start-shrinkby + 50])centred_cube(100,100,100);
	}
}
module wall_roof_slot(shrinkby=0){
	translate([0,0,roof_start_z-roof_walls_overlap])centred_cube(roof_walls_overlap_width-shrinkby,length-end_width_start*2-shrinkby*2,roof_walls_overlap);
}

//just bottom half of shell
module walls(){
	
	difference(){
		intersection(){
			shell();
			wall_roof_diff();
		}
		wall_roof_slot();
	}
}

//just top half of shell
module roof(){
	translate([0,0,-roof_start_z+roof_walls_overlap])
	{
		difference(){
			shell();
			wall_roof_diff(0.1);
		}
		wall_roof_slot(0.1);
	}
}

//centred around the motor/bogie hinge point, facing +ve y out the windows
module pi_mount(){
	mount_thick = wall_thick;
	camera_mount_width = width-wall_thick*2 - 2;
	shell_scale = (width-wall_thick*2-2)/width;
	base_thick=1.5+m2_head_length;
	base_length = m2_head_size + mount_thick*2;
	electronics_height = 10;
	pi_holder_thick = 4;
	pi_holder_wide = 12;
	pi_mount_height = 5.5;
	
	//TODO
	pi_offset = [1,-10,0];
	
	roof = roof_corners();
	max_height = (wall_height+roof[2][2])*shell_scale;
	
	//wall slice with hole for camera
	translate([0,motor_centre_from_end - end_width_start + m2_head_size/2+wall_thick/2,0])
	difference(){
		scale([shell_scale,1,shell_scale])hull()wall_and_roof_slice_simple(false,0, mount_thick);
		union(){
			//punch out camera hole
			translate([0,0,front_window_z])rotate([90,0,0])cylinder(r=pi_cam_d/2+0.1,h=mount_thick*2,center=true);
			//chop off top of roof
		translate([0,0,max_height])centred_cube(width,mount_thick*2,10);
		}
	}
		
	//base with screw fixings for both camera and pi holder
	mirror_x()translate([0,motor_centre_from_end - end_width_start,0])difference(){
		centred_cube((width)*shell_scale,base_length,base_thick);
		mirror_y(){
			translate([pi_screwholes_from_centre,0,0]){
				cylinder(r=m2_thread_size_loose/2,h=10,center=true);
				translate([0,0,base_thick-m2_head_length])cylinder(r=m2_head_size/2,h=m2_head_length+1);
			}
		}
	}
	
	//pi holder on a pole
	translate([0,-(motor_centre_from_end - end_width_start),0]){
		centred_cube(pi_holder_thick,pi_holder_thick,electronics_height);
		translate([0,0,electronics_height]){
			centred_cube(pi_holder_wide,pi_holder_wide,base_thick);
			translate(pi_offset){
				//lengthwise arm
				centred_cube(pi_holder_thick,pi_mount_length,base_thick);
				mirror_x()translate([0,pi_mount_length/2,0])centred_cube(pi_mount_width,pi_holder_thick,base_thick);
				mirror_xy()translate([pi_mount_width/2,pi_mount_length/2,0]){
					cylinder(r=pi_mount_d/2,h=base_thick+pi_mount_height);
					cylinder(r=pi_mount_d,h=base_thick);
				}
			}
			
		}
	}
	

		
	
	
}

optional_rotate([0,0,ANGLE],ANGLE != 0){
	if(GEN_BASE){
		echo("gen base");
		optional_translate([0,0,base_thick+base_height_above_track],GEN_IN_PLACE)optional_rotate([0,180,0],GEN_IN_PLACE)base();
		
	}

	if(GEN_BOGIES){
		echo("gen bogies");
		mirror([0,1,0])optional_translate([0,-(length/2 - motor_centre_from_end),base_height_above_track-bogie_mount_height-m3_washer_thick],GEN_IN_PLACE)optional_rotate([0,180,0],GEN_IN_PLACE)bogies(true);
		if(DUMMY){
			//other bogie
			optional_translate([0,-(length/2 - motor_centre_from_end),base_height_above_track-bogie_mount_height-m3_washer_thick],GEN_IN_PLACE)optional_rotate([0,180,0],GEN_IN_PLACE)bogies(false);
		}
		
	}

	if(GEN_SHELL){
		echo("gen shell");
		optional_translate([0,0,base_thick+base_height_above_track],GEN_IN_PLACE)shell();
	}
	
	if(GEN_WALLS){
		echo("gen walls");
		optional_translate([0,0,base_thick+base_height_above_track],GEN_IN_PLACE)walls();
	}
	
	if(GEN_ROOF){
		echo("gen roof");
		optional_translate([0,0,base_thick+base_height_above_track+roof_start_z+1],GEN_IN_PLACE)roof();
	}
	
	if(GEN_MOTOR_CLIP){
		echo("gen motor clip");
		optional_translate([0,-(length/2 - motor_centre_from_end),motor_clip_base_z+base_thick+base_height_above_track+motor_clip_thick],GEN_IN_PLACE)optional_rotate([0,180,0],GEN_IN_PLACE)motor_holder();	
		if(!GEN_IN_PLACE){
			//translate([50,50,0])class59motor_mod();
		}
	}
	
	if(GEN_PI_MOUNT){
		echo("gen pi mount");
		optional_translate([0,(length/2 - motor_centre_from_end),base_thick+base_height_above_track],GEN_IN_PLACE)pi_mount();	
	}

	if(GEN_HEADLIGHTS){
		mirror_y()translate([headlight_x, 0,0])rotate([90,0,0])difference(){
			headlight_box(false);
			headlight_box(true);
		}
	}

}
