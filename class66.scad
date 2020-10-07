include <truck_bits.scad>
include <constants.scad>

//$fn=50;

//the battery compartment in the base can print with bridging once the infil angle is perpendicular to the body, likewise with the roof of the shell
//the DC socket and switch holders still need scaffolding, as does the motor holder screwholes in the shell

//TODO fix/finish interactiosn between buffers and pipe space, then the base will be close to finished
//TODO wonky battery holders to hold 8 AAAs in the fuel container of the base
//TODO finish ridge around the base of the whole shell
//TODO final detail on the roof
//TODO improve shape of rainguards

//TODO motor hinge point isn't in the centre of its length, so need to re-arrange hole in the base an the motor holder arm to give it the best space

//non-dummy base needs scaffolding
GEN_BASE = true;
GEN_SHELL = false;
//bogie will need scaffolding unless I split it out into a separate coupling arm
GEN_BOGIES = false;
GEN_MOTOR_CLIP = true;
GEN_IN_PLACE = true;

//dummy model has no motor
DUMMY = false;

//wiki says 21.4metre long, but oes this include buffers?
//n-gauge model with buffers => 21.2m
//n-gauge model without buffers -> 20.3m, so assuming without buffers
length = m2mm(21.4-1);
width = m2mm(2.65);
end_width = width-2;
height = m2mm(3.9);

wall_height = 18.6;
wall_thick = 1.2;


//the height of the flat bit in the middle of the front
wall_front_midsection_height = 2.6;
//z height of the bottom of this section
wall_front_midsection_bottom_z = 5.5;
//how far out from the main body the front nose sticks
wall_front_midsection_y = 1.8;
//distance from end that the taper starts twoards the narrorer end width
end_width_start = 22;

coupling_arm_thick = 1.5;
base_thick = 3;
girder_thick = 0.5;
handrail_thick = girder_thick;
front_end_thick = 0.6;
//how deep the pipe space in the side of the base is, from base_top_width
base_pipe_space = 2;
crane_mount_box_length = 2;

battery_space_width = 27;
dc_socket_d = 8.1;
dc_socket_thread_height = 5.6;
dc_socket_space_d = 11.2;
dc_socket_nut_space_d = 12.5;
dc_socket_switch_nut_height = 1.6;

base_bottom_width = width-3;
base_top_width = width;
//needs to be smaller than top width but larger than bottom width
buffer_width = width-3;

//the girder bits extend further downwards in the middle
base_arch_top_length = 90;
base_arch_bottom_length = 75;
base_arch_height = 7;


fuel_tank_height = 11;
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
buffer_front_height = 5;
buffer_front_length = 1;

//wall_thick = 2;
motor_length = 60+5;
//the bulk of the motor is not central to the wheels or rotation clip
//however this makes the screwholes and whatnot more complicated, and I'm lazy. so I've just made the length longer
//motor_length_offset_y = 2.5;
motor_centre_from_end = 45;
//doors are different at each end
door_centre_from_fuel_end = 28;
door_centre_from_box_end = 36;
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
bogie_wheel_d = 14.3;

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
//buffers are BELOW this.
base_height_above_track = top_of_buffer_from_top_of_rail ;//20;

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
 - two screwholes in the roof of the shell
 
 This is because it's hard to unclip the motor. If the roof was separate, it might not be needed?

*/
motor_clip_above_rails = 37;
motor_clip_hole_d = 4.4;//4 was too tight
motor_clip_fudge_height = 0.5;
//making it the perfect size doesn't result in enough side to side wobble to deal with the join in the motor, so make the clip smaller by the fudge
motor_clip_thick = 4 - motor_clip_fudge_height;//or 4.1?
//for old mechanism of screwing motor into the shell
motor_clip_shell_z = motor_clip_above_rails-(bogie_wheel_d/2+axle_to_top_of_bogie+m3_washer_thick+bogie_mount_height + base_thick);
//for new mechanism of motor clip screwing into the base
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

screwhole_from_edge = 5;
//to be mirrored in x and y
base_wall_screwholes = [[width/2-screwhole_from_edge,base_arch_top_length/2+screwhole_from_edge/2,0],[width/2-5,length/2-screwhole_from_edge*1.5,0]];
shell_screwhole_thick = 2;

//for calculating roof shape at the front
//seems like a reasonable aproximation
front_top_r_z = -4;
//ensure circle terminates at the top of the wall
front_top_r = sqrt((wall_height-front_top_r_z)*(wall_height-front_top_r_z) + end_width*end_width/4);//height + base_thick;
roof_front_overhang = 2.5;

//there's a small ridge along teh sides from door to door
side_base_ridge_height = 1.5;
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

module motor_space(){
	intersection(){
		cylinder(r=motor_length/2,h=100,center=true);
		translate([0,0,-1])centred_cube(base_top_width-base_pipe_space*2-wall_thick*2,motor_length*2,100);
	}
}

//facing +ve y direction, with 0,0 at front edge
module buffers(){

	difference(){
		union(){
			//front face
			hull(){
				translate([0,-front_end_thick/2,0])centred_cube(end_width,front_end_thick,girder_thick);
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
			
			hull(){
				//bottom of base
				translate([0,-buffer_box_length_top/2,base_thick-girder_thick*2])centred_cube(base_bottom_width,buffer_box_length_top,girder_thick );
				//sloping bit at top of box
				translate([0,-buffer_box_length_top/2-girder_thick/2,0])centred_cube(end_width,buffer_box_length_top-girder_thick,girder_thick);
			}
			
			//front face
			translate([0,-buffer_front_length/2,base_thick])centred_cube(buffer_width,buffer_front_length,buffer_front_height);
		}
		
		mirror_y()translate([buffer_distance/2,0,base_thick+buffer_box_height/2])rotate([90,0,0])cylinder(r=buffer_holder_d/2,h=buffer_holder_length*2,center=true);
		
	}
	
}

//(upside down) 'top' of fuel tank is flat on the xy plane
module fuel_tank(){
	
	big_r = width/2;
	little_r = width/2 - base_bottom_width/2;
	straight_section = little_r;
	
	intersection(){
		translate([0,0,little_r]*2)rotate([90,0,0])cylinder(r=big_r,h=fuel_tank_length,center=true);
		translate([0,0,little_r+straight_section])centred_cube(100,100,fuel_tank_height - (little_r+straight_section));
	}
	
	translate([0,0,little_r])centred_cube(width,fuel_tank_length,little_r);
	hull()mirror_y()translate([width/2-little_r,0,little_r])rotate([90,0,0])cylinder(r=little_r,h=fuel_tank_length,center=true);
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
		translate([spring_width/2-bottom_width/2,0,base_thick-girder_thick*2])centred_cube(bottom_width,girder_thick,girder_thick);
	}
	
	mirror_y()translate([spring_width/2-bottom_width,0,base_thick-girder_thick])cylinder(h=girder_thick,r=bottom_width);
}

//the bit of the ladder in the base
module ladder_base(){
	rung_z = base_thick*0.7;
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
	mirror_y()hull(){
		
		//top of triangle
		translate([base_top_width/2-base_pipe_space*1.5,0,girder_thick*2])centred_cube(base_pipe_space,fuel_pump_length,girder_thick);
		
		//most outward bit of triangle
		translate([width/2-base_pipe_space/2,0,centre_z-centre_height/2])centred_cube(base_pipe_space,fuel_pump_length,centre_height);
		
		//bottom bit
		translate([base_bottom_width/2-girder_thick/2,0,base_arch_height-girder_thick*2])centred_cube(girder_thick,girder_thick,girder_thick);
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
				
			}//end additive union
		
		
		union(){
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
				translate([0,(fuel_tank_length-base_arch_bottom_length)/2,-0.01])centred_cube(battery_space_width,fuel_tank_length-wall_thick*2,base_arch_height+fuel_tank_height-wall_thick);

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

module bogies(){
	bogie_arm_length = bogie_wheel_d*0.75;
	bogie_cosmetic_arm_length = bogie_wheel_d*0.5;
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
	
	//arms to hold cosmetics
	mirror_x()translate([0,bogie_end_axles_distance/4,0])centred_cube(bogie_width,bogie_cosmetic_arm_length,bogie_thick );
	
	coupling_arm_length = coupling_arm_from_mount - bogie_end_axles_distance/2 + wheel_mount_length/2;
	
	
	//adding centre_bogie_wheel_offset/2 to make up for when teh bogie bends under the weight of the loco and raises the height of the coupling
	coupling_arm_z = axle_to_top_of_bogie+bogie_wheel_d/2 -coupling_arm_thick-top_of_coupling_from_top_of_rail +centre_bogie_wheel_offset/2;
	
	//arm to hold coupling
	difference(){
		translate([0,-(coupling_arm_from_mount-coupling_arm_length/2-coupling_mount_length/2),coupling_arm_z])centred_cube(coupling_arm_width,coupling_arm_length-coupling_mount_length,coupling_arm_thick);
		union(){
		//enough space near the axle
			translate([0,-bogie_end_axles_distance/2,axle_height])rotate([0,90,0])cylinder(h=wheel_holder_width,r=bogie_axle_d*0.8, center=true );
			translate([0,-bogie_end_axles_distance/2+50,axle_height-bogie_axle_d*0.8])centred_cube(100,100,100);
		}
	}
	//fill in gap under coupling arm
	translate([0,-bogie_end_axles_distance/2,0])centred_cube(coupling_arm_width,wheel_mount_length,coupling_arm_z);
	
	translate([0,-(coupling_arm_from_mount-coupling_mount_length/2),coupling_arm_z+coupling_arm_thick])coupling_mount(0,coupling_arm_thick);
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
		cylinder(r=m2_thread_size/2,h=shell_screwhole_thick*3,center=true);
		
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
			translate([width/2+girder_thick/2,0,0])centred_cube(girder_thick,ladder_length,girder_thick);//ladder_rung_height
		}
		
	}
}

//generic grill, (0,0) is centre of grill, which faces +ve x
//defaults to fuel-end settings
module grill(subtract=false, length=side_fuel_grill_length/2, height=side_fuel_grill_height, thick=girder_thick, slats=16,horizontal_slats = 0){
	if(subtract){
		centred_cube(thick*0.9,length,height);
	}else{
		
		slat_cube_r = sqrt(thick*thick*2);
		rim_size = thick;
		slat_distance = (length-rim_size*2)/slats;
		horizontal_slat_distance = (height-rim_size*2)/slats;
		difference(){
			centred_cube(thick*1,length,height);
			union(){
				if(slats > 0){
					for(i=[0:slats-1]){
						//translate([slat_cube_r-thick*0.75,-length/2+rim_size+slat_distance/2 + slat_distance*i,rim_size])rotate([0,0,45])centred_cube(thick,thick,height-rim_size*2);
						translate([thick*0.5,-length/2+rim_size+slat_distance/2 + slat_distance*i,rim_size])centred_cube(thick,slat_distance/2,height-rim_size*2);
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

//where I think different modules might be attached? it's a ridge that travels up the walls and over the roof anyway
module module_slice(roof_only=false){
	scale_by_x = (width+wall_thick*2-girder_thick)/width;
	scale_by_z = (wall_height+roof_top_from_walls+wall_thick-girder_thick/2)/(wall_height+roof_top_from_walls);
	
	scale([scale_by_x,1,scale_by_z])wall_and_roof_slice(girder_thick,side_base_ridge_height/scale_by_z,false,roof_only);
		
}

//the two module_slices in position
module module_slices(){
	
	for(y=module_ys){
		translate([0,y,0])module_slice();
	}
	translate([0,length/2-door_centre_from_box_end-door_and_handrails_length/2-girder_thick,0])module_slice(true);
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
	//third attempt, this shape screws into the base and the motor clips into this
	//this can be much smaller than 1.5 and still give plenty of play for gradient changes
	lip_height = 1;//1.5;
	difference(){
		union(){
			centred_cube(motor_holder_width,motor_holder_length,motor_clip_thick-lip_height);
			cylinder(r=motor_clip_hole_d,h=motor_clip_thick);
		}
		cylinder(r=motor_clip_hole_d/2,h=100,center=true);
	}
	screw_depth = 10;
	difference(){
		translate([0,0,motor_clip_thick-lip_height])mirror_x()centred_cube(motor_holder_width,motor_holder_length,motor_clip_base_z+lip_height);
		union(){	
			//don't overlap with space for motor
			cylinder(r=motor_length/2,h=100);
			//screwholes
			translate([0,0,motor_clip_base_z+motor_clip_thick-screw_depth])mirror_xy()translate(motor_hold_screws)cylinder(r=m2_thread_size/2,h=100);
		}
	}
}
//part of the shell with the screwholes for the motor_holder
module motor_holder_holder(){
	translate([0,-(length/2 - motor_centre_from_end),-girder_thick*1.5])
	intersection(){
		translate([0,0,motor_clip_shell_z+motor_clip_thick+girder_thick]){
			difference(){
				mirror_y()translate([motor_holder_screws_x,0,0])cylinder(r=m2_thread_size,h=10);
				mirror_y()translate([motor_holder_screws_x,0,0])cylinder(r=m2_thread_size/2,h=100,center=true);
			}
		}
	
		//intersect with solid roof and walls to prevent poking out the sides of the roof
		wall_and_roof_slice(motor_clip_hole_d*4,0,true);
	}
}

roof_notches_positions=[[module_ys[0]+18,17.5] , [length/2-door_centre_from_box_end+2.5,12]];
roof_notches_z = 29;

module roof_notches(){
	//[y pos, length]

	for(notch = roof_notches_positions){
		translate([0,notch[0],roof_notches_z])centred_cube(width,notch[1],10);
	}
	
	
}

module roof_hatches(){
	
	hatch_length = 17.5;
	hatch_distance=18.8;
	roof_shape = roof_corners(width);
	hatch_width = abs(roof_shape[2][0] - roof_shape[3][0]);
	hatch_centre_x = abs(roof_shape[2][0] + roof_shape[3][0])/2;
	hatch_centre_z = (roof_shape[2][2] + roof_shape[3][2])/2;
	
	mirror_xy(){
		//translate([0,hatch_distance/2,])
	}
}

module shell(){
	
	front_window_width = 13.5;
	front_window_height = 10.5;
	front_window_r = 2;
	front_window_z = 14;
	front_window_x = 8;
	side_window_length = 12;
	side_window_height = 9.5;
	side_window_z = 8.3;
	side_window_y = 4.9;
	side_window_bottom_corner_r=1.2;
	side_window_bottom_corner_z=side_window_z+1.9;
	side_window_bottom_corner_y=2.8;
	side_window_top_corner_y=2.15;
	
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
			
			ridgepos0=length/2-door_centre_from_box_end-door_length/2;
			ridgepos1=-(length/2-door_centre_from_fuel_end-door_length/2);
			//bottom side ridges door-to-door (minus a smidge)
			mirror_y()translate([width/2,(ridgepos0+ridgepos1)/2,0])centred_cube(girder_thick*2,ridgepos0-ridgepos1-0.5,side_base_ridge_height);
			
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
					//wall inside the cab
						mirror_y()translate([end_width/2-wall_thick/2,length/2-wall_thick/2,0])centred_cube(wall_thick,wall_thick,front_height);
					//flat bit in the middle
						translate([0,length/2+wall_front_midsection_y-wall_thick/2,wall_front_midsection_bottom_z])centred_cube(wall_front_midsection_width,wall_thick,wall_front_midsection_height);
					}
				
				//intersection with cylinder
				translate([0,0,front_top_r_z])rotate([90,0,0])cylinder(r=front_top_r,h=length*2,center=true);
					}
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
		}
	
	}
	//things to add after subtractions
	//now doing this as part of the base
	//motor_holder_holder();
	
	box_side_grill();
	
	roof_hatches();
	
	//in_door_positions()door_handrail_pair(false);
	in_door_positions()door(false);
	translate([0,-length/2+door_centre_from_fuel_end+door_and_handrails_length/2+side_fuel_grill_length/2])fuel_end_grills();
	
	
}

if(GEN_BASE){
	optional_translate([0,0,base_thick+base_height_above_track],GEN_IN_PLACE)optional_rotate([0,180,0],GEN_IN_PLACE)base();

}

if(GEN_BOGIES){
	mirror_x(GEN_IN_PLACE && DUMMY)mirror([0,1,0])optional_translate([0,-(length/2 - motor_centre_from_end),base_height_above_track-bogie_mount_height-m3_washer_thick],GEN_IN_PLACE)optional_rotate([0,180,0],GEN_IN_PLACE)bogies();
	
}

if(GEN_SHELL){
	optional_translate([0,0,base_thick+base_height_above_track],GEN_IN_PLACE)shell();
}
if(GEN_MOTOR_CLIP){
	optional_translate([0,-(length/2 - motor_centre_from_end),motor_clip_base_z+base_thick+base_height_above_track+motor_clip_thick],GEN_IN_PLACE)optional_rotate([0,180,0],GEN_IN_PLACE)motor_holder();	
}


