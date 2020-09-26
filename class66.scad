include <truck_bits.scad>
include <constants.scad>

//TODO the front is slightly narrower than the main body, it tapers from about the cab side of the door
//TODO the doors aren't symetric

//non-dummy base needs scaffolding
GEN_BASE = true;
GEN_WALLS = false;
GEN_ROOF = false;
//bogie will need scaffolding unless I split it out into a separate coupling arm
GEN_BOGIES = false;
GEN_IN_PLACE = false;

//dummy model has no motor
DUMMY = false;

//wiki says 21.4metre long, but oes this include buffers?
//n-gauge model with buffers => 21.2m
//n-gauge model without buffers -> 20.3m, so assuming without buffers
length = m2mm(21.4-1);
width = m2mm(2.65);
end_width = width-1;
height = m2mm(3.9);

wall_height = 18.6;
wall_thick = 1;



//distance from end that the taper starts twoards the narrorer end width
end_width_start = 22;

coupling_arm_thick = 1.5;
base_thick = 3;
girder_thick = 0.5;
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

base_bottom_width = width-2;
base_top_width = width;
//needs to be smaller than top width but larger than bottom width
buffer_width = width-2;

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

//wall_thick = 2;
motor_length = 70;
motor_centre_from_end = 45;
//doors are different at each end
door_centre_from_fuel_end = 28;
door_centre_from_box_end = 36;
door_length = 7;
ladder_length = 6.5;
//todo think if this is right
coupling_arm_from_mount = motor_centre_from_end;
coupling_arm_width = 8;

bogie_chain_mount_length = 3;
bogie_chain_mount_height = base_thick/2;

//statement of intent
top_of_bogie_from_rails = 15;
//measurement of wheels
bogie_wheel_d = 14.0;

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


bogie_mount_height = base_height_above_track - bogie_wheel_d/2 - (axle_to_top_of_bogie+m3_washer_thick);
//distance between the two end axles
bogie_end_axles_distance = 55;
//distance between the two bits which hold the pointy bits of the axles
//called axle_space in some places
bogie_axle_mount_width = 23;

screwhole_from_edge = 5;
//to be mirrored in x and y
base_wall_screwholes = [[width/2-screwhole_from_edge,base_arch_top_length/2+screwhole_from_edge/2,0],[width/2-5,length/2-screwhole_from_edge*1.5,0]];


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
				//top half of buffer box
				translate([0,-buffer_box_length_top/2,base_thick-girder_thick])centred_cube(buffer_width,buffer_box_length_top,buffer_box_bottom_height+girder_thick );
				//sloping bit at top of box
				translate([0,-buffer_box_length_top/2-girder_thick/2,base_thick/2])centred_cube(base_bottom_width-base_pipe_space,buffer_box_length_top-girder_thick,buffer_box_height);
				//bottom half of box
				translate([0,-buffer_box_length_bottom/2,base_thick+buffer_box_bottom_height])centred_cube(buffer_width,buffer_box_length_bottom,buffer_box_bottom_height );
				
			}
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
		translate([width/2-base_pipe_space/2,0,rung_z-girder_thick])centred_cube(base_pipe_space,ladder_length,girder_thick);
	}
}
module crane_mount_box(){
	
	mirror_y()translate([width/2-base_pipe_space/2-girder_thick/2,0])centred_cube(base_pipe_space,crane_mount_box_length,base_thick);
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
	centre_z = base_arch_height*0.35;
	mirror_y()hull(){
		
		//top of triangle
		translate([width/2-base_pipe_space-girder_thick/2,0,0])centred_cube(base_pipe_space,fuel_pump_length,girder_thick);
		
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
				translate(pos)cylinder(r=m2_thread_size/2,h=100,$fn=50);
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
	
	
	
	difference(){
		//main arm to hold bogie together
		centred_cube(wheel_holder_arm_width,bogie_end_axles_distance+bogie_wheel_d/2,bogie_thick);
		cylinder(r=m3_thread_loose_size/2,h=100,center=true);
	}
	//center axle slightly lower (or higher from the final position), so as the bogie flexes it doesn't put all the weight on the centre wheels
	bogie_axle_holder(axle_to_top_of_bogie-centre_bogie_wheel_offset/2);
	
	mirror_x()translate([0,bogie_end_axles_distance/2,0])bogie_axle_holder(axle_to_top_of_bogie+centre_bogie_wheel_offset/2);
	//centred_cube(wheel_holder_arm_width+10,bogie_arm_length,bogie_thick);
	
	//arms to hold cosmetics
	mirror_x()translate([0,bogie_end_axles_distance/4,0])centred_cube(bogie_width,bogie_cosmetic_arm_length,bogie_thick );
	
	coupling_arm_length = coupling_arm_from_mount - bogie_end_axles_distance/2 + wheel_mount_length/2;
	
	
	//adding centre_bogie_wheel_offset/2 to make up for when teh bogie bends under the weight of the loco and raises the height of the coupling
	coupling_arm_z = axle_to_top_of_bogie+bogie_wheel_d/2 -coupling_arm_thick-top_of_coupling_from_top_of_rail +centre_bogie_wheel_offset/2;
	
	//arm to hold coupling
	translate([0,-(coupling_arm_from_mount-coupling_arm_length/2-coupling_mount_length/2),coupling_arm_z])centred_cube(coupling_arm_width,coupling_arm_length-coupling_mount_length,coupling_arm_thick);
	//fill in gap under coupling arm
	translate([0,-bogie_end_axles_distance/2,0])centred_cube(coupling_arm_width,wheel_mount_length,coupling_arm_z);
	
	translate([0,-(coupling_arm_from_mount-coupling_mount_length/2),coupling_arm_z+coupling_arm_thick])coupling_mount(0,coupling_arm_thick);
}

module walls(){
	
	mirror_y()translate([width/2-wall_thick/2,0,0])centred_cube(wall_thick,length,wall_height);
}

if(GEN_BASE){
	optional_translate([0,0,base_thick+base_height_above_track],GEN_IN_PLACE)optional_rotate([0,180,0],GEN_IN_PLACE)base();

}

if(GEN_BOGIES){
	mirror_x(GEN_IN_PLACE && DUMMY)optional_translate([0,-(length/2 - motor_centre_from_end),base_height_above_track-bogie_mount_height-m3_washer_thick],GEN_IN_PLACE)optional_rotate([0,180,0],GEN_IN_PLACE)bogies();
	
}

if(GEN_WALLS){
	optional_translate([0,0,base_thick+base_height_above_track],GEN_IN_PLACE)walls();
}


