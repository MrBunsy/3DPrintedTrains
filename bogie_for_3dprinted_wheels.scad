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

//bogie for testing 3d printed wheels

//aiming for distance between flanges of 16.0

wheel_diameter = 12.4;

flange_distance = 16.0;

washer_width = 0.3;
wheel_base = 1.5;
wheel_flange_depth = 0.2;

width = flange_distance - 2*washer_width - 2*wheel_base - 2* wheel_flange_depth;
echo(width);

axle_spacing = 25;

length = axle_spacing+wheel_diameter/2;

height = wheel_diameter/2;

m2_hole_d = 2;
$fn=200;


rotate([0,90,0]){//print with holes vertically
difference(){
    
    translate([-width/2, -length/2]){
        cube([width,length,height]);
    }
    
    union(){
        
        translate([0,(axle_spacing)/2,height/2]){
            rotate([0,90,0]){
                cylinder(r=m2_hole_d/2,h=width*2,center=true);
            }
        }
        translate([0,-(axle_spacing)/2,height/2]){
            rotate([0,90,0]){
                cylinder(r=m2_hole_d/2,h=width*2,center=true);
            }
        }
    }
}
}