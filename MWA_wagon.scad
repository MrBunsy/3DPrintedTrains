/*
Copyright Luke Wallin 2021

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

/*
Seen a few variants:

 - MWA Green freightliner with thin panel for logo on side and parking brake roughly centre of wagon
 - MWA-B Grey freightliner with tall panel for logo on side and parking brake on one bogie
 
 not to be confused with
 - MMA Red DB different numbers of ridges, different ends but parking brake in same place as green freightliner
 
  - MJA looks similar to MWA but wagons come in pairs
 
 Plan: green freightliner design seems easiest, althouhg might still consider printing it in any of the colours
 
 
 as usual 'width' usually refers to anything in the x direction and 'length' in y
 
 ideally want 10.5mm wheels but I've only got 12.5mm, so might just raise the whole thing up a bit



First print observations:
 - back ridges weren't connected (fixed)
 - Warping caused by the bridging of the wagon base is visible. Might want to ensure that happens where I want a line, or design a more narrow bit or split into base + top half, like the trucks?
 - I forgot to make extra space behind the buffer holes, in case they snap.
 - The couplings could snag slightly on the base of the wagon, I think raise them up and print the bogies with scaffolding?

I think splitting into base and top half might be the easiest solution? There's a seam on the real wagon, which is the perfect place to put the join

Second print observations:
 - Forgot the cosmetic coupling hook, should be easy to make a slot for a black PETG part to slot in
 - Still some warping at the line between the base of the wagon and the walls - although not as bad when printing the 'right' way up.
 	 Not sure it's better enough to be worth splitting the wagon in two - maybe some adaptation to the model to counter the warping would be better?
	  after looking properly in the light I think it's fine
 - Need to make base a bit thicker and have more height between top of the screwholes and inside base of the wagon
If printing the top, ensure the bridging of the overhang is in the right orientation - lengthwise with the wagon

therefore, TODO:
 - thicken base to fit screws better - done (now 7mm)
 - Ladder? complicated: holes for bent wire. Easy: ledges small enough to print - done easy version
 - I think my wagon is a tiny bit too short - compared to my (potentially squished) printout and when looking at the photos. the 'little door' isn't in quite the right place and there's not enough space below the nameplate. Might be more obvious if I try the ladder - done
 - base bit (exactl where cut into two sections) is ever so slightly more narrow - done

 - few more details: there're some levers on teh side that I think I could pritn successfully using the min_thick style embossing like the logo
 - cosmetic coupling hook, or at least a space for one
 - bolts that hold the nameplate on?



 Third print observations:
  - Warped in the corners a bit - not sure if this was because the bed wasn't as clean as it could be, or because I'd made the base thicker.
  - line near top of base is more obvious, but not sure if this is the same as the corner warp problem or not

might try and make the base more thin again - maybe go for glue rather than screws?

TODO:
 - reduce base thickness below 6mm and add glue holes (shallow rectangular trenches I think will do) so the base can be attached to teh top with 4 screws (in buffer raised area) and some hot glue
 - clean base very thoroughly before printing top
 - give more clearance around coupling holder, and see if bogies print with scaffolding
 - make holder for brake wheel a bit more thick
 - dapol coupling holder is actually further from the edge than intended, although appears to work okay.
*/
include <truck_bits.scad>
include <constants.scad>
include <wheel.scad>
include <threads.scad>
include <intermodal_wagon_accessories.scad>
include <buffer_modern.scad>
include <couplings_parametric.scad>
include <gravel_pile.scad>

wheel_diameter = 12.5;

GEN_IN_SITU = true;
//deprecated, now wagon is split into base and top (still used to generate the model)
GEN_WAGON = true;
GEN_BASE = false;
GEN_TOP = false;
GEN_BOGIE = true;
GEN_BRAKE_WHEEL = false;
GEN_BRAKE_CYLINDER = false;
GEN_BUFFER = false;
//bits that aren't printed, just part of the 3d model
GEN_MODEL_BITS = false;
GEN_GRAVEL = false;

//"dapol", "hornby", "NEM"
COUPLING_TYPE="dapol";
//some optional tweaks to make the bogie less accurate, but hopefully printable in PLA
BOGIE_EASY_PRINT = true;

//MWA, MWA-B, IOA
STYLE = "MWA";
//MWA-B has no ladder, square nameplate, no small cylinder and brake-wheels on one bogie only - not on the main wagon body
//IOA has no nameplate and taller 'ridge bits' around the top, also the brake cylinders are same colour as the body
//and differently shaped triangular bits on the underside

blurbs = [str("github.com/MrBunsy/3DPrintedTrains"), str(STYLE, " Wagon")];

//MWA and IOA
HAS_LADDER = STYLE != "MWA-B";
HAS_NAMEPLATE = STYLE !="IOA";
HAS_LITTLE_DOOR = STYLE !="IOA";
//on IOA they're part of the many wagon as tehy're the same colour
HAS_SEPARATE_BRAKE_CYLINDERS = STYLE != "IOA";

//copying intermodal wagon
//buffer_area_thick = 3.5; - buffer_ledge_height is used instead

bogie_distance = m2mm(8.52);
//bogie axles appear to be 2metres apart
bogie_axle_distance = m2mm(2);

bogie_inner_width = 22.5;

//as measured from picture
axle_to_top_of_bogie = 6.3;// 5.8;

//total length includes buffers
total_length = m2mm(13.97);
//these are mostly dervived from a picture I un-perspectvied and printed out at the right size

//height of the base of the wagon above rails.
//this is not measured, this is tweaked so the buffers, at centre_of_buffer_from_top_of_rail, look like they're in the right place
//the total height may therefore be 'wrong' but they'll match other OO gauge wagons
wagon_base_above_rails = 14.5;

//length of the base,not including buffers
wagon_length = m2mm(13.97-0.62*2);//168.5;//170.1;
wagon_end_flange_length = (170.1-wagon_length)/2;
//complete guess if I'm honest, same as the container wagons
wagon_width = 30;
wagon_base_width = 29.75;
//starting from 'base' which is the flat bit above the bogies
//wagon_height = 28.5; - possibly correct if my photo really is squashed. my photo measures 30. going with 29.25 as a bit of a compromise - not sure it's perfect
wagon_height = 30;//29.25;//28.5;//30;

bogie_centre_from_edge =  wagon_length/2-bogie_distance/2;
coupling_from_bogie_centre = bogie_centre_from_edge - coupling_from_edge;
bogie_coupling_height = axle_to_top_of_bogie + wheel_diameter/2 - top_of_coupling_from_top_of_rail;

ladder_rungs = STYLE == "MWA" ? 8 : 7;
ladder_start_from_top = STYLE == "MWA" ? 4.2 : 6.6;
ladder_gap_height = 24.1/7;
ladder_length = 7;
ladder_centre_y = -(wagon_length/2 - 3 - ladder_length/2);


side_ridge_length = 2.2;
side_ridge_length2 = 3.1;
side_ridge_thicker_length = 3;
top_ridge_height = STYLE == "IOA" ? 4 : 2.8;
top_ridge_height2 = STYLE == "IOA" ? 1.5 : 0;
top_ridge_thick = 1.4;
//just height of flange beyond top_ridge_height
top_ridge_flange_height=5.5-2.8;
side_ridge_thick=side_ridge_length*0.5;
top_ridge_thick2 = (top_ridge_thick+side_ridge_thick)/2;

little_door_height = 13;
little_door_length = 10.5;
little_door_thick=0.5;
little_door_ridge_thick=0.5;
little_door_z = 10.5;//wagon_height - 10.5 - little_door_height;
little_door_hinge_length = 2;
little_door_hinge_height = 1.6;
little_door_hinge_thick = little_door_ridge_thick*2;

plaque_length = 4.9;
plaque_height = 4.1;
plaque_z = wagon_height - 7.3;
plaque_from_end = 30.1+2;//+2.75;

//the thin bits, giong to assume the others are same as sides
//too much thinner and it won't be sliced for printing
end_ridge_thick = 0.6;
end_flange_taper_height = 0.8;

side_ridge_from_end=13.5;
buffer_ledge_length = 7.4;
buffer_ledge_taper_length = side_ridge_from_end-buffer_ledge_length-side_ridge_length/2;
//height 'above' the base
buffer_ledge_height = 1.5;//2;

//how much higher or lower than the main base the buffers should be
//TODO once I've got an idea of the height of bogies then this should be adjusted to meet top_of_buffer_from_top_of_rail
buffer_z_from_base = wagon_base_above_rails - centre_of_buffer_from_top_of_rail;//-0.75;

//buffer_z_from_base negative because wagon is constructed upside down
bogie_mount_height = centre_of_buffer_from_top_of_rail  -wheel_diameter/2 - axle_to_top_of_bogie  - m3_washer_thick --buffer_z_from_base;

end_ridge_x = 1.5*wagon_width/7;

//of the PNG
//logo_dimensions = [1235,240, 5];
//logo_file = "freightliner-logo.png";
// logo_dimensions = [515,100, 5];
// logo_file = "freightliner-logo-small.png";
side_ridge_height = wagon_height-3;
side_ridge_height2 = wagon_height-0.9;

//can't auto detect size of svg
logo_dimensions = STYLE == "MWA" ? [39.73169, 8.64314] : [135, 100];
logo_file = STYLE == "MWA" ? "Freightliner_logo.svg" : "mwa-b-logo-chunky.svg";

nameplate_length = STYLE == "MWA" ? 44.2 : 24.5;
nameplate_height = STYLE == "MWA" ? 10.8 : side_ridge_height - top_ridge_height;
nameplate_z = STYLE == "MWA" ? 7 : top_ridge_height;



end_bottom_ledge_z = side_ridge_height-end_flange_taper_height;//wagon_height -3;//27;
//guessing a bit here
end_mid_ledge_z = STYLE != "IOA" ? (end_bottom_ledge_z * 0.6) : (end_bottom_ledge_z * 0.7);
ledge_thick = 0.4;



wall_thick = 1;
base_thick = 6;

min_thick = 0.2;
//y coord of tallest edge
wagon_under_triangle_from_end = 56;//56.6;
wagon_under_triangle_height = STYLE != "MWA-B" ? 4.6 : 4;
wagon_under_triangle_flat_length = STYLE!= "MWA-B" ? 1.3 : 3;
//overhang bit, more of a rombus at this point
wagon_under_triangle_flat_extra_length = STYLE != "MWA-B" ? 0 : 1;
//not inculing the extra_length overhang
wagon_under_triangle_total_length = STYLE != "MWA-B" ? 5.7 : 4.5;
//guesses:
wagon_under_triangle_from_side = 1;
wagon_under_triangle_width = 3;

wagon_big_cylinder_squashed_r = 1.3;
wagon_little_cylinder_squashed_r1 = 1.5;
wagon_little_cylinder_r2 = 2;

brake_wheel_d = 7;
brake_wheel_space_d = 7+0.9*2;

//big cylinder, -ve x, +ve y
big_cylinder = [[-(wagon_width/2-3),wagon_length/2-78.3],5.5/2,17.6, true];

little_cylinder = [[(wagon_width/2-3),-(wagon_length/2-73.5)],5.5/2,7, false];

//[ [x,y of centre], radius, length, bigstyle]
wagon_cylinders= STYLE == "MWA-B" ? [ big_cylinder ] : [ big_cylinder, little_cylinder ];


//intermodal wagon was 2 thick, but they seem a bit loose
//2.5 really struggles to get the wheels in place
brake_wheel_holder_thick = 2;//.5;
brake_wheel_holder_length = buffer_holder_d+2;
brake_wheel_holder_height_above_wheel = buffer_holder_d/2+1;
//[x,y,z] 
big_cylinder_brake_wheel_pos = [-(wagon_width/2-1), wagon_length/2-66 , wagon_height + brake_wheel_d/2];
little_cylinder_brake_wheel_pos = [(wagon_width/2-1), wagon_length/2-66 , wagon_height + brake_wheel_d/2 + 1];

//facing +ve x
module side_ridge(length){
	color("green")translate([wagon_width/2+side_ridge_thick/2,0,0])hull(){
			centred_cube(side_ridge_thick,length,side_ridge_height);
			translate([-side_ridge_thick/2-0.1/2 -(wagon_width/2 - wagon_base_width/2),0,0])centred_cube(0.1,length,side_ridge_height2);
		}
}

//length is up to the base of the buffer, which is further out than parts of the end
module wagon_end_indents(){
	//indent_height = wagon_height - end_bottom_ledge_z;
	mirror_x()translate([0,wagon_length/2+wagon_end_flange_length,top_ridge_height])centred_cube(wagon_width-end_ridge_thick*2,side_ridge_thick*2,end_bottom_ledge_z-top_ridge_height);
}

//facing +ve x up against the side of the wagon
module little_door(){
	translate([little_door_thick/2,0,0])union(){
		difference(){
			centred_cube(little_door_thick,little_door_length,little_door_height);
		//take out the inset
			translate([little_door_thick/2,0,little_door_ridge_thick])centred_cube(min_thick*2,little_door_length-little_door_ridge_thick*2,little_door_height-little_door_ridge_thick*2);
		}
		
		//add centre armridge thing
		translate([0,0,little_door_height/2-little_door_ridge_thick/2])centred_cube(little_door_thick,little_door_length,little_door_ridge_thick);
		
		translate([0,-little_door_length*0.1,little_door_height/2])centred_cube(little_door_thick,little_door_ridge_thick,little_door_height*0.275);
		
		hinge_pos = 0.2;
		
		//hinges
		translate([0,little_door_length/2,little_door_height*hinge_pos-little_door_hinge_height/2])centred_cube(little_door_hinge_thick,little_door_hinge_length,little_door_hinge_height);
		
		translate([0,little_door_length/2,little_door_height*(1-hinge_pos)-little_door_hinge_height/2])centred_cube(little_door_hinge_thick,little_door_hinge_length,little_door_hinge_height);
	}
		
}

//facing +ve x, centred at centre of the rung in y and edge of the wagon in z
module ladder_rung(){
	color("white")translate([min_thick*1.5/2,0,0])centred_cube(min_thick*1.5,ladder_length,min_thick*2);
}

// main body of the wagon
//upside down, so 0,0,0 is centre of top of wagon (the open bit)
//note - although it can be printed like this, it warped, so it's split into two (base and top). only the base is still printed upside down, but everything here assumes it's upside down
module wagon_body(logo=false){
	//up to side_ridge_height is full width, 'below' (when real way up) that is slightly narrower
	difference(){
		union(){
			centred_cube(wagon_width, wagon_length, side_ridge_height);
			translate([0,0,side_ridge_height])centred_cube(wagon_base_width, wagon_length, wagon_height - side_ridge_height);
		}
		union(){
			translate([0,0,-0.01])centred_cube(wagon_width-wall_thick*2, wagon_length-wall_thick*2, wagon_height-base_thick);
			wagon_end_indents();
		}
	}
	
	//ladder
	if(HAS_LADDER){
		mirror_rotate180(){
			for(rung = [0:ladder_rungs-1]){
				translate([wagon_width/2,ladder_centre_y, ladder_start_from_top + rung*ladder_gap_height])ladder_rung();
			}
		}
	}

	//top side ridge
	color("green")mirror_y()translate([wagon_width/2+top_ridge_thick/2,0,0])centred_cube(top_ridge_thick,wagon_length+wagon_end_flange_length*2,top_ridge_height);
	color("green")mirror_y()translate([wagon_width/2+top_ridge_thick2/2,0,0])centred_cube(top_ridge_thick2,wagon_length+wagon_end_flange_length*2,top_ridge_height+top_ridge_height2);
	//top end ridge
	mirror_x()translate([0,wagon_length/2+wagon_end_flange_length/2,0])centred_cube(wagon_width,wagon_end_flange_length,top_ridge_height);
	mirror_x()translate([0,wagon_length/2+wagon_end_flange_length/2 - (top_ridge_thick - top_ridge_thick2),0])centred_cube(wagon_width,wagon_end_flange_length- (top_ridge_thick - top_ridge_thick2),top_ridge_height+top_ridge_height2);
	
	//side ridges
	//9 central ones of same thickness and distance
	//then two outer ones of thickerness but same distance
	//finfall two outmost ones same thickness as central ones, but further out
	//the 9 central ones
	//inner_ridges_distance = 90;
	//the 11 inner ridges line up with the bogies, which we do have exact positions for
	inner_ridges_distance = bogie_distance;
	inner_ridge_d = inner_ridges_distance/10;
	//inner ridges
	mirror_y()for(i=[1:9]){
		translate([0,-inner_ridges_distance/2 + inner_ridge_d*i,0])side_ridge(side_ridge_length);
	}
	//next ridges, same distance, more thick
	mirror_xy(){
		translate([0,-inner_ridges_distance/2,0])side_ridge(side_ridge_length2);
	}
	//last side ridges, different distance
	
	mirror_xy(){
		translate([0,wagon_length/2 - side_ridge_from_end,0])side_ridge(side_ridge_length);
	}
	nameplate_thick = side_ridge_thick+min_thick+wall_thick;
	if(HAS_NAMEPLATE){
		//name plate
		color("yellow")mirror_y()translate([wagon_width/2-wall_thick+nameplate_thick/2,0,nameplate_z])centred_cube(nameplate_thick,nameplate_length,nameplate_height);
		nameplate_margin = 0;
		if(logo){
			//mirror_y()translate([wagon_width/2-wall_thick+nameplate_thick-0.1,0,nameplate_z+nameplate_height/2])rotate([-90,0,0])rotate([0,90,0])scale([(nameplate_length-nameplate_margin*2)/logo_dimensions[0], (nameplate_height-nameplate_margin*2)/logo_dimensions[1] ,min_thick/logo_dimensions[2]])translate([-logo_dimensions[0]/2,-logo_dimensions[1]/2, logo_dimensions[2]])surface(logo_file, invert = true);
			scaleby = (nameplate_length-nameplate_margin*2)/logo_dimensions[0];
			mirror_rotate180()translate([wagon_width/2-wall_thick+nameplate_thick,0,nameplate_z+nameplate_height/2])rotate([-90,0,0])rotate([0,90,0])scale([scaleby,scaleby , 1])linear_extrude(height=min_thick)import(logo_file, center=true);
		}
	}
	
	//end flanges (top of wagon)
	color("blue")mirror_xy()hull(){
		
		translate([wagon_width/2+top_ridge_thick/2,wagon_length/2-end_ridge_thick/2+wagon_end_flange_length,0]){
			centred_cube(top_ridge_thick,end_ridge_thick,top_ridge_height + top_ridge_height2);
			translate([-top_ridge_thick/2-0.1/2,0,0])centred_cube(0.1,end_ridge_thick,top_ridge_flange_height + top_ridge_height + top_ridge_height2);
			
		}
	}
	
	//the ends
	//flanges on the sides
	mirror_xy(){
		translate([wagon_width/2-end_ridge_thick/2,wagon_length/2+wagon_end_flange_length/2,0])hull(){
			centred_cube(end_ridge_thick,wagon_end_flange_length,end_bottom_ledge_z);
			translate([0,-wagon_end_flange_length/2-0.1/2,end_bottom_ledge_z])centred_cube(end_ridge_thick,0.1,end_flange_taper_height );
		}
	}
	

	end_ridge_length = wall_thick + side_ridge_thick;
	//two end vertical ridges
	mirror_xy()translate([end_ridge_x,wagon_length/2-wall_thick+end_ridge_length/2,0])centred_cube(side_ridge_length,end_ridge_length,end_bottom_ledge_z);
	//triangular supports under the ledge, in line with the ridges
	triangle_thick = min_thick*3;
	mirror_xy(){
		translate([end_ridge_x,wagon_length/2-wall_thick,0])mirror_y(){
			hull(){
				translate([side_ridge_length/2-triangle_thick/2,end_ridge_length/2,end_bottom_ledge_z-0.1])centred_cube(triangle_thick,end_ridge_length,0.1);
				translate([side_ridge_length/2-triangle_thick/2, wall_thick, end_bottom_ledge_z])centred_cube(triangle_thick,0.1,end_flange_taper_height);
			}
		}
	}
	
	//mid end ledge
	ledge_length = side_ridge_thick-min_thick*2;
	mirror_x()translate([0,wagon_length/2,end_mid_ledge_z])centred_cube(wagon_width,ledge_length,ledge_thick);
	//mid end vertical ledge
	//thicker so it will be sliced and printed
	mirror_x()translate([0,wagon_length/2,0])centred_cube(end_ridge_thick,ledge_length,end_mid_ledge_z);
	
	notch_width = end_ridge_x*2 -side_ridge_length - min_thick*2;
	notch_length = wagon_end_flange_length - min_thick*2;
	//bottom end ledge
	color("green")mirror_x(){
		difference(){
			translate([0,wagon_length/2,end_bottom_ledge_z-ledge_thick])centred_cube(wagon_width,side_ridge_thick+min_thick*2,ledge_thick);
			
			
			
			translate([0,wagon_length/2+wagon_end_flange_length-notch_length/2,end_bottom_ledge_z-ledge_thick*2])centred_cube(notch_width,notch_length,ledge_thick*4);
		}
	}
	
	//extra ledge for the buffers
	mirror_x() hull(){
		//deliberately still wagon_width wide
		translate([0,wagon_length/2-buffer_ledge_length/2,wagon_height])centred_cube(wagon_width,buffer_ledge_length,buffer_ledge_height);
		translate([0,wagon_length/2-(buffer_ledge_length + buffer_ledge_taper_length)/2,wagon_height-0.1])centred_cube(wagon_width,buffer_ledge_length + buffer_ledge_taper_length,0.1);
	}
	if(HAS_LITTLE_DOOR){
		//little door thing
		mirror_rotate180()translate([wagon_width/2,wagon_length/2 - side_ridge_from_end+ side_ridge_length/2 + little_door_length/2, little_door_z])little_door();
	}
	
	//little plaque
	color("gray")mirror_rotate180()translate([wagon_width/2+min_thick/2,wagon_length/2-plaque_from_end,plaque_z])centred_cube(min_thick,plaque_length,plaque_height);
		
	
	//bogie mounts
	mirror_x()translate([0,bogie_distance/2,wagon_height])cylinder(h=bogie_mount_height,r=m3_thread_d);

	//triangular bits underneath, part of the real bogie suspension I think
	mirror_xy()hull(){
		//main cube
		translate([wagon_width/2 - wagon_under_triangle_from_side-wagon_under_triangle_width/2,wagon_length/2-wagon_under_triangle_from_end+wagon_under_triangle_flat_length/2,wagon_height-0.1])centred_cube(wagon_under_triangle_width,wagon_under_triangle_flat_length,wagon_under_triangle_height+0.1);

		//bit off to the bogie side to make the triangle
		translate([wagon_width/2 - wagon_under_triangle_from_side-wagon_under_triangle_width/2,wagon_length/2-wagon_under_triangle_from_end+wagon_under_triangle_flat_length+wagon_under_triangle_total_length,wagon_height-0.1])centred_cube(wagon_under_triangle_width,0.1,0.1);

		//potential extra bit for overhang
		if(wagon_under_triangle_flat_extra_length > 0){
			translate([
				wagon_width/2 - wagon_under_triangle_from_side-wagon_under_triangle_width/2,
				wagon_length/2-wagon_under_triangle_from_end-wagon_under_triangle_flat_extra_length,
				wagon_height + wagon_under_triangle_height-0.05
				])centred_cube(wagon_under_triangle_width, 0.1, 0.1);
		}

	}

	//mounts for the brake wheels
	if(STYLE!="MWA-B"){
		big_height = big_cylinder_brake_wheel_pos[2]-wagon_height + brake_wheel_holder_height_above_wheel;
		translate([big_cylinder_brake_wheel_pos[0]+brake_wheel_holder_thick/2, big_cylinder_brake_wheel_pos[1],wagon_height])centred_cube(brake_wheel_holder_thick,brake_wheel_holder_length, big_height);
		little_height = little_cylinder_brake_wheel_pos[2]-wagon_height + brake_wheel_holder_height_above_wheel;
		translate([little_cylinder_brake_wheel_pos[0]-brake_wheel_holder_thick/2, little_cylinder_brake_wheel_pos[1],wagon_height])centred_cube(brake_wheel_holder_thick,brake_wheel_holder_length, little_height);
	}
	
}


//if punchout is true this is for subtracting from the wagon body
//if false this is a shape to be printed into the holes subtracted by the punchout
//cylinder has its little leggies facing -ve z and 0,0 is this side ('top' of the cylinder as finished)
//I forgot that bot cylinders are different styles, so this abstraction is a bit of a waste, but makes punching holes in the base easier
module brake_cylinder(cylinder_def, punchout = false){

	leg_length = punchout ? 4.4 : 3.5;
	leg_r = punchout ? buffer_holder_d/2 : buffer_d/2;

	pos = cylinder_def[0];
	r = cylinder_def[1];
	length = cylinder_def[2];
	bigStyle = cylinder_def[3];
	//the little one is a different style, but not sure I'll bother to reproduce it, it'll be hard to give it two pegs
	if(bigStyle){
		//translate([0,0,+r])rotate([90,0,0])cylinder(r=r,h=length,center=true);
		hull(){
			mirror_x()translate([0,length/2-wagon_big_cylinder_squashed_r,r])scale([1,wagon_big_cylinder_squashed_r/r,1])sphere(r=r,$fn=40);
		}
	}else{
		hull(){
			//one end same as big cylinder, squashed sphere
			translate([0,-(length/2-wagon_little_cylinder_squashed_r1),r])scale([1,wagon_little_cylinder_squashed_r1/r,1])sphere(r=r,$fn=40);
			translate([0,(length/2-wagon_little_cylinder_r2),r])rotate([90,0,0])cylinder(r=r,h=0.1,$fn=20);
		}
			//other end just a sphere
			translate([0,(length/2-wagon_little_cylinder_r2),r])sphere(r=wagon_little_cylinder_r2,$fn=40);
		
	}

	
	mirror_x()translate([0,length*0.2,-leg_length])cylinder(r=leg_r,h=leg_length+r);
}

module wagon(logo=false){
	difference(){
		union(){
			wagon_body(logo);
			if(!HAS_SEPARATE_BRAKE_CYLINDERS){
				for(cylinder_def = wagon_cylinders){
					pos = cylinder_def[0];
					r = cylinder_def[1];
					length = cylinder_def[2];
					translate([pos[0],pos[1],wagon_height]){
						brake_cylinder(cylinder_def);
						centred_cube(r*0.8,length-r*0.75,2);
					}
				}
			}
			text_size = 4.5;
			color("grey")translate([0,0,wagon_height]){
				translate([-text_size*0.75,0,0])rotate([0,0,90])linear_extrude(height = 0.2) text(text=blurbs[0],size=text_size,valign="center",halign="center",font = "Liberation Sans:style=Bold");
				translate([text_size*0.75,0,0])rotate([0,0,90])linear_extrude(height = 0.2) text(text=blurbs[1],size=text_size,valign="center",halign="center",font = "Liberation Sans:style=Bold");
			};
		}
		
		//things to remove
		union(){
			//holes for buffers
            mirror_xy(){
				translate([-buffer_distance/2,wagon_length/2,wagon_height+buffer_z_from_base]){
					rotate([90,0,0]){
					//holes to hold buffers
					cylinder(h=buffer_holder_length*2, r=buffer_holder_d/2, $fn=200, center=true);
					}
				}
				//space to access holes if (when) the buffer snaps off and gets stuck
				//dimensions from intermodal wagon: [6, 3.8, 3.5], centred at 4.56 from end
				translate([-buffer_distance/2, wagon_length/2 - 4.56, wagon_height+ buffer_ledge_height - 3.5])centred_cube(5,3.8,3.5+1);
			}
			
			//holes for bogie screws
			mirror_x()translate([0,bogie_distance/2,wagon_height-base_thick+min_thick*4])cylinder(h=bogie_mount_height+100,r=m3_thread_d/2);

			if(HAS_SEPARATE_BRAKE_CYLINDERS){
				//holes for the cylinders to be inserted
				for(cylinder_def = wagon_cylinders){
					pos = cylinder_def[0];
					r = cylinder_def[1];
					length = cylinder_def[2];
					translate([pos[0],pos[1],wagon_height])brake_cylinder(cylinder_def,true);
				}
			}

			if(STYLE!="MWA-B"){
				//holes for the brake wheels to be inserted
				for(hole = [big_cylinder_brake_wheel_pos, little_cylinder_brake_wheel_pos]){
					translate(hole)rotate([0,90,0])cylinder(r=buffer_holder_d/2,h= 10, center=true);
				}
				//extra padding around the big cylinder brake wheel
				intersection(){
					translate(big_cylinder_brake_wheel_pos)rotate([0,-90,0])cylinder(r=brake_wheel_space_d/2,h=10);
					//but not so wide as to clip the brake cylinder if !HAS_SEPARATE_BRAKE_CYLINDERS
					translate(big_cylinder_brake_wheel_pos)translate([0,0,-5])centred_cube(10,5,20);
				}
			}
		}
	}
	
}

//bogie design measurements.

//cosmetic bits:
//base and top here refer when the bogie is the real way up, z is when being constructed (upside down)
bogie_flange_width = 2.5;
bogie_inner_flange_width = 2+ (BOGIE_EASY_PRINT ? 0.2 : 0);;
bogie_centre_bottom_length = 4;
bogie_centre_top_length = 7;
bogie_centre_gap_length = bogie_centre_top_length - bogie_centre_bottom_length;
bogie_flange_thick = 0.4;
bogie_centre_top_z = 0.7;
bogie_centre_bottom_z = axle_to_top_of_bogie;//6.3;
bogie_top_flat_from_centre = 10.7;
bogie_top_cylinder_r = 4.3/2;//bogie_flange_width;
bogie_top_cylinder_h = 2.1;

//bit on the axle box
bogie_bottom_cylinder_h=0.8;

bogie_spring_d = bogie_top_cylinder_r*1.75;

bogie_backing_plate_thick=1 + (BOGIE_EASY_PRINT ? 0.5 : 0);


//[y,z] for centre of flange thickness
bogie_top_centre = [bogie_centre_top_length/2,bogie_centre_top_z+bogie_flange_thick/2];
bogie_top_inner_wheel = [bogie_top_flat_from_centre,bogie_flange_thick/2];
bogie_top_wheel = [bogie_axle_distance/2,bogie_flange_thick/2];
bogie_top_outer_wheel = [16.3,bogie_flange_thick/2];

bogie_bottom_centre = [bogie_centre_bottom_length/2,bogie_centre_bottom_z-bogie_flange_thick/2];
bogie_bottom_inner_wheel = [bogie_axle_distance/2,bogie_top_cylinder_h-bogie_flange_thick/2];

bogie_bottom_outer_wheel = [16.3,bogie_top_cylinder_h-bogie_flange_thick/2];

bogie_arm_height = bogie_centre_bottom_z;//7.6;//is deeper but not sure I can be bothered to work out the taper and stuff

bogie_small_cylinder_d1=1.6;
bogie_small_cylinder_d=1.3;
bogie_small_cylinder_h=6;
bogie_small_cylinder_h1=4.5;
bogie_small_cylinder_pos=[16,1];

//positions [y,z]
bogie_centre_hole_d = 2;
bogie_centre_hole_pos = [0,3.5];
bogie_offset_hole_d = 1.6;
bogie_offset_hole_pos = [6.3,2.5];
bogie_end_hole_d = 1;
bogie_end_hole_pos = [9.1, 1.6];

bogie_bolt_d = 0.6;
bogie_bolt_width = bogie_backing_plate_thick+0.25;//1.25;
bolt_offset1y = (bogie_top_centre[0] + bogie_bottom_centre[0])/2;
bolt_offset1z_mid = (bogie_centre_bottom_z + bogie_centre_top_z)/2;
bolt_offset1z = 1.3;
bolt_offset2z = 1.4;
//[y,z]
bogie_bolt_positions = [
	[bolt_offset1y,bolt_offset1z_mid - bolt_offset1z],
	[bolt_offset1y,bolt_offset1z_mid],
	[bolt_offset1y,bolt_offset1z_mid + bolt_offset1z],

	[0, bolt_offset1z_mid + bolt_offset2z],
	[0, bolt_offset1z_mid - bolt_offset2z]
];

//behind the cosmetic bits I've got a plate to add some strength
bogie_padding_width = 1;

//part of the suspension
bogie_axle_pivot_pos = [5.2,4.9];
bogie_axle_pivot_d = 2.2;
bogie_axle_pivot_width = 1.5;
bogie_axle_pivot_hinge_width = 1.5 + (BOGIE_EASY_PRINT ? 0.4 : 0);
bogie_axle_holder_size = 4.5;

//used for the backing of the bogie flanges and for intersections
module bogie_hull_shape(width=bogie_backing_plate_thick){
	//backing plate
		
		hull(){
			//centre
			translate([width/2,0,bogie_top_centre[1]-bogie_flange_thick/2])centred_cube(width,bogie_flange_thick,bogie_flange_thick);
			
			translate([width/2,0,bogie_bottom_centre[1]-bogie_flange_thick/2])centred_cube(width,bogie_flange_thick,bogie_flange_thick);
			
			//first bend
			translate([width/2,bogie_top_centre[0]-bogie_flange_thick/2,bogie_top_centre[1]-bogie_flange_thick/2])centred_cube(width,bogie_flange_thick,bogie_flange_thick);
			
			translate([width/2,bogie_bottom_centre[0]-bogie_flange_thick/2,bogie_bottom_centre[1]-bogie_flange_thick/2])centred_cube(width,bogie_flange_thick,bogie_flange_thick);
		}
		
		hull(){
			
			//first bend
			translate([width/2,bogie_top_centre[0]-bogie_flange_thick/2,bogie_top_centre[1]-bogie_flange_thick/2])centred_cube(width,bogie_flange_thick,bogie_flange_thick);
			
			translate([width/2,bogie_bottom_centre[0]-bogie_flange_thick/2,bogie_bottom_centre[1]-bogie_flange_thick/2])centred_cube(width,bogie_flange_thick,bogie_flange_thick);
			
			//'inner wheel'
			translate([width/2,bogie_top_inner_wheel[0]-bogie_flange_thick/2,bogie_top_inner_wheel[1]-bogie_flange_thick/2])centred_cube(width,bogie_flange_thick,bogie_flange_thick);
			
			translate([width/2,bogie_bottom_inner_wheel[0]-bogie_flange_thick/2,bogie_bottom_inner_wheel[1]-bogie_flange_thick/2])centred_cube(width,bogie_flange_thick,bogie_flange_thick);
			
		}
		
		
		//above the wheel
		hull(){
			//'inner wheel'
			translate([width/2,bogie_top_inner_wheel[0],bogie_top_inner_wheel[1]-bogie_flange_thick/2])centred_cube(width,bogie_flange_thick,bogie_flange_thick);
			
			translate([width/2,bogie_bottom_inner_wheel[0],bogie_bottom_inner_wheel[1]-bogie_flange_thick/2])centred_cube(width,bogie_flange_thick,bogie_flange_thick);

			//'outer wheel'
			translate([width/2,bogie_top_outer_wheel[0]-bogie_flange_thick/2,bogie_top_outer_wheel[1]-bogie_flange_thick/2])centred_cube(width,bogie_flange_thick,bogie_flange_thick);
			
			translate([width/2,bogie_bottom_outer_wheel[0]-bogie_flange_thick/2,bogie_bottom_outer_wheel[1]-bogie_flange_thick/2])centred_cube(width,bogie_flange_thick,bogie_flange_thick);
		}
}

//[y,z]
bogie_brake_wheel_pos = [-4.2,3.1];

//facing +ve x
module bogie_edge(){
	
	mirror_x()
		difference(){
			union(){
				//top ledge of the edge of the bogie:
				translate([0,0,bogie_top_centre[1]-bogie_flange_thick/2])cube([bogie_flange_width,bogie_top_centre[0],bogie_flange_thick]);
				hull(){
					translate([0,bogie_top_centre[0]-bogie_flange_thick,bogie_top_centre[1]-bogie_flange_thick/2])cube([bogie_flange_width,bogie_flange_thick,bogie_flange_thick]);
					translate([0,bogie_top_inner_wheel[0]-bogie_flange_thick,0])cube([bogie_flange_width,bogie_flange_thick,bogie_flange_thick]);
				}
				translate([0,bogie_top_inner_wheel[0],0])cube([bogie_flange_width,bogie_axle_distance/2-bogie_top_inner_wheel[0],bogie_flange_thick]);


				//half a cylinder
				intersection(){
					//the cylinder
					translate([bogie_flange_width-bogie_top_cylinder_r,bogie_axle_distance/2,0])cylinder(r=bogie_top_cylinder_r,h=bogie_top_cylinder_h*2);
					//keep within confines of bogie
					bogie_hull_shape(bogie_flange_width);
			
				}
				
				//bottom ledge
				translate([0,0,bogie_bottom_centre[1]-bogie_flange_thick/2])cube([bogie_flange_width,bogie_bottom_centre[0],bogie_flange_thick]);
				
				hull(){
					translate([0,bogie_bottom_centre[0]-bogie_flange_thick,bogie_bottom_centre[1]-bogie_flange_thick/2])cube([bogie_flange_width,bogie_flange_thick,bogie_flange_thick]);
					translate([0,bogie_bottom_inner_wheel[0]-bogie_flange_thick,bogie_bottom_inner_wheel[1]-bogie_flange_thick/2])cube([bogie_flange_width,bogie_flange_thick,bogie_flange_thick]);
				}
				
				hull(){
					translate([0,bogie_bottom_inner_wheel[0]-bogie_flange_thick,bogie_bottom_inner_wheel[1]-bogie_flange_thick/2])cube([bogie_flange_width,bogie_flange_thick,bogie_flange_thick]);
					
					translate([0,bogie_bottom_outer_wheel[0]-bogie_flange_thick,bogie_bottom_outer_wheel[1]-bogie_flange_thick/2])cube([bogie_flange_width,bogie_flange_thick,bogie_flange_thick]);
				}
				
				//back of flange bit
				bogie_hull_shape();
				
				//some detailing
				intersection(){
					color("green")union(){
						//vertical flanges, which need to be thick enough to slice
						translate([bogie_inner_flange_width/2,bogie_bottom_centre[0],0])centred_cube(bogie_inner_flange_width,bogie_flange_thick*1.5,bogie_bottom_centre[1]);
						
						translate([bogie_inner_flange_width/2,bogie_top_centre[0],0])centred_cube(bogie_inner_flange_width,bogie_flange_thick*1.5,bogie_bottom_centre[1]);
						
					}
					bogie_hull_shape(bogie_flange_width);
				}

				//bolts? circular sticky out bits
				for(bolt = bogie_bolt_positions){
					color("blue")translate([0,bolt[0],bolt[1]])rotate([0,90,0])cylinder(r=bogie_bolt_d/2,h=bogie_bolt_width,$fn=20);

				}

				pivot_bit_height = 2.2;
				//axle hinge point
				translate([0,bogie_axle_pivot_pos[0],bogie_axle_pivot_pos[1]])rotate([0,90,0])cylinder(r=bogie_axle_pivot_d/2,h=bogie_axle_pivot_hinge_width);
				//link from hinge to axle
				hinge_point_d = 1.3;
				hull(){
					translate([0,bogie_axle_pivot_pos[0],bogie_axle_pivot_pos[1]])rotate([0,90,0])cylinder(r=hinge_point_d/2,h=bogie_axle_pivot_width);
					//ensure bottom (as printed) is level so it prints easily
					translate([bogie_axle_pivot_width/2,bogie_axle_distance/2,bogie_axle_pivot_pos[1]-hinge_point_d/2])centred_cube(bogie_axle_pivot_width,0.1,pivot_bit_height);
				}

				//spring done elsewhere to avoid mirroring it
				
				//other suspension cylinder thingie
				translate([bogie_small_cylinder_d1/2,bogie_small_cylinder_pos[0],bogie_small_cylinder_pos[1]])cylinder(r=bogie_small_cylinder_d/2,h=bogie_small_cylinder_h);
				translate([bogie_small_cylinder_d1/2,bogie_small_cylinder_pos[0],bogie_small_cylinder_pos[1]])cylinder(r=bogie_small_cylinder_d1/2,h=bogie_small_cylinder_h1);
				//bit at 'top' of suspension thingie
				size=bogie_small_cylinder_d1*1.2;
				translate([bogie_flange_width/2,bogie_bottom_outer_wheel[0]-size/2,bogie_flange_thick])centred_cube(size,size,bogie_bottom_inner_wheel[1]-bogie_flange_thick);
				//bit at 'bottom' of suspension thingie
				topLength = bogie_small_cylinder_d1*1.25;
				topHeight = 1.2;
				translate([topLength/2,bogie_small_cylinder_pos[0]+bogie_small_cylinder_d/2-topLength/2,bogie_small_cylinder_pos[1]+bogie_small_cylinder_h])centred_cube(topLength,topLength,topHeight);
				
			}//end addititve union
			union(){
				//things to subtract
				cylinders = [[bogie_centre_hole_d/2,bogie_centre_hole_pos],
					[bogie_offset_hole_d/2,bogie_offset_hole_pos],
					//[bogie_end_hole_d/2,bogie_end_hole_pos], - not on the MWA 
					];
					//few holes
				for(c = cylinders){
					translate([0,c[1][0],c[1][1]])rotate([0,90,0])cylinder(center=true, r=c[0],h=100);
				}
			}
		}//end difference

	//non-mirrored bits

	//some other sticky out bits
	//circle
	color("blue")translate([0,4.4,3.1])rotate([0,90,0])cylinder(r=0.9/2,h=bogie_bolt_width,$fn=20);
	//elongated circle
	color("blue")hull(){
		translate([0,-4.4,3.1])rotate([0,90,0])cylinder(r=0.9/2,h=bogie_bolt_width,$fn=20);
		translate([0,-4.4-0.9,3.1])rotate([0,90,0])cylinder(r=0.9/2,h=bogie_bolt_width,$fn=20);
	}
	
}
//bit that represents the axle holder +ve xy quad, with 0,0 at the back inline the axle and the bogie_edge cosmetics
module bogie_axle_holder_cosmetics(){
	hubcap_d = 2.5;
	hubcap2_d = 2.9;
	hubcap_width = bogie_flange_width;
	hubcap2_width = hubcap_width*0.8;
	//"hubcap"
	rotate([0,90,0])cylinder(r=hubcap_d/2,h=hubcap_width);
	rotate([0,90,0])cylinder(r=hubcap2_d/2,h=hubcap2_width);
	bolt_d = 0.4+0.1;
	bolt_length = 0.2+0.05;
	bolt_pos_r = hubcap_d/2-bolt_d*0.75;
	
	
	axle_holder_width = hubcap_width*0.6;

	//bolts on hubcap
	for(i=[0:2]){
		angle = i*360/3;
		rotate([0,90,0])translate([cos(angle)*bolt_pos_r,sin(angle)*bolt_pos_r,hubcap_width])cylinder(r=bolt_d/2,h=bolt_length);
	}
	//square with notch in around axle
	difference(){
		translate([axle_holder_width/2,0,-bogie_axle_holder_size/2])centred_cube(axle_holder_width,bogie_axle_holder_size,bogie_axle_holder_size);
		union(){
			//notch on inner bottom
			translate([axle_holder_width/2,-bogie_axle_holder_size*0.35,bogie_axle_holder_size*0.35])rotate([45,0,0])centred_cube(axle_holder_width*2,bogie_axle_holder_size,bogie_axle_holder_size);
			//notch on outer top
			translate([axle_holder_width/2,bogie_axle_holder_size*0.65,-bogie_axle_holder_size*0.9])rotate([-30,0,0])centred_cube(axle_holder_width*2,bogie_axle_holder_size,bogie_axle_holder_size);		
		}
	}
	//translate([axle_holder_width/2,bogie_axle_holder_size*0.65,-bogie_axle_holder_size*0.9])rotate([-30,0,0])centred_cube(axle_holder_width*2,bogie_axle_holder_size,bogie_axle_holder_size);

	//the cylinder
	difference(){
		translate([bogie_flange_width-bogie_top_cylinder_r,0,-bogie_axle_holder_size/2])cylinder(r=bogie_top_cylinder_r,h=bogie_bottom_cylinder_h);
		translate([-bogie_top_cylinder_r*2,0,-50])centred_cube(bogie_top_cylinder_r*4,bogie_top_cylinder_r*4,100);
	}
	
	
	
}

bogie_centre_arm_height = 3.4;
coupling_arm_height = bogie_centre_arm_height*0.5;
//not the same as the height the coupling must be at!
coupling_arm_z =bogie_centre_arm_height - coupling_arm_height;

bogie_centre_arm_length = m3_thread_d*2;

module bogie(with_brake_wheel = false){
	difference(){
		union(){
			//some cosmetics need rotating, so far I've not done any that need mirroring, but will have to split this if I do
			rotate_mirror()translate([bogie_inner_width/2+bogie_padding_width,0,0])bogie_edge();
			
			//centre arm
			centred_cube(bogie_inner_width+bogie_padding_width*2,bogie_centre_arm_length,bogie_centre_arm_height);

			right_hole_bottom_z = bogie_offset_hole_pos[1]-bogie_offset_hole_d/2;

			//extra arm behind the cosmetics - hoping it's strong enough without changing the visual appearance much
			mirror_y(){
				translate([bogie_inner_width/2+bogie_padding_width/2,0,0])
					intersection(){
						centred_cube(bogie_padding_width,bogie_bottom_outer_wheel[0]*2,right_hole_bottom_z);
						mirror_x()bogie_hull_shape(bogie_padding_width);
				}
			}

			if(BOGIE_EASY_PRINT){
				//fill in underneath the very low arch (at real top of bogie, bottom of print)
				fill_in_width = bogie_flange_width+bogie_padding_width-0.4;
				mirror_y()difference(){
					//calculate length properly
					translate([bogie_inner_width/2+fill_in_width/2,0,0])centred_cube(fill_in_width,bogie_axle_distance+6.35,right_hole_bottom_z);
					translate([bogie_inner_width/2+bogie_padding_width,0,0])mirror_x()bogie_hull_shape(bogie_flange_width+1);
				}
			}

			mirror_xy(){
				translate([bogie_inner_width/2+bogie_padding_width/2,bogie_axle_distance/2+0.5,0])centred_cube(bogie_padding_width,4,axle_to_top_of_bogie+1.5);
			}

			mirror_xy()translate([bogie_inner_width/2+bogie_padding_width,bogie_axle_distance/2,axle_to_top_of_bogie])bogie_axle_holder_cosmetics();

			
			//cosmetic springs for suspension, done here to avoid mirroring
			difference(){
				union(){
					for(i=[0:3]){
						xpos = (i%2 == 0) ? 1 : -1;
						ypos = (i < 2) ? 1: -1;
						translate([(bogie_inner_width/2+bogie_padding_width+bogie_flange_width-bogie_top_cylinder_r)*xpos,ypos*bogie_axle_distance/2,bogie_top_cylinder_h])metric_thread(diameter=bogie_spring_d, thread_size=1.5, groove=false, pitch=1, length=axle_to_top_of_bogie-bogie_top_cylinder_h-bogie_axle_holder_size/2);
					}
				}
				centred_cube(bogie_inner_width+bogie_padding_width*2,bogie_axle_distance*1.5,axle_to_top_of_bogie*2);
			}

			
			//coupling holder
			// translate([0,coupling_from_bogie_centre, coupling_arm_height+coupling_arm_z]){
			// 	if(COUPLING_TYPE == "dapol"){
			// 		translate([0,0,bogie_coupling_height-coupling_arm_z-coupling_arm_height])coupling_mount_dapol_alone(bogie_coupling_height-coupling_arm_height);
			// 	}else{
			// 		coupling_mount(bogie_coupling_height-coupling_arm_height-coupling_arm_z,coupling_arm_height);
			// 	}
				
			// }
			above_arm = bogie_coupling_height - coupling_arm_height - coupling_arm_z;
			translate([0,bogie_centre_from_edge,bogie_coupling_height])generic_coupling_mount(COUPLING_TYPE,coupling_arm_height,above_arm);//COUPLING_TYPE

			//how much shorter to make the arm, based on the type of coupling mount
			//coupling_mount_y_adjust = COUPLING_TYPE == "dapol" ? -5 : -m2_thread_size;

			//coupling_arm_length = coupling_from_bogie_centre + coupling_mount_y_adjust;
			coupling_arm_length = bogie_centre_from_edge - generic_coupling_mount_from_edge(COUPLING_TYPE);
			translate([0,coupling_arm_length/2,coupling_arm_z])centred_cube(5,coupling_arm_length,coupling_arm_height);
			if(with_brake_wheel){
				//make bit with brake wheel thicker
				extra_thickness =  2-min_thick;// - bogie_backing_plate_thick;
				extra_thickness_length = buffer_holder_d*2;
				mirror_y()translate([bogie_inner_width/2+bogie_padding_width++bogie_backing_plate_thick-extra_thickness/2-min_thick, bogie_brake_wheel_pos[0],0])centred_cube(extra_thickness,extra_thickness_length, bogie_brake_wheel_pos[1]+buffer_holder_d*0.75);
			}

		}//end of additive bits
		union(){
			//wheel holder
			mirror_x()translate([0,bogie_axle_distance/2,axle_to_top_of_bogie])axle_punch();
			//m3 bolt holder
			translate([0,0,-1])cylinder(r=m3_thread_loose_size/2,h=20,$fn=100);
			if(with_brake_wheel){
				//MWA-B style brake wheel on bogie
				mirror_y()translate([5,bogie_brake_wheel_pos[0],bogie_brake_wheel_pos[1]])rotate([0,90,0])cylinder(r=buffer_holder_d/2,h=20);
			}
		}

		
	}
	//mirror_x()translate([0,bogie_axle_distance,axle_to_top_of_bogie])axle_punch();
}

module gen_brake_wheel(){
	//from intermodal wagon, with options now
	if(STYLE != "MWA-B"){
		brake_wheel(buffer_holder_length/3, brake_wheel_d, 4);
	}else{
		//default from intermodalwagon actually seems to be right for MWA-B
		brake_wheel(buffer_holder_length/3);
	}
	

}

wagon_base_thick = wagon_height - side_ridge_height;
//buffer_ledge_height
//[ [x,y, base_thick] ]
//mirrored xys
base_top_screws = [
	//screws at far ends
	[7, wagon_length/2 - buffer_ledge_length/2, wagon_base_thick + buffer_ledge_height],
	//screws near middle
	[wagon_width/2-5, 24, wagon_base_thick]
	];

//trying gluing in centre and screwing & gluing at ends
//[y coord, width]
base_top_glue_holes_y = [[24, wagon_width - 17], [wagon_length/2 - buffer_ledge_length/2-1, 5]];
//glue_hole_width = wagon_width - 10;
glue_hole_length = 7;
//0.8 was only two layers in each side and barely left a gap after the bridging
glue_hole_thick = 1.2;//0.8;

module wagon_base(){
	fudge_factor=0.01;
	wheel_space_r = 21;
	wheel_space_r2 = 15;
	edge_thick = 1;

	difference(){
		//just the bottom of the wagon
		translate([0,0,-side_ridge_height-fudge_factor])intersection(){
			translate([0,0,side_ridge_height+0.01])centred_cube(wagon_width*2,wagon_length*2,100);
			wagon();
		}
		union(){
			if(false){
				//I'm undecided if this is a good idea - it reduces wheels rubbing on gradient changes (but so does tightening the screw) but risks derailing around corners if the bogies catch
				//subtract out some extra clearance for the wheels
				mirror_x()translate([0, bogie_distance/2,0])union(){
					difference(){
						intersection(){
							translate([0,0,-1])cylinder(r=wheel_space_r,h=20);
							translate([0,0,-2])centred_cube(wagon_width-edge_thick*2,wheel_space_r*3,30);
						}
						//translate([0,0,-3])cylinder(r=wheel_space_r2,h=40);
						centred_cube(wagon_width,wheel_space_r2,40);
					}
				}
			}
		//and some screwholes to attach this to the main wagon
			mirror_xy(){
				for(screw = base_top_screws){
					translate(screw){
						cylinder(r=m2_thread_size_loose/2,h=20,center=true);
						translate([0,0,-m2_head_length])cylinder(r=m2_head_size/2,h=10);
					}
				}
			}
			//glue holes for hot glue
			mirror_x(){
				for(hole = base_top_glue_holes_y){
					translate([0,hole[0],-fudge_factor])centred_cube(hole[1], glue_hole_length, glue_hole_thick/2);
				}
			}
		}
	}
}


module wagon_top(){
	translate([0,0,wagon_height - wagon_base_thick])rotate([0,180,0])difference(){
		wagon(true);
		union(){
			//lop off the base
			translate([0,0,wagon_height-wagon_base_thick])centred_cube(wagon_width*2,wagon_length*2,20);
			//add the screwholes
			mirror_xy(){
				for(screw = base_top_screws){
					translate([screw[0], screw[1], wagon_height - base_thick + min_thick*4]){
						cylinder(r=m2_thread_size/2,h=20);
					}
				}
			}
			//glue holes for hot glue
			mirror_x(){
				for(hole = base_top_glue_holes_y){
					translate([0,hole[0],wagon_height-wagon_base_thick-glue_hole_thick/2])centred_cube(hole[1], glue_hole_length, glue_hole_thick);
				}
			}
		}
	}
}

//variation on the modern_buffer to make it a bit more MWA specific
//copy-paste and tweak job
//(0,0,0) is centre of buffer plate, buffer is vertical with buffer plate on the xy plane
module buffer(){
		
	fixing_length=4;


	//end that would touch another buffer if it were real
	end_width = 6;
	//height from the point of view on the train, +ve y here
	end_height=3.25;
	//my made-up buffer terminology, pole is the bit between the flat plate and the holder, and holder is the bit attached to a real wagon
	//
	pole_diameter = 2.5;//1;
	holder_diameter=2.5;//1.8;
	total_length=5.5;
	pole_length = 1;
	end_length=0.8;
	//1.8 bit too big for the 2.0 diameter holes
	truck_fixing_d=buffer_d;//1.7;//1.5;

	end_flange_length = 0.6;

	end_corner_r = 0.5;
	//top is curved
	end_top_r = 8;
	flat_bit_width = end_width;//-end_corner_r*2;
	//height from top of square bit to centre of the circle that makes the top curve - ish, not quite accurate
	h = sqrt(end_top_r*end_top_r - flat_bit_width*flat_bit_width/4);

	endplate_length=0.5;

	trainplate_width = end_width*0.7;
	trainplate_height = end_height*0.7;
	trainplate_r = 10;
	trainplate_length = 0.1;

	trainplate_h =  sqrt(trainplate_r*trainplate_r - trainplate_width*trainplate_width/4);
	trainplate_flange_length = 1.2;


	//end plate of the buffer
	hull(){
		rounded_cube(end_width,end_height,end_length, end_corner_r);
		intersection(){
			translate([0,-10,0])centred_cube(flat_bit_width,20,end_length);
			translate([0,-end_height/2 + h, 0])cylinder(r=end_top_r, h = end_length);
		}
		cylinder(r=holder_diameter/2,h=end_flange_length+end_length);
	}

	
	cylinder(r=pole_diameter/2, h=total_length, $fn=200);
	translate([0,0,pole_length+end_length]){
		cylinder(r=holder_diameter/2, h=total_length-(pole_length+end_length), $fn=200);
	}
	cylinder(r=truck_fixing_d/2,h=total_length+fixing_length, $fn=200);

	//trainplate end
	hull(){
		translate([0,0,total_length-trainplate_length])mirror_x()intersection(){
			translate([0,-10,0])centred_cube(trainplate_width,20,trainplate_length);
			translate([0,-trainplate_height/2 + trainplate_h, 0])cylinder(r=trainplate_r, h = trainplate_length);
		}
		translate([0,0,total_length-trainplate_length-trainplate_flange_length+0.1])cylinder(r=holder_diameter/2,h=0.1);
	}

}

if(GEN_WAGON){
	optional_translate([0,0,wagon_base_above_rails + wagon_height],GEN_IN_SITU)optional_rotate([0,180,0],GEN_IN_SITU)wagon(true);
}

if(GEN_BASE){
	wagon_base();
}

if(GEN_TOP){
	wagon_top();
}

if(GEN_BOGIE){
	// bogies_different = STYLE == "MWA-B";
	//TODO, rotate rather than mirror!
	rotate_mirror(GEN_IN_SITU)optional_translate([0,bogie_distance/2,axle_to_top_of_bogie+wheel_diameter/2],GEN_IN_SITU)optional_rotate([0,180,0],GEN_IN_SITU){
		bogie(STYLE == "MWA-B");

		if(GEN_MODEL_BITS){
			//representation of the wheels. not for printing
			mirror_x()translate([0,bogie_axle_distance/2, axle_to_top_of_bogie])wheelset_model(wheel_diameter);
			//coupling
			//works but doesn't end up in exported STL
			//translate([0,coupling_from_bogie_centre-0.6, coupling_arm_height+coupling_arm_z+0.2])import("stl/coupling_dapol_model.stl");
			translate([0,coupling_from_bogie_centre-0.6, coupling_arm_height+coupling_arm_z+0.2])gen_couplings(true, true, true, "wide", "inline", "dapol");
		}
	}

	
}

if(GEN_BRAKE_CYLINDER){
	if(HAS_SEPARATE_BRAKE_CYLINDERS){
		optional_translate([0,0,wagon_base_above_rails + wagon_height],GEN_IN_SITU)rotate([0,180,0]){
			for(cylinder_def = wagon_cylinders){
					pos = cylinder_def[0];
					r = cylinder_def[1];
					length = cylinder_def[2];
					translate([pos[0],pos[1],wagon_height])brake_cylinder(cylinder_def,false);
				}
		}
	}
}

if(GEN_BRAKE_WHEEL){
	if(GEN_IN_SITU){
		if(STYLE != "MWA-B"){
			//big_cylinder_brake_wheel_pos, little_cylinder_brake_wheel_pos
			optional_translate([0,0,wagon_base_above_rails + wagon_height],GEN_IN_SITU)optional_rotate([0,180,0],GEN_IN_SITU)translate(big_cylinder_brake_wheel_pos)translate([-0.5,0,0])rotate([0,90,0])gen_brake_wheel();

			optional_translate([0,0,wagon_base_above_rails + wagon_height],GEN_IN_SITU)optional_rotate([0,180,0],GEN_IN_SITU)translate(little_cylinder_brake_wheel_pos)translate([0.5,0,0])rotate([0,-90,0])gen_brake_wheel();
		}else{
			//mirror_y()translate([bogie_inner_width/2+bogie_padding_width++bogie_backing_plate_thick-extra_thickness/2-min_thick, bogie_brake_wheel_pos[0],0])centred_cube(extra_thickness,extra_thickness_length, bogie_brake_wheel_pos[1]+buffer_holder_d*0.75);
			color("white")mirror_y()translate([bogie_inner_width/2+bogie_padding_width+bogie_flange_width+0.4,-bogie_distance/2-bogie_brake_wheel_pos[0], axle_to_top_of_bogie+wheel_diameter/2-bogie_brake_wheel_pos[1]])rotate([0,-90,0])brake_wheel();
		}
	}else{
		gen_brake_wheel();
	}
}

if(GEN_BUFFER){
	//wagon rotation copypasta
	color("grey")optional_translate([0,0,wagon_base_above_rails + wagon_height],GEN_IN_SITU)optional_rotate([0,180,0],GEN_IN_SITU){

		mirror_xy(GEN_IN_SITU)optional_translate([buffer_distance/2,wagon_length/2+buffer_holder_length+1,wagon_height+buffer_z_from_base],GEN_IN_SITU)optional_rotate([90,0,0],GEN_IN_SITU)buffer();

	}
	
}

if(GEN_GRAVEL){
	padding = GEN_IN_SITU ? 0 : 0.2;
	optional_translate([0,0,wagon_base_above_rails+wagon_base_thick], GEN_IN_SITU)gravel_pile(wagon_width-wall_thick*2-padding, wagon_length-wall_thick*2-padding, wagon_height-base_thick);
}