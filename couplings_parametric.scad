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
 - The inline hook will likely clash with most holders for the X8031 fixing.
 - The chunky hook works with most holders for the X8031, but doesn't fit on some hornby locos. (too wide with the 3d printed hook)

*/
GEN_COUPLING = true;
GEN_HOOK = false;
GEN_IN_SITU = false;

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
dovetail - Hornby dovetail fixing, I think intended to hold a NEM socket. I'll go for something that fits directly into the dovetail fixing
dapol - Dapol's clip-in fixing. Possibly also known Hornby X9660 and Airfix?
NEM - NEM 362
*/
FIXING = "NEM";

min_thickness = 1.5;
x8031_main_arm_length = 5.9;
x8031_main_arm_width = 6;

hook_holder_diameter = 1.8;
hook_holder_length = 1.3;
wide_coupling_width = 21;
wide_coupling_base_arm_length = 2.4;

module NEM_fixing(subtract = false){
	if(!subtract){
		width = NEM_pocket_width-0.2;
		length = NEM_pocket_deep-0.1;
		height = NEM_pocket_holder_height-0.2;
		slot_y = length*0.4;
		slot_width= width*0.6;
		//exagerrated size because they don't slice well
		wedge_stick_out = 1;//(slot_width-0.25)/2;
		difference(){
			union(){
				//main arm
				translate([0,-length/2,0])centred_cube(width, length, height);
				//wedges on the end
				mirror_y()hull(){
					translate([width/2+wedge_stick_out, -length,0])centred_cube(0.001,0.001,height);
					translate([0, -length,0])centred_cube(0.001,0.001,height);
					translate([0, -length-(width/2+wedge_stick_out),0])centred_cube(0.001,0.001,height);
				}
			}
			union(){
				//slot down the length of the arm
				hull(){
					translate([0,-slot_y,0])cylinder(r=slot_width/2,h=height*3,center=true);
					translate([0,-length*1.5,0])cylinder(r=slot_width/2,h=height*3,center=true);
				}
				//translate([0,-length/2-slot_y+r,height*0.4])centred_cube(width-0.4,length,height);
			}
		}
	}
}

module x8031_fixing(subtract=false){
	
	hole_diameter = 2.7;
	second_hole_diameters=2;
	second_hole_distance=7.5;
	
	
	if(subtract){
		//big hole in centre
		cylinder(h=10, r=hole_diameter/2, center = true, $fn=200);
        //two smaller half holes
		mirror_y()translate([second_hole_distance,0,0])cylinder(h=min_thickness*3, r=second_hole_diameters/2, center = true, $fn=200);
           
	}else{
		
		translate([-x8031_main_arm_width/2, -x8031_main_arm_length, 0])cube([x8031_main_arm_width, x8031_main_arm_length, min_thickness]);
		
	}
		
}

module dapol_fixing(subtract=false){
	if(!subtract){
		base_width = 7.25;
		base_length = 1.8;
		base_extra_length = 2.4;
		hole_d = 2.65;
		coupling_arm_length = 4.2;
		extra_length = coupling_arm_length-wide_coupling_base_arm_length;
		
		dapol_thick = 1.4;
		
		main_width = 4.6;
		main_length = 7.75;
		hole_y = 3.8+hole_d/2;
		
		//extend main arm in y, and take out notch for inline hinge
		
		difference(){
			union(){
				//main coupling arm extension
				translate([0,-extra_length/2,0])centred_cube(wide_coupling_width,extra_length,min_thickness);
				
				
				hull(){
					//start of tapered section
					translate([0,-base_length/2-extra_length,0])centred_cube(base_width,base_length,dapol_thick);
					translate([0,-base_length/2-extra_length-base_extra_length/2,0])centred_cube(main_width,base_extra_length,dapol_thick);
					
				}
				//main fixing arm
				translate([0,-main_length/2-extra_length,0])centred_cube(main_width,main_length,dapol_thick);
			}
			union(){
				//take out the notch for the inline coupling. not quite as parametric as planned, hey?
				hook_base(true);
				
				//bits for the fixing
				
				translate([0,-extra_length-hole_y,0])cylinder(r=hole_d/2,h=10,center=true);
				
				hull(){
						translate([0,-extra_length-hole_y-hole_d/3,0])cylinder(r=hole_d/4,h=10,center=true);
					translate([0,-extra_length-main_length-0.5,0])centred_cube(main_width*0.8,1,5);
				}
			}
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
		translate([coupling_hook_x,main_arm_length/2,0])centred_cube(hook_holder_length,hook_holder_diameter*3,10);
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
	big_triangle_end_thick = 0.5;
	little_triangle_width = 4.7;
	little_triangle_length = 2.6;
	little_triangle_end_thick = 0.1;
	
	little_triangle_bottom_width = 3.8;
	little_triangle_bottom_lesslong = 0.1;
	
	if(!subtract){
	
		translate([0,-(dovetail_length-little_triangle_length*0.75)/2,0])centred_cube(dovetail_main_width, dovetail_length-little_triangle_length*0.75,dovetail_thick);
		
		hull(){
			translate([0,-(dovetail_length-little_triangle_end_thick/2),dovetail_thick-0.05])centred_cube(little_triangle_width,little_triangle_end_thick,0.05);
			translate([0,-(dovetail_length-little_triangle_end_thick/2-little_triangle_bottom_lesslong),0])centred_cube(little_triangle_bottom_width,little_triangle_end_thick,0.05);
			
			translate([0,-(dovetail_length-little_triangle_length-0.05),0])centred_cube(0.1,0.1,dovetail_thick);
			
		}
		
		hull(){
			translate([0,-(big_triangle_y-big_triangle_end_thick/2),0])centred_cube(big_triangle_width,big_triangle_end_thick,dovetail_thick);
			translate([0,-(big_triangle_y-big_triangle_length-0.05)])centred_cube(0.1,0.1,dovetail_thick);
		}
	}
	
}

module coupling_body(STYLE){
//	difference(){
		if(STYLE=="wide"){
			coupling_base(base_width = wide_coupling_base_arm_length, coupling_width = wide_coupling_width);
		}
	/*	if(HOOK == "chunky"){
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
	}*/
}
module hook_base(subtract=false){
	if(HOOK == "chunky"){
		chunky_hook(subtract);
	}
	if(HOOK == "inline"){
		inline_hook(subtract);
	}
}

module fixing(subtract = false){
	if(FIXING=="X8031"){
		x8031_fixing(subtract);
	}
	if(FIXING == "dovetail"){
		dovetail_fixing(subtract);
	}
	if(FIXING == "dapol"){
		dapol_fixing(subtract);
	}
	if(FIXING == "NEM"){
		NEM_fixing(subtract);
	}
}

module gen_couplings(GEN_COUPLING, GEN_HOOK ,GEN_IN_SITU, STYLE, HOOK, FIXING){
	if(GEN_COUPLING){
		difference(){
			union(){
				difference(){
					coupling_body(STYLE);
					hook_base(true);
				}
				fixing(false);
				hook_base(false);
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
}

gen_couplings(GEN_COUPLING, GEN_HOOK ,GEN_IN_SITU, STYLE, HOOK, FIXING);