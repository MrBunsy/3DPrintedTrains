include <OO_large_coupling.scad>
include <constants.scad>
/*

The Hornby X8031 style coupling was one of the first things I made in openscad.
I'd like to think I've got better at what to abstract and what not, since then.

This is an attempt at one file which can be configured to generate various
different types of coupling

*/


//only "wide" currently
STYLE = "wide";
/*
'none' - no hook at all
'chunky' - my first stab at the x8031 hook, bit bigger than the real x8031
*/
HOOK = "chunky";

/*
X8031 - Hornby/bachmann style, centralscrewhole with two dents on either side
dovetail - Hornby dovetail fitting, I think intended to hold a NEM socket. I'll go for something that fits directly into the dovetail fixing
*/
FITTING = "X8031";



min_thickness = 1.5;
x8031_main_arm_length = 5.9;
x8031_main_arm_width = 6;

module x8031_fixing(subtract=false){
	
	hole_diameter = 2.7;
	second_hole_diameters=2;
	second_hole_distance=7.5;
	
	
	if(subtract){
		cylinder(h=min_thickness*3, r=hole_diameter/2, center = true, $fn=200);
           translate([-second_hole_distance,0,0]){
            cylinder(h=min_thickness*3, r=second_hole_diameters/2, center = true, $fn=200);
           };
           translate([second_hole_distance,0,0]){
            cylinder(h=min_thickness*3, r=second_hole_diameters/2, center = true, $fn=200);
           }
	}else{
		
		translate([-x8031_main_arm_width/2, -x8031_main_arm_length, 0]){
		cube([x8031_main_arm_width, x8031_main_arm_length, min_thickness]);
	}
		
	}
		
}

module chunky_hook(){
	
	chunky_hook_base_width = x8031_main_arm_width+2;
	
	//add the stub at the bottom for holding the hook
	translate([-chunky_hook_base_width/2, -x8031_main_arm_length, 0]){
		cube([chunky_hook_base_width, x8031_main_arm_length, min_thickness]);
	}
	
	
	hook_base_length = 3.4;
	hook_height = 4.7+1;
	//2.0 works for the garden wire I'm using, but it's hard to bend it to a shape with a 45deg angle at the front so it can auto-couple, might need thinner wire
	//hook_holder_diameter = 1.8;//1.6 too small, 1.9 just doesn't quite drop under its own weight
	//hoping 1.8 is good enough to hold wire in place with friction

	hook_holder_diameter = 1.8;

	hook_holder_length = 1.3;
	hook_holder_end_cap_thickness = 0.6;
	hook_holder_height=4;
	hook_holder_y=x8031_main_arm_length - hook_base_length/2;

	anti_wobble = 3;

	hook_base_clip(-hook_holder_end_cap_thickness*2, -x8031_main_arm_length, chunky_hook_base_width/2, hook_base_length, hook_height, hook_holder_diameter/2, hook_holder_length, hook_holder_end_cap_thickness*2, hook_holder_height, hook_holder_y);

	
	
}

module body(){

	if(STYLE=="wide"){
		coupling_base();
	}
	if(HOOK == "chunky"){
		chunky_hook();
	}
}

module fixing(subtract = false){
	if(FITTING=="X8031"){
		x8031_fixing(subtract);
	}
}

difference(){
	union(){
		body();
		fixing(false);
	}
	fixing(true);
}


