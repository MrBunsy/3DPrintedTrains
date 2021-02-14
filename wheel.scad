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

diameters_12_5mm = [14.6,14.6, 12.7, 12.6];//not much gradient on the wheel part with this
diameters_14mm = [16.5,16.5, 14.45, 14.0];
depths = [0.4, 0.3, 2.7];//total 3.4
//might need to make first dpeth longer to reduce wobble?
$fn=1000;

//intended for a 2mm brass rod of length 21.2mm (better slightly shorter, so it doesn't stick out the ends and therefore is easy to use in a clamp)


module wheel_segment(i, diameters, fn=2000){
    cylinder(r1=diameters[i]/2, r2=diameters[i+1]/2, h=depths[i], $fn=fn);
    if(i< len(depths)-1){
        translate([0,0, depths[i]]){
            wheel_segment(i+1,diameters, fn);
        }
    }
}
module wheel(diameters=diameters_14mm, depths=depths, fn=2000){
	//2mm rod
	axle_r=1;

	difference(){
		wheel_segment(0,diameters, fn);
		//2.1 radius was perfect for m4
		//2.1 diameter was too tight for m2 (try 2.2?)
		//2.2 still a bit tight
		//2.3 still too tight?!
		
		//fancy styling
		union(){
			//2mm rod
			cylinder(h=10, r=axle_r, center=true);
			
			difference(){
				translate([0,0,2.9])cylinder(h=10, r=diameters[len(diameters)-1]/2-1.5, $fn=fn);
				cylinder(h=10, r=5.8/2, center=true, $fn=fn);
			}
		}
	}
}

module wheelset_model(diameter=12.5){
	
	diameters = diameter == 14 ? diameters_14mm : diameters_12_5mm;
	
	mirror_y()translate([16.5/2-(depths[0] + depths[1]),0,0])rotate([0,90,0])wheel(diameters, depths, 50);
	
	scale([axle_width/axle_holder_width,1,1])axle_punch();
}

//wheel();