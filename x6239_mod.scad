include <constants.scad>
use <MCAD/regular_shapes.scad>

//from metal end (without nib) to end of plastic end (with large n
motor_length = 27.3;
motor_width = 19.8;

motor_plastic_bit_space_height = 1.8;
//bit more than needed
motor_plastic_bit_space_length = 6.0;
motor_plastic_bit_space_start_y = 6.5;

//desired distance from end for the first gear
motor_metal_end_gear_distance = 7.5;
motor_plastic_end_gear_distance = 7.0;

motor_height = 15.1;
motor_side_holder_platic_d = 3.1;
motor_side_holder_platic_length = 4.9;
motor_side_holder_metal_d = 2.2;

//from base of motor
axle_height = 12.25+0.3;

wiggle = 0.1;
thick = 0.5;

wire_hole_r = 2;
wire_hole_x = 6.3;


base_length = motor_length + wiggle*2 + motor_metal_end_gear_distance + motor_plastic_end_gear_distance + 10;
base_width = motor_width + wiggle*2 + thick*2;
base_thick = thick+motor_plastic_bit_space_height;



difference(){
	centred_cube(base_width, base_length, base_thick);
	union(){
		//cut out space for the plastic bit of the motor with the wires
		translate([-motor_width/2-wiggle,motor_plastic_bit_space_start_y,thick])cube([motor_width+wiggle*2, motor_plastic_bit_space_length, motor_plastic_bit_space_height+1]);
		//holes for wires
		mirror_y()translate([wire_hole_x,motor_plastic_bit_space_start_y+wire_hole_r,-0.1])cylinder(h=thick*4, r=wire_hole_r);
	}
}

//facing -ve x
module motor_holder(h,r){
	//was experiment with trianglular prism rotate([0,0,-30])
	rotate([90,0,0])difference(){
		cylinder(h=h,r=r,center=true);
		translate([r,0,h/2])cube([r*2,r*2,h*2],center=true);
	}
}


//sides to hold motor
mirror_y()translate([base_width/2-thick/2,motor_side_holder_platic_length-(motor_length/2 - motor_plastic_bit_space_start_y),0])
	centred_cube(thick,motor_length,motor_height/2+motor_side_holder_platic_d/2+base_thick);

mirror_y()translate([motor_width/2+wiggle,motor_plastic_bit_space_start_y+motor_side_holder_platic_length/2,motor_height/2+base_thick])motor_holder(motor_side_holder_platic_length,motor_side_holder_platic_d/2);