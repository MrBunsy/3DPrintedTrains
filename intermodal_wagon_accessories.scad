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

gen_brake_wheel = false;
gen_brake_cylinder = false;
//only for one prototype with the wrong sized buffer holes
gen_buffer_fixing = false;

//truck_fixing_d=buffer_d;//1.7;
truck_fixing_d = truck_fixing_shallow_d;
// sticks_out = 1;
wheel_thick = 0.5;
wheel_d = 6;
arms=3;
extra_height = 0.5;
hat_height = 2;

cylinder_d = 6;
cylinder_length = 3*4;
cylinder_hole_spacing = 2*4;

module brake_wheel(height=buffer_holder_length, wheel_d = 6, arms=3, wheel_thick = 0.5,little_hat = false){

	
	 //stick to slot into wagon
    translate([0,0,wheel_thick])cylinder(h=height+extra_height,r=truck_fixing_d/2);
	if(little_hat){
		//little hat to try and keep it slotted in
		translate([0,0,wheel_thick+height+extra_height])cylinder(h=hat_height,r1=buffer_holder_d*0.525,r2=truck_fixing_d*0.3);
	}

    //bit to join wheel and fixing arm
    translate([0,0,0])cylinder(h=wheel_thick,r1=truck_fixing_d*0.5, r2=truck_fixing_d/2);

    //actual wheel
    difference(){
        cylinder(h=wheel_thick,r=wheel_d/2);
        cylinder(h=wheel_thick*3,r=wheel_d/2-wheel_thick, center=true);
    }

    //wheel arms
    intersection(){
        cylinder(h=wheel_thick,r=wheel_d/2);
        
        for(i=[0:arms]){
            rotate(i*360/arms)translate([-wheel_thick/2,0,0])cube([wheel_thick,100,wheel_thick]);
            
        }
    }
}

module brake_cylinder(){
	translate([0,0,cylinder_d/2])rotate([0,90,0])cylinder(r=cylinder_d/2,h=cylinder_length, center=true);
	
	mirror_y()translate([-cylinder_hole_spacing/2,0,0])translate([0,0,cylinder_d/2])cylinder(h=buffer_holder_length+cylinder_d/2,r=truck_fixing_d/2);

	
}

if(gen_brake_wheel){
	brake_wheel(3, 6, 3, 0.5, true);
	translate([10,0,0])brake_wheel(2, 6, 3, 0.5, true);
}

if(gen_brake_cylinder){
	brake_cylinder();
}

if(gen_buffer_fixing){
	wiggle = 0.2;
	thick=3.5;
	box_wall_thick=0.5;
	box_size = 6;
	difference(){
		cube([ box_size-wiggle, box_size-wiggle, thick-box_wall_thick-wiggle]);
		translate([box_size/2-wiggle/2,-wiggle/2,thick/2-wiggle/2]){
			rotate([90,0,0]){
			//holes to hold buffers
			cylinder(h=buffer_holder_length*3, r=buffer_holder_d/2, $fn=200, center=true);
			}
		}
	}
	
}