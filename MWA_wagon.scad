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
Seen three obvious variants:

 - MWA Green freightliner with thin panel for logo on side and parking break roughly centre of wagon
 - MWA-B Grey freightliner with tall panel for logo on side and parking break on one bogie
 
 not to be confused with
 - MMA Red DB different numbers of ridges, different ends but parking brake in same place as green freightliner
 
  - MJA looks similar to MWA but wagons come in pairs
 
 Plan: green freightliner design seems easiest, althouhg might still consider printing it in any of the colours
 
 
 as usual 'width' usually refers to anything in the x direction and 'length' in y
 

*/
include <truck_bits.scad>
include <constants.scad>
include <threads.scad>

GEN_IN_SITU = false;
GEN_WAGON = true;
GEN_BOGIE = false;
GEN_BRAKE_WHEEL = false;
GEN_BRAKE_CYLINDER = false;
GEN_BUFFER = false;


//total length includes buffers
total_length = m2mm(13.97);
//these are mostly dervived from a picture I un-perspectvied and printed out at the right size

//length of the base,not including buffers
wagon_length = 168.5;//170.1;
wagon_end_flange_length = (170.1-wagon_length)/2;
//complete guess if I'm honest, same as the container wagons
wagon_width = 30;
//starting from 'base' which is the flat bit above the bogies
//wagon_height = 28.5; - possibly correct if my photo really is squashed
wagon_height = 28.5;//30;

brake_wheel_d = 7;

side_ridge_length = 2.2;
side_ridge_length2 = 3.1;
side_ridge_thicker_length = 3;
top_ridge_height = 2.8;
top_ridge_thick = top_ridge_height*0.5;
top_ridge_flange_height=5.5;
side_ridge_thick=side_ridge_length*0.5;

//the thin bits, giong to assume the others are same as sides
//too much thinner and it won't be sliced for printing
end_ridge_thick = 0.6;
end_flange_taper_height = 0.8;

end_ridge_x = 1.5*wagon_width/7;

nameplate_length = 44.2;
nameplate_height = 10.8;
nameplate_z = 7;

end_bottom_ledge_z = wagon_height -3;//27;
//guessing a bit here
end_mid_ledge_z = end_bottom_ledge_z * 0.6;
ledge_thick = 0.4;

side_ridge_height = wagon_height-3;
side_ridge_height2 = wagon_height-0.9;

wall_thick = 1;
base_thick = 5;

min_thick = 0.2;

//facing +ve x
module side_ridge(length){
	translate([wagon_width/2+side_ridge_thick/2,0,0])hull(){
			centred_cube(side_ridge_thick,length,side_ridge_height);
			translate([-side_ridge_thick/2-0.1/2,0,0])centred_cube(0.1,length,side_ridge_height2);
		}
}

//length is up to the base of the buffer, which is further out than parts of the end
module wagon_end_indents(){
	//indent_height = wagon_height - end_bottom_ledge_z;
	mirror_x()translate([0,wagon_length/2+wagon_end_flange_length,top_ridge_height])centred_cube(wagon_width-end_ridge_thick*2,side_ridge_thick*2,end_bottom_ledge_z-top_ridge_height);
}


// main body of the wagon
//upside down, so 0,0,0 is centre of top of wagon (the open bit)
module wagon(){
	difference(){
		centred_cube(wagon_width, wagon_length, wagon_height);
		union(){
			translate([0,0,-0.01])centred_cube(wagon_width-wall_thick*2, wagon_length-wall_thick*2-wagon_end_flange_length*2, wagon_height-base_thick);
			wagon_end_indents();
		}
	}
	
	//top side ridge
	mirror_y()translate([wagon_width/2+top_ridge_thick/2,0,0])centred_cube(top_ridge_thick,wagon_length+wagon_end_flange_length*2,top_ridge_height);
	//top end ridge
	mirror_x()translate([0,wagon_length/2+wagon_end_flange_length/2,0])centred_cube(wagon_width,wagon_end_flange_length,top_ridge_height);
	
	//side ridges
	//9 central ones of same thickness and distance
	//then two outer ones of thickerness but same distance
	//finfall two outmost ones same thickness as central ones, but further out
	//the 9 central ones
	inner_ridges_distance = 90;
	inner_ridge_d = inner_ridges_distance/8;
	//inner ridges
	mirror_y()for(i=[0:8]){
		translate([0,-inner_ridges_distance/2 + inner_ridge_d*i,0])side_ridge(side_ridge_length);
	}
	//next ridges, same distance, more thick
	mirror_xy(){
		translate([0,-inner_ridges_distance/2 - inner_ridge_d,0])side_ridge(side_ridge_length2);
	}
	//last side ridges, different distance
	side_ridge_from_end=14.5;
	mirror_xy(){
		translate([0,wagon_length/2 - side_ridge_from_end,0])side_ridge(side_ridge_length);
	}
	nameplate_thick = side_ridge_thick+min_thick;
	//name plate
	mirror_y()translate([wagon_width/2+nameplate_thick/2,0,nameplate_z])centred_cube(nameplate_thick,nameplate_length,nameplate_height);
	
	//end flanges
	mirror_xy()hull(){
		translate([wagon_width/2+top_ridge_thick/2,wagon_length/2-end_ridge_thick/2+wagon_end_flange_length,0]){
			centred_cube(top_ridge_thick,end_ridge_thick,top_ridge_height);
			translate([-top_ridge_thick/2-0.1/2,0,0])centred_cube(0.1,end_ridge_thick,top_ridge_flange_height);
			
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
	
	//two end vertical ridges
	mirror_xy()translate([end_ridge_x,wagon_length/2+wagon_end_flange_length-side_ridge_thick/2-min_thick,0])centred_cube(side_ridge_length,side_ridge_thick,end_bottom_ledge_z);
	
	//mid end ledge
	ledge_length = side_ridge_thick-min_thick*2;
	mirror_x()translate([0,wagon_length/2,end_mid_ledge_z])centred_cube(wagon_width,ledge_length,ledge_thick);
	//mid end vertical ledge
	//thicker so it will be sliced and printed
	mirror_x()translate([0,wagon_length/2,0])centred_cube(end_ridge_thick,ledge_length,end_mid_ledge_z);
	
	notch_width = end_ridge_x*2 -side_ridge_length - min_thick*2;
	notch_length = wagon_end_flange_length - min_thick*2;
	//bottom end ledge
	mirror_x(){
		difference(){
			translate([0,wagon_length/2,end_bottom_ledge_z-ledge_thick])centred_cube(wagon_width,side_ridge_thick+min_thick*2,ledge_thick);
			
			
			
			translate([0,wagon_length/2+wagon_end_flange_length-notch_length/2,end_bottom_ledge_z-ledge_thick*2])centred_cube(notch_width,notch_length,ledge_thick*4);
		}
	}
	
	//extra ledge for the buffers
	
		
}



if(GEN_WAGON){
	//TODO optional positioning if in situ
	wagon();
}