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

min_front_thickness = 0.8;
module hornby_style_coupling(withMountHoles=true){

min_thickness = 1.5;




hole_diameter = 2.7;
second_hole_diameters=2;
second_hole_distance=7.5;
main_arm_width = 6+2;
main_arm_length = 5.9;


difference() {
     
    union(){
            coupling_base(arm_thickness=1.8, arm_length = 9.7, coupling_height = 2.5, coupling_width=21, arc_radius = 26, min_thickness = min_thickness, base_width = 2.4, flange_max=2, flange_min=1, min_front_thickness=min_front_thickness);
    
            //add the stub at the bottom for holding the hook
            translate([-main_arm_width/2, -main_arm_length, 0]){
                cube([main_arm_width, main_arm_length, min_thickness]);
        }
    };
    
    //holes to punch out
   union(){
       if(withMountHoles){
            cylinder(h=min_thickness*3, r=hole_diameter/2, center = true, $fn=200);
           translate([-second_hole_distance,0,0]){
            cylinder(h=min_thickness*3, r=second_hole_diameters/2, center = true, $fn=200);
           };
           translate([second_hole_distance,0,0]){
            cylinder(h=min_thickness*3, r=second_hole_diameters/2, center = true, $fn=200);
           }
       }
   }
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
hook_holder_y=main_arm_length - hook_base_length/2;

anti_wobble = 3;

hook_base_clip(-hook_holder_end_cap_thickness*2, -main_arm_length, main_arm_width/2, hook_base_length, hook_height, hook_holder_diameter/2, hook_holder_length, hook_holder_end_cap_thickness*2, hook_holder_height, hook_holder_y);

}

hornby_style_coupling();
