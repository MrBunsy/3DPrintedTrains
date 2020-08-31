include <truck_bits.scad>
include <hornby_bachman_style.scad>
$fn=200;

dapol_wheels = true;

//misc useful bits copypated from truck_base TODO consider how to abstract out

top_of_coupling_from_top_of_rail = 7.9;
thick = 2;
//pointy bit to pointy bit of spare hornby axles (also works for dapol axles)
axle_width = 25.65;
//distance between the two axle holders (along the axle)
axle_space = 23.0;
m2_thread_size = 2;
m3_thread_loose_size = 3.2;
m3_hole_depth = 1;
m3_hole_thick = 1.5;

//diameter around which there can be no obstructions for the wheels
wheel_max_d = dapol_wheels ? 14+2 : 17+2;

//max_d doesn't apply within this space in the centre of the axle
wheel_centre_space = 8;
wheel_diameter = dapol_wheels ? 12.8 : 14.0;

//height above thick for the coupling mount
coupling_height = 0;

//how high for axle to be from the underside of the truck
//bachman seem to be lower than the rest at 5, hornby + lima about 6
//this should probably be adjusted for wheel size as it affects buffer height
axle_height = top_of_coupling_from_top_of_rail + coupling_height - wheel_diameter/2;

axle_distance = wheel_max_d*1.5;

coupling_from_axle = wheel_max_d/2 + 1;


bar_thick = 2.5;
width=axle_space+bar_thick*2;
//length=axle_distance + coupling_end_from_axle + non_coupling_end_from_axle;
length=bar_thick*3;
coupling_arm_wide = 5;
coupling_width = 17;

echo("width",width,"length",length, "axle_height",axle_height, "thick",thick);


//easier to do one half and mirror the whole lot after
module intermodal_bogie_cosmetics_half(axle_distance, wheel_diameter,wide){
    
    corner_r = wheel_diameter*0.25;
    central_hole_r1 = corner_r*0.7;
    central_hole_r2 = corner_r*0.55;
    offset_hole_r1 = corner_r*0.4;
    offset_hole_r2 = corner_r*0.3;
    bar_height_above_axles = corner_r*1;
    spring_r = wide*0.6;
    difference(){
        union(){
            //quarter of a circle for the corners
                translate([0, -axle_distance/2 - corner_r/2,corner_r]) intersection(){
                    rotate([0,90,0]) cylinder(h=wide,r=corner_r);
                    translate([0,-corner_r,-corner_r]) cube([wide,corner_r, corner_r]);
                }
            
                //bar along the bottom
                translate([0,-(axle_distance/2+corner_r/2),0])cube([wide,corner_r, bar_height_above_axles]);
                
                
                //triangle shape with holes
            hull(){
                translate([0,-(axle_distance/2-corner_r/2),0])cube([wide,axle_distance/2-corner_r/2, bar_height_above_axles]);
                translate([0,0,corner_r]) rotate([0,90,0]) cylinder(h=wide,r=central_hole_r1);
            }
        }
        //punch holes out
        
        union(){
           translate([0,0,corner_r]) rotate([0,90,0]) cylinder(h=wide*3,r=central_hole_r2, center=true);
            
            hull(){
                translate([0,-central_hole_r1*1.6,bar_height_above_axles/2]) rotate([0,90,0]) cylinder(h=wide*3,r=offset_hole_r1, center=true);
                translate([0,-central_hole_r1*2.5,bar_height_above_axles/2-offset_hole_r2*0.3]) rotate([0,90,0]) cylinder(h=wide*3,r=offset_hole_r2, center=true);
            }
        }
    }
    axle_mount_size = corner_r*3 - spring_r*5;
    axle_mount_bottom_length = corner_r*3;
    
    //springs
    translate([spring_r,-(axle_distance/2+corner_r*1.5-spring_r),corner_r])cylinder(r=spring_r,h=axle_mount_size);
    
    translate([spring_r,-(axle_distance/2-corner_r*1.5+spring_r),corner_r])cylinder(r=spring_r,h=axle_mount_size);
    
    
    //axle mounting
    translate([0,-(axle_distance/2+axle_mount_size/2),corner_r])cube([wide,axle_mount_size, axle_mount_size]);
    
    //bottom of axle mount
    
    translate([0,-(axle_distance/2+axle_mount_bottom_length/2),corner_r+axle_mount_size])cube([wide,axle_mount_bottom_length, 1]);
}

//base at (0,0), facing +ve x
module intermodal_bogie_cosmetics(axle_distance, wheel_diameter,wide){
    intermodal_bogie_cosmetics_half(axle_distance, wheel_diameter,wide);
    
    mirror([0,1,0]) intermodal_bogie_cosmetics_half(axle_distance, wheel_diameter,wide);
}

difference(){
    union(){
        
        //central arm
        centredCube(0,0,width,length,thick);
    
        //side arms to axle holders
        translate([width/2-bar_thick/2,0,0])
            centredCube(0,0,bar_thick,axle_space,thick);
        translate([-(width/2-bar_thick/2),0,0])
            centredCube(0,0,bar_thick,axle_space,thick);
        
        long_arm_length = coupling_from_axle+axle_distance/2 + coupling_arm_wide/2;
        //long arm to coupling
        centredCube(0,long_arm_length/2,coupling_arm_wide,long_arm_length,thick);
        centredCube(0,coupling_from_axle+axle_distance/2,coupling_width,coupling_arm_wide,thick);
        
        //lengthening of hole for m3 screw
        cylinder(h=m3_hole_depth+thick, r=(m3_thread_loose_size/2)+m3_hole_thick);
    }
    
    union(){
        //space for wheels
        translate([0,-axle_distance/2,axle_height+thick]){
            axle_hole(wheel_max_d,axle_space,wheel_centre_space);
        }
        translate([0,axle_distance/2,axle_height+thick]){           
            axle_hole(wheel_max_d,axle_space,wheel_centre_space);
        }
        //extra deep hole for couplings
        translate([0,axle_distance/2 + coupling_from_axle,-thick]){
            cylinder(h=thick*4,r=m2_thread_size/2, $fn=200);
        }
        //m3 hole to connect to main chassis
        cylinder(h=100,r=m3_thread_loose_size/2, $fn=200, center=true);
    }
}

axle_holder(axle_space, 20, axle_height);
//axle_holder_decoration(axle_space, 20, axle_height);
translate([0,axle_distance/2 + coupling_from_axle,thick]){
    coupling_mount(coupling_height);
}

translate([width/2,0,0]) intermodal_bogie_cosmetics(axle_distance, wheel_diameter, thick);
mirror([1,0,0])translate([width/2,0,0]) intermodal_bogie_cosmetics(axle_distance, wheel_diameter, thick);