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