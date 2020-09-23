include <truck_bits.scad>
include <constants.scad>

GEN_BASE = true;
GEN_WALLS = false;
GEN_ROOF = false;
GEN_BOGIES = true;
GEN_IN_PLACE = true;


//wiki says 21.4metre long, but oes this include buffers?
//n-gauge model with buffers => 21.2m
//n-gauge model without buffers -> 20.3m, so assuming without buffers
length = m2mm(21.4-1);
width = m2mm(2.65);
//
height = m2mm(3.9);

base_bottom_width = width-2;
base_top_width = width;

wall_thick = 2;
motor_length = 70;
motor_centre_from_end = 45;

//statement of intent
top_of_bogie_from_rails = 15;
//measurement of wheels
bogie_wheel_d = 14.0;

bogie_axle_d = 2;
wheel_holder_width = 13.8;
wheel_holder_arm_width = 12;//10.4;
	
	
axle_to_top_of_bogie = top_of_bogie_from_rails - bogie_wheel_d/2;


bogie_width = width-2;
bogie_thick = 2.5;

base_thick = 3;
girder_thick = 0.2;
//how deep the pipe space in the side of the base is, from base_top_width
base_pipe_space = 2;

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

module motor_space(){
	intersection(){
		cylinder(r=motor_length/2,h=100,center=true);
		translate([0,0,-1])centred_cube(base_top_width-base_pipe_space*2-wall_thick*2,motor_length*2,100);
	}
}

//facing +ve y direction
module buffers(){
	
}

module base(){
	difference(){
		union(){
			centred_cube(base_top_width,length,girder_thick);
			centred_cube(base_top_width-base_pipe_space*2,length,base_thick);
			translate([0,-(length/2 - motor_centre_from_end),0])cylinder(h=base_thick+bogie_mount_height,r=m3_thread_d);
			
			translate([0,0,base_thick-girder_thick])centred_cube(base_bottom_width,length,girder_thick);
		}
		
		
		union(){
			//space for motor
			translate([0,length/2 - motor_centre_from_end,0])motor_space();
			//screwhole for bogie
			translate([0,-(length/2 - motor_centre_from_end),0])cylinder(h=100,r=m3_thread_d/2,center=true);
			//thinner area for bogie?
		}
		
	}
}

module bogie_axle_holder(axle_height){
	
	
	difference(){
		union(){
			mirror_y()translate([wheel_holder_arm_width/2-bogie_thick/2,0,0])centred_cube(bogie_thick,bogie_wheel_d*0.5,axle_height+bogie_axle_d);
			translate([0,0,axle_height])rotate([0,90,0])cylinder(h=wheel_holder_width,r=bogie_axle_d, center=true );
		}
		
		union(){
			//hole to hold axle
			translate([0,0,axle_height])rotate([0,90,0])cylinder(h=100,r=bogie_axle_d/2 + 0.25, center=true );
			//slot to insert axle
			translate([0,0,axle_height])centred_cube(100,bogie_axle_d+0.1,100);
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
	bogie_axle_holder(axle_to_top_of_bogie-1);
	
	mirror_x()translate([0,bogie_end_axles_distance/2,0])bogie_axle_holder(axle_to_top_of_bogie);
	//centred_cube(wheel_holder_arm_width+10,bogie_arm_length,bogie_thick);
	
	//arms to hold cosmetics
	mirror_x()translate([0,bogie_end_axles_distance/4,0])centred_cube(bogie_width,bogie_cosmetic_arm_length,bogie_thick );
}

if(GEN_BASE){
	optional_translate([0,0,base_thick+base_height_above_track],GEN_IN_PLACE)optional_rotate([0,180,0],GEN_IN_PLACE)base();

}

if(GEN_BOGIES){
	optional_translate([0,-(length/2 - motor_centre_from_end),base_height_above_track-bogie_mount_height-m3_washer_thick],GEN_IN_PLACE)optional_rotate([0,180,0],GEN_IN_PLACE)bogies();

}