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

//not including buffers
wagon_length = 170.1;
//complete guess if I'm honest, same as the container wagons
wagon_width = 30;
//starting from 'base' which is the flat bit above the bogies
wagon_height = 28.5;

brake_wheel_d = 7;

side_ridge_length = 2.2;
side_ridge_length2 = 3.1;
side_ridge_thicker_length = 3;
top_ridge_height = 2.8;
top_ridge_thick = top_ridge_height*0.5;
side_ridge_thick=side_ridge_length*0.5;

nameplate_length = 44.2;
nameplate_height = 10.8;
nameplate_z = 11;

//z at start of full width
side_ridge_main_z = 3;
//z at start of taper
side_ridge_start_z = 0.9;

wall_thick = 1;
base_thick = 5;

min_thick = 0.2;

//facing +ve x
module side_ridge(length){
	translate([wagon_width/2+side_ridge_thick/2,0,0])hull(){
			translate([0,0,side_ridge_main_z])centred_cube(side_ridge_thick,length,wagon_height - side_ridge_main_z);
			translate([-side_ridge_thick/2-0.1/2,0,side_ridge_start_z])centred_cube(0.1,length,wagon_height - side_ridge_main_z);
		}
}

// main body of the wagon
//accidentally starting making this the way up it really is, not the way to print it
//so 0,0 is the bottom centre of the wagon, and bits for buffers will be in -ve z
module wagon(){
	difference(){
		centred_cube(wagon_width, wagon_length, wagon_height);
		translate([0,0,base_thick])centred_cube(wagon_width-wall_thick*2, wagon_length-wall_thick*2, wagon_height);
	}
	
	//top side ridge
	mirror_y()translate([wagon_width/2+top_ridge_thick/2,0,wagon_height-top_ridge_height])centred_cube(top_ridge_thick,wagon_length,top_ridge_height);
	
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
}



if(GEN_WAGON){
	//TODO optional positioning if in situ
	wagon();
}