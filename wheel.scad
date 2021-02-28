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

diameters_12_5mm = [14.6,14.6, 12.7, 12.5];//not much gradient on the wheel part with this
diameters_14mm = [16.5,16.5, 14.45, 14.0];
diameters_14mm_dummy = [14.4,14.4, 14.4, 14.0];
depths = [0.4, 0.3, 2.7];//total 3.4
total_depth = 3.4;
//might need to make first dpeth longer to reduce wobble?
$fn=1000;

flange_to_point = 5.1;
//intended for a 2mm brass rod of length 21.2mm (better slightly shorter, so it doesn't stick out the ends and therefore is easy to use in a clamp)


module wheel_segment(i, diameters, fn=2000){
    cylinder(r1=diameters[i]/2, r2=diameters[i+1]/2, h=depths[i], $fn=fn);
    if(i< len(depths)-1){
        translate([0,0, depths[i]]){
            wheel_segment(i+1,diameters, fn);
        }
    }
}
module wheel(diameters=diameters_14mm, depths=depths, fn=2000, extra_axle_length = 2.5){
	//2mm rod
	//1mm radius works well for the 2mm rod with a clamp, but very hard to get wheel perfectly straight. trying slightly more loose but with more length
	//1.1 works very well indeed for wheels that slide onto the axle, but they are a tiny bit too loose for ones that I don't want to be able to move along the axle.
	axle_r=1.075;
	extra_height = extra_axle_length;
	fancy_internal_r=5.8/2;

	difference(){
		union(){
			wheel_segment(0,diameters, fn);
			cylinder(h=total_depth + extra_height, r=fancy_internal_r, $fn=fn);
		}
		
		//fancy styling
		union(){
			//2mm rod
			cylinder(h=15, r=axle_r, center=true);
			
			difference(){
				translate([0,0,2.9])cylinder(h=1, r=diameters[len(diameters)-1]/2-1.5, $fn=fn);
				cylinder(h=10, r=fancy_internal_r, center=true, $fn=fn);
			}
		}
	}
}

module wheelset_model(diameter=12.5){
	
	diameters = diameter == 14 ? diameters_14mm : diameters_12_5mm;
	
	mirror_y()translate([16.5/2-(depths[0] + depths[1]),0,0])rotate([0,90,0])wheel(diameters, depths, 50, 0);
	
	scale([axle_width/axle_holder_width,1,1])axle_punch();
}

module wheel_with_point(diameters=diameters_14mm, depths=depths, fn=2000, extra_axle_length = 2.5){
	
	wheel(diameters, depths, fn, extra_axle_length);
	translate([0,0,total_depth + extra_axle_length])cylinder(r1=1.5,r2=0,$fn=fn, h = flange_to_point - total_depth - extra_axle_length);
	echo("point height",flange_to_point - total_depth - extra_axle_length);
	
}

//these wheels work for the class 66 when mounted on 2mm brass rods with clean ends (use the rail cutters for this!)
//wheel(diameters_14mm, depths, 2000, 2.5);

//for the class 66
//wheel(diameters_14mm_dummy, depths, 2000, 2.5);

//trying making my own wheelset
wheel(diameters_12_5mm, depths, 2000, 3.7-total_depth);
//wheel_with_point(diameters_12_5mm, depths, 2000, 3.7-total_depth);
//needs 2mm rod of length 25.7 - 1.4*2; (1.4 is point height) = 22.9

//wheelset_model();