include <constants.scad>
use <MCAD/regular_shapes.scad>

wiggle = 0.1;
thick = 1.5;


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
gear_axle_width = 11.5;
gear_axle_d = 1.5+0.2;
gear_distance_plastic = 6.1;
gear_distance_metal = 8.5;

//distance from centre of gear axle to centre of wheel axle (aprox, will need testing)
//could take distance and use any angle I want
wheel_from_axle_y = 2.7;
wheel_from_axle_z = 6.75;

wheel_d = 11.4;
wheel_holder_inner_d = gear_width;//9.2;
wheel_holder_outer_d_max = 13.5;
wheel_holder_diameter = 2.1;
wheel_holder_height = wheel_holder_diameter*0.9;
wheel_holder_length = wheel_d/2;




wire_hole_r = motor_plastic_bit_space_length/2;
wire_hole_x = 6.3;

screwhole_x_distance = 18;
screwhole_y_distance = 40;

base_length = motor_length + wiggle*2 + motor_metal_end_gear_distance + motor_plastic_end_gear_distance + 10;
base_width = motor_width + wiggle*2 + thick*2;
base_thick = thick+motor_plastic_bit_space_height;

//just for space to hold screws
//extra_base_width = base_width+5;





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
			translate([0,0,gear_axle_height+base_thick+gear_axle_d/2])rotate([0,90,0])cylinder(h=gear_axle_width*2,r=gear_axle_d/2,center=true);
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
		translate([wheel_holder_inner_d/2+thick/2,0,0])centred_cube(thick,wheel_holder_length,gear_axle_height+gear_axle_d/2+base_thick+wheel_from_axle_z+wheel_holder_height);
		union(){
			//hole for axle
			translate([0,0,gear_axle_height+gear_axle_d/2+base_thick+wheel_from_axle_z])rotate([0,90,0])cylinder(h=wheel_holder_outer_d_max,r=wheel_holder_diameter/2,center=true);
			//slot above 
			translate([wheel_holder_inner_d/2+0.1,0,gear_axle_height+gear_axle_d/2+base_thick+wheel_from_axle_z])centred_cube(thick*2,wheel_holder_diameter*0.6,wheel_holder_height+0.1);
		}
	}
}

intersection(){
	difference(){
		
		union(){
			
			//base for motor with space for sticky out bit with wires
			difference(){
				union(){
					centred_cube(base_width, motor_length, base_thick);
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
		}
		//punch out various holes
		union(){
			translate([0,motor_length/2+gear_distance_plastic,0])gear_holder_holes(gear_distance_plastic*2);
			translate([0,-motor_length/2-gear_distance_metal,0])gear_holder_holes(gear_distance_metal*2);
			
			//screwholes
			mirror_xy()translate([screwhole_x_distance/2,screwhole_y_distance/2,0])cylinder(h=base_thick*10,r=m2_thread_size_loose/2, center=true);
			
			//lop off the end that's a bit too long
			//translate([0,-motor_length/2-gear_distance_metal-wheel_from_axle_y-100/2-wheel_holder_length/4,0])cube([base_width,100,100], center=true);
		}
	}//end difference
	
	union(){
		plastic_end_wheel = gear_distance_plastic+wheel_from_axle_y+wheel_holder_length/2;
		metal_end_wheel = gear_distance_metal+wheel_from_axle_y + wheel_holder_length/2;
		wheelToWheel = motor_length + plastic_end_wheel + metal_end_wheel;
		
		//wheel holders (longest bit)
		translate([0,(plastic_end_wheel-metal_end_wheel)/2,0])cube([wheel_holder_inner_d+thick*2,wheelToWheel,100], center=true);
		//motor holder (shortened)
		cube([base_width,motor_length*0.7,100], center=true);
	}
	
	
}//end intersection
