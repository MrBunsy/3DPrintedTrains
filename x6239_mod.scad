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
include <truck_bits.scad>
use <MCAD/regular_shapes.scad>

GEN_BASE = true;
GEN_WHEEL_CLIP = false;
GEN_COSMETICS = false;
GEN_COUPLING_ARM = false;
GEN_IN_PLACE = true;

wiggle = 0.1;
thick = 1.5;
min_thick=0.2;
clip_thick=thick;

coupling_arm_thick = thick*2;
//TODO
coupling_arm_length = 5;


//the axle with tyres actually seems to be slightly less, without slightly more.
wheel_diameter = 11.4;

//from metal end (without nib) to end of plastic end (with large n
motor_length = 27.3;
motor_width = 19.8;
//including plastic end nib
motor_plastic_end_length = 7.2;

motor_plastic_bit_space_height = 1.8;
//bit more than needed
motor_plastic_bit_space_length = 5.5;
motor_plastic_bit_space_start_y = motor_length/2 - motor_plastic_end_length;//6.5;

//desired distance from end for the first gear
motor_metal_end_gear_distance = 7.5;
motor_plastic_end_gear_distance = 7.0;

motor_height = 15.1;
motor_side_holder_platic_d = 3.1;
motor_side_holder_platic_length = 4.9;
motor_side_holder_metal_d = 2.2;

//from base of motor to bottom of gear axle
gear_axle_height = 12.85;//12.25+0.3;
//space for the gear
gear_width = 8.3+wiggle;
gear_length = 10;
gear_axle_width = 11.5;
//1.7 works but sliiightly too tight when printed at 0.2mm layer height
gear_axle_d = 1.5+0.2;//5;
gear_distance_plastic = 6.1;
gear_distance_metal = 8.5;

//distance from centre of gear axle to centre of wheel axle (aprox, will need testing)
//could take distance and use any angle I want
wheel_from_axle_y = 2.7;
wheel_from_axle_z = 6.75;

wheel_d = 11.4;
wheel_holder_inner_d = gear_width;//9.2;
wheel_holder_outer_d_max = 13.5;
//2.1 is a bit tight, but not sure I want it too loose either.
wheel_holder_diameter = 2.1;//5;//+0.1;
//height above centre of wheel axle, making this just taller than the non-toothed bit of the wheel's gear (4mm diameter)
wheel_holder_height = 2+0.3;

//space needed for the wheel's gear to not be obstructed
wheel_gear_space_d = 10;
wheel_gear_space_width = 3;
wheel_holder_length = wheel_gear_space_d;
gear_space_d = 8;

wheel_end_width = wheel_holder_inner_d+thick*2;



wire_hole_r = motor_plastic_bit_space_length/2;
wire_hole_x = 6.3;

screwhole_x_distance = 18;
screwhole_y_distance = 40;

base_length = motor_length + wiggle*2 + motor_metal_end_gear_distance + motor_plastic_end_gear_distance + 10;
base_width = motor_width + wiggle*2 + thick*2;
base_thick = thick+motor_plastic_bit_space_height;

//just for space to hold screws
//extra_base_width = base_width+5;

//height from ground plane of the wheel axle
wheel_z = gear_axle_height+gear_axle_d/2+base_thick+wheel_from_axle_z;

plastic_end_wheel = gear_distance_plastic+wheel_from_axle_y+wheel_holder_length/2;
metal_end_wheel = gear_distance_metal+wheel_from_axle_y + wheel_holder_length/2;
endToEnd = motor_length + plastic_end_wheel + metal_end_wheel;

top_of_coupling_arm_from_wheel_holder_height = wheel_holder_height - wheel_diameter/2 + top_of_coupling_from_top_of_rail;

echo(top_of_coupling_arm_from_wheel_holder_height);

//facing -ve x
module motor_holder(h,r){
	//was experiment with trianglular prism rotate([0,0,-30])
	rotate([90,0,0])difference(){
		cylinder(h=h,r=r,center=true);
		translate([r,0,h/2])cube([r*2,r*2,h*2],center=true);
	}
}
module gear_holder_holes(length){
//hole for axle
			translate([0,0,gear_axle_height+base_thick+gear_axle_d/2])rotate([0,90,0])cylinder(h=gear_axle_width*2,r=gear_axle_d/2+wiggle,center=true);
}

module gear_holder(length){
	
	mirror_y()difference(){
		translate([gear_width/2+thick/2,0,0])centred_cube(thick,length,gear_axle_height+base_thick+gear_axle_d*2);
		union(){
			gear_holder_holes(length);
		}
	}
	
}

//wheel holder for the motor side (just a slot for the axle)
module wheel_holder_base(){
	mirror_y()difference(){
		translate([wheel_holder_inner_d/2+thick/2,0,0])centred_cube(thick,wheel_holder_length,wheel_z+wheel_holder_height);
		union(){
			//hole for axle
			translate([0,0,gear_axle_height+gear_axle_d/2+base_thick+wheel_from_axle_z])rotate([0,90,0])cylinder(h=wheel_holder_outer_d_max,r=wheel_holder_diameter/2+wiggle,center=true);
			//slot above 
			translate([wheel_holder_inner_d/2+0.1,0,wheel_z])centred_cube(thick*2,wheel_holder_diameter,wheel_holder_height+0.1);
		}
	}
	
	
}

//upwards facing, side mounted screw hole, assuming latched onto a surface facing +ve y
//screwhole inline with xy plane
//height is of longest edge
module side_screwhole(thread_size, height, angled_base=true){
	size = thread_size*2;
	difference(){
		union(){
			translate([0,size/4,-height])centred_cube(size,size/2,height);
			translate([0,size/2,-height])cylinder(r=size/2,h=height);
			
		}
		union(){
			if(angled_base){
			translate([-size,size,size-height])rotate([-(90+45),0,0])cube([size*2,size*2,size*2]);
			translate([0,size/2,-height])cylinder(r=thread_size/2,h=height*3,center=true);
			}
		}
		
	}
}

//the main body to be printed, powers the wheels from the motor
//but needs coupling arm and base clip and cosmetics to be complete
module motor_and_wheels_holder(){

intersection(){
	difference(){
		
		union(){
			
			//base for motor with space for sticky out bit with wires
			difference(){
				union(){
					translate([0,(plastic_end_wheel-metal_end_wheel)/2,0])centred_cube(base_width, motor_length+plastic_end_wheel+metal_end_wheel, base_thick);
					centred_cube(wheel_holder_inner_d, base_length, base_thick);
				}
				union(){
					//cut out space for the plastic bit of the motor with the wires
					translate([-motor_width/2-wiggle,motor_plastic_bit_space_start_y,thick])cube([motor_width+wiggle*2, motor_plastic_bit_space_length, motor_plastic_bit_space_height+1]);
					//holes for wires
					mirror_y()translate([wire_hole_x,motor_plastic_bit_space_start_y+wire_hole_r,-0.1])cylinder(h=thick*4, r=wire_hole_r);
				}
			}
			
			
			
			
			//motor_side_holder_platic_length-(motor_length/2 - motor_plastic_bit_space_start_y)
			//sides to hold motor
			mirror_y()translate([base_width/2-thick/2,0,0])
				centred_cube(thick,motor_length,motor_height/2+motor_side_holder_platic_d/2+base_thick);

			//holder for plastic end
			mirror_y()translate([motor_width/2+wiggle,motor_plastic_bit_space_start_y+motor_side_holder_platic_length/2,motor_height/2+base_thick])motor_holder(motor_side_holder_platic_length,motor_side_holder_platic_d/2);

			translate([0,motor_length/2+gear_distance_plastic,0])gear_holder(gear_distance_plastic*2);
			translate([0,-motor_length/2-gear_distance_metal,0])gear_holder(gear_distance_metal*2);
	
			
			translate([0,motor_length/2+gear_distance_plastic+wheel_from_axle_y,0])wheel_holder_base();
			translate([0,-motor_length/2-gear_distance_metal-wheel_from_axle_y,0])wheel_holder_base();
			
			//ends
			translate([0,motor_length/2 + plastic_end_wheel+thick/2,0])centred_cube(wheel_end_width,thick,wheel_z+wheel_holder_height);
			translate([0,-motor_length/2 -metal_end_wheel-thick/2,0])centred_cube(wheel_end_width,thick,wheel_z+wheel_holder_height);
			//screw holes for coupling arm (and one end of wheel holder)
			mirror_y()translate([(wheel_end_width)/2 -m2_thread_size,motor_length/2 + plastic_end_wheel+thick,wheel_z+wheel_holder_height-top_of_coupling_arm_from_wheel_holder_height-coupling_arm_thick])side_screwhole(m2_thread_size, 10);
			
			translate([0,-(motor_length/2 + metal_end_wheel+thick),wheel_z+wheel_holder_height])mirror([0,1,0])side_screwhole(m2_thread_size, 10);
			
		}
		//punch out various holes
		union(){
			translate([0,motor_length/2+gear_distance_plastic,0])gear_holder_holes(gear_distance_plastic*2);
			translate([0,-motor_length/2-gear_distance_metal,0])gear_holder_holes(gear_distance_metal*2);
			
			//screwholes
			//mirror_xy()translate([screwhole_x_distance/2,screwhole_y_distance/2,0])cylinder(h=base_thick*10,r=m2_thread_size_loose/2, center=true);
			
			
			//keep the ends separate from the axle holders, so the holders can bend
			translate([0,-(motor_length/2 + metal_end_wheel)+min_thick/2,base_thick])centred_cube(100,min_thick,100);
			
			translate([0,(motor_length/2 + plastic_end_wheel)-min_thick/2,base_thick])centred_cube(100,min_thick,100);
		}
	}//end difference
	
	union(){
		
		
		//wheel holders (longest bit)
		translate([0,(plastic_end_wheel-metal_end_wheel)/2,0])cube([wheel_end_width,endToEnd*3,100], center=true);
		//motor holder (shortened)
		cube([base_width,motor_length*0.7,100], center=true);
	}
	
	
}//end intersection

}//end module

//facing +ve y, (0,0) is between the screwholes
module coupling_arm(){
	difference(){
		centred_cube(wheel_end_width,m2_thread_size*2,coupling_arm_thick);
		mirror_y()translate([(wheel_end_width)/2-m2_thread_size,0,0])cylinder(h=100,r=m2_thread_size/2,center=true);
	}
	
	coupling_arm_width = wheel_end_width/2;
	translate([-coupling_arm_width/2,m2_thread_size,0])cube([coupling_arm_width,coupling_arm_length,coupling_arm_thick]);
	
	translate([0,coupling_arm_length+m2_thread_size+coupling_mount_length/2,coupling_arm_thick])coupling_mount(0,coupling_arm_thick);
	
	size=m2_thread_size*2;
	height = top_of_coupling_arm_from_wheel_holder_height+coupling_arm_thick;
	difference(){
		union(){
			translate([0,-size/4,0])centred_cube(size,size/2,height);
			translate([0,0,0])cylinder(r=size/2,h=height);
		}
		translate([0,0,0])cylinder(r=m2_thread_size/2,h=height*4,center=true);
	}

}

module wheel_clip(){
	
	middle_length = endToEnd+thick*2;
	wheel_axle_spacing = motor_length+gear_distance_plastic + gear_distance_metal+wheel_from_axle_y*2;
	difference(){
		hull(){
			centred_cube(wheel_end_width,middle_length,clip_thick);
			mirror_x()translate([0,middle_length/2+m2_thread_size])cylinder(r=m2_thread_size,h=clip_thick);
		}
		union(){
			//screwholes for ends
			mirror_x()translate([0,middle_length/2+m2_thread_size])cylinder(r=m2_thread_size/2,h=clip_thick*3,center=true);
			//wheel holes
			mirror_x()translate([0,wheel_axle_spacing/2,-0.1])centred_cube(wheel_gear_space_width,wheel_gear_space_d,clip_thick*3);
		}
	}
	
	mirror_xy()translate([wheel_end_width/2-thick/2,endToEnd/2-wheel_holder_length/2,clip_thick])centred_cube(thick,wheel_holder_diameter-wiggle*2,wheel_holder_height-wheel_holder_diameter/2-wiggle);
}

if(GEN_BASE){
	motor_and_wheels_holder();
}
	
if(GEN_COUPLING_ARM){
	optional_translate([0,motor_length/2 + plastic_end_wheel+thick + m2_thread_size,wheel_z+wheel_holder_height-top_of_coupling_arm_from_wheel_holder_height-coupling_arm_thick],GEN_IN_PLACE)coupling_arm();
}

if(GEN_WHEEL_CLIP){
	//arm (or bar?) to hole wheels in place and give cosmetics somewhere to attach
	optional_translate([0,(plastic_end_wheel-metal_end_wheel)/2,wheel_z+wheel_holder_height+clip_thick],GEN_IN_PLACE)optional_rotate([0,180,0],GEN_IN_PLACE)wheel_clip();
}
