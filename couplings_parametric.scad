include <OO_large_coupling.scad>
include <constants.scad>
include <hook_for_clip.scad>
/*

The Hornby X8031 style coupling was one of the first things I made in openscad.
I'd like to think I've got better at what to abstract and what not, since then.

This is an attempt at one file which can be configured to generate various
different types of coupling

TODO: auto-generated hook from geometries of the hinge position and coupling size


Notes:
 - The inlike hook will likely clash with most holders for the X8031 FIXING.
 - The chunky hook works with most holders for the X8031, but doesn't fit on some hornby locos. (too wide with the 3d printed hook)

*/
GEN_COUPLING = true;
GEN_HOOK = true;
GEN_IN_SITU = true;

//only "wide" currently
STYLE = "wide";
/*
'none' - no hook at all
'chunky' - my first stab at the x8031 hook, bit bigger than the real x8031
'inline' - newer hornby/dapol style
*/
HOOK = "inline";

/*
X8031 - Hornby/bachmann style, centralscrewhole with two dents on either side
dovetail - Hornby dovetail FIXING, I think intended to hold a NEM socket. I'll go for something that fits directly into the dovetail fixing
*/
FIXING = "dovetail";

min_thickness = 1.5;
x8031_main_arm_length = 5.9;
x8031_main_arm_width = 6;

hook_holder_diameter = 1.8;
hook_holder_length = 1.3;

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

module chunky_hook(subtract = false){
	if(subtract){
	}
	else{
		chunky_hook_base_width = 8;
		
		//add the stub at the bottom for holding the hook
		translate([-chunky_hook_base_width/2, -x8031_main_arm_length, 0]){
			cube([chunky_hook_base_width, x8031_main_arm_length, min_thickness]);
		}
		
		
		hook_base_length = 3.4;
		hook_height = 4.7+1;
		
		hook_holder_end_cap_thickness = 0.6;
		hook_holder_height=4;
		hook_holder_y=x8031_main_arm_length - hook_base_length/2;

		anti_wobble = 3;

		hook_base_clip(x=-hook_holder_end_cap_thickness*2, y=-x8031_main_arm_length, width=chunky_hook_base_width/2, length=hook_base_length, height=hook_height, hook_holder_radius=hook_holder_diameter/2, hook_holder_length=hook_holder_length, hook_holder_end_cap_thickness=hook_holder_end_cap_thickness*2, hook_holder_height=hook_holder_height, hook_holder_y=hook_holder_y);
		
		//echo("x=",-hook_holder_end_cap_thickness*2 + chunky_hook_base_width/4,"y=",-x8031_main_arm_length+hook_base_length/2,"z=",hook_holder_height);

	}
	
}

module inline_hook(subtract = false){
	hook_wall_thick = 1;
	main_arm_length = 2.4;
	hook_walls_size = hook_holder_diameter*1.5;
	if(subtract){
		//space for hook
		translate([coupling_hook_x,main_arm_length/2,0])centred_cube(hook_holder_length+hook_wall_thick*2,hook_holder_diameter*2,10);
	}else{
		
		z = min_thickness > hook_holder_diameter ? min_thickness/2 : hook_holder_diameter/2;
		
		translate([coupling_hook_x,main_arm_length/2,z])rotate([0,90,0])cylinder(r=hook_holder_diameter/2,h=hook_holder_length,center=true);
		
		
		hook_arm_length = main_arm_length + hook_holder_diameter;
		translate([coupling_hook_x,main_arm_length/2,0])mirror_y()translate([hook_holder_length/2+hook_wall_thick/2,0,0])centred_cube(hook_wall_thick,hook_arm_length,hook_walls_size);
	}
	
}


module dovetail_fixing(subtract = false){
	dovetail_length = 10; 
	dovetail_main_width = 5;
	dovetail_thick = 3.2;
	
	big_triangle_width = 7.4;
	big_triangle_length = 3.75;//bit of a guess
	big_triangle_y = 7;
	little_triangle_width = 4.25;
	little_triangle_length = 2.5;
	little_triangle_end_thick = 0.5;
	
	translate([0,-(dovetail_length-little_triangle_length*0.75)/2,0])centred_cube(dovetail_main_width, dovetail_length-little_triangle_length*0.75,dovetail_thick);
	
	hull(){
		translate([0,-(dovetail_length-little_triangle_end_thick/2),0])centred_cube(little_triangle_width,little_triangle_end_thick,dovetail_thick);
		translate([0,-(dovetail_length-little_triangle_length-0.05),0])centred_cube(0.1,0.1,dovetail_thick);
		
	}
	
	hull(){
		translate([0,-(big_triangle_y-little_triangle_end_thick/2),0])centred_cube(big_triangle_width,little_triangle_end_thick,dovetail_thick);
		translate([0,-(big_triangle_y-big_triangle_length-0.05)])centred_cube(0.1,0.1,dovetail_thick);
	}
	
}

module coupling_body(){
	difference(){
		if(STYLE=="wide"){
			coupling_base();
		}
		if(HOOK == "chunky"){
			chunky_hook(true);
		}
		if(HOOK == "inline"){
			inline_hook(true);
		}
	}
	
	if(HOOK == "chunky"){
		chunky_hook(false);
	}
	if(HOOK == "inline"){
		inline_hook(false);
	}
}

module fixing(subtract = false){
	if(!subtract){
		if(FIXING=="X8031"){
			x8031_fixing(subtract);
		}
		if(FIXING == "dovetail"){
			dovetail_fixing(subtract);
		}
	}
}
if(GEN_COUPLING){
	difference(){
		union(){
			coupling_body();
			fixing(false);
		}
		fixing(true);
	}

}

if(GEN_HOOK){
	//todo calculate these rather than hardcode?
	hook_pos = HOOK == "chunky" ? [3.4+0.5,-4.2,4] : HOOK == "inline" ? [coupling_hook_x+0.5,2.4/2,hook_holder_diameter/2] : [0,0];
	
	//[hook_pos[0]+0.5,hook_pos[1]+3.5,hook_pos[2]+6.7]
	optional_translate(hook_pos,GEN_IN_SITU)optional_rotate([-90,0,90],GEN_IN_SITU)wide_coupling_hook([hook_pos[1],hook_pos[2]]);

	
}