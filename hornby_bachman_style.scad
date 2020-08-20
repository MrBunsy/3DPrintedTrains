include <OO_large_coupling.scad>


min_thickness = 0.8;




hole_diameter = 2.7;
second_hole_diameters=1.9;
second_hole_distance=7.1;
main_arm_width = 6;
main_arm_length = 5.2;


difference() {
     
    union(){
            coupling_base(arm_thickness=1.8, arm_length = 9.7, coupling_height = 2.5, coupling_width=20.7, arc_radius = 26, min_thickness = min_thickness, base_width = 2.4);
    
            //add the stub at the bottom for holding the hook
            translate([-main_arm_width/2, -main_arm_length, 0]){
                cube([main_arm_width, main_arm_length, min_thickness]);
        }
    };
    //holes to punch out
   union(){
        cylinder(h=min_thickness*3, r=hole_diameter/2, center = true, $fn=200);
       translate([-second_hole_distance,0,0]){
        cylinder(h=min_thickness*3, r=second_hole_diameters/2, center = true, $fn=200);
       };
       translate([second_hole_distance,0,0]){
        cylinder(h=min_thickness*3, r=second_hole_diameters/2, center = true, $fn=200);
       }
   }
}