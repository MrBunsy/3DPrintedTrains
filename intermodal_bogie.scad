include <truck_bits.scad>
//include <hornby_bachman_style.scad>
include<constants.scad>

/*

Bogie designed to look like FSA/FTA wagon bogie

*/

dapol_wheels = true;
spoked = false;

//misc useful bits copypated from truck_base TODO consider how to abstract out


thick = 2;

//distance between the two axle holders (along the axle)
axle_space = 23.0;

//mainly because I haven't got any shorter m3 screws, don't need quite this much stability
m3_hole_depth = 5;
m3_hole_thick = 1.5;

wheel_max_d = getWheelMaxDiameter(dapol_wheels,spoked);
wheel_diameter = getWheelDiameter(dapol_wheels,spoked);

//height above thick for the coupling mount
coupling_height = 1;

//from intermodal wagon, to calculate length of arm for coupling
bogie_from_end = 30.5;

//above the thickness, since the coupling is also above the thickness
axle_height = top_of_coupling_from_top_of_rail + coupling_height - wheel_diameter/2;

axle_distance = 23.6;//wheel_max_d*1.5;//23.6 is 1.8metres which is the "real" size

coupling_from_axle = bogie_from_end - coupling_from_edge - axle_distance/2;


bar_thick = 2.5;
width=axle_space+bar_thick*2;
//length=axle_distance + coupling_end_from_axle + non_coupling_end_from_axle;
length=bar_thick*3;
coupling_arm_wide = 5;
coupling_width = 17;

echo("width",width,"length",length, "axle_height",axle_height, "thick",thick);


//easier to do one half and mirror the whole lot after
module intermodal_bogie_cosmetics_half(axle_distance, wheel_diameter,wide){
    
        
    corner_r = wheel_diameter*0.275;
    //size aroudn the hole, for the main bogie A-frame
    central_hole_r1 = wheel_diameter*0.275*0.75;
    //size of hole punched through
    central_hole_r2 = wheel_diameter*0.275*0.5;
    //size of hole raised outwards around main hole
    hole_wider1=0.4;
    hole_wider2=0.2;
    hole_raised1 = 0.2;
    hole_raised2 = 0.4;
    offset_hole_r1 = wheel_diameter*0.275*0.4;
    offset_hole_r2 = wheel_diameter*0.275*0.3;
    bar_height_above_axles = wheel_diameter*0.275*0.9;
    spring_r = wide*0.6;
    axle_mount_ledge_thick=0.5;
    
intersection(){
union(){
    difference(){
        union(){
            //quarter of a circle for the corners
                translate([0, -axle_distance/2 - corner_r/2,corner_r]) intersection(){
                    rotate([0,90,0]) cylinder(h=wide,r=corner_r);
                    translate([0,-corner_r,-corner_r]) cube([wide,corner_r, bar_height_above_axles]);
                }
            
                //bar along the bottom
                translate([0,-(axle_distance/2+corner_r/2),0])cube([wide,corner_r*1.8, bar_height_above_axles]);
                
                
                //triangle shape with holes
            hull(){
                translate([0,-(axle_distance/2-corner_r*1.3),0])cube([wide,axle_distance/2-corner_r/2, bar_height_above_axles]);
                translate([0,0,corner_r]) rotate([0,90,0]) cylinder(h=wide,r=central_hole_r1);
            }
            
            //raised bit around main hole
            translate([0,0,corner_r]) rotate([0,90,0]) cylinder(h=wide+hole_wider1,r=central_hole_r2+hole_raised1);
            translate([0,0,corner_r]) rotate([0,90,0]) cylinder(h=wide+hole_wider2,r=central_hole_r2+hole_raised2);
        }
        //punch holes out
        
        union(){
           translate([0,0,corner_r]) rotate([0,90,0]) cylinder(h=wide*3,r=central_hole_r2, center=true);
            
            hull(){
                translate([0,-central_hole_r1*1.6,bar_height_above_axles*0.6]) rotate([0,90,0]) cylinder(h=wide*3,r=offset_hole_r1, center=true);
                translate([0,-central_hole_r1*2.5,bar_height_above_axles*0.6-offset_hole_r2*0.3]) rotate([0,90,0]) cylinder(h=wide*3,r=offset_hole_r2, center=true);
            }
        }
    }
    axle_mount_size = corner_r*3 - spring_r*5;
    axle_mount_bottom_length = corner_r*3;
    
    //springs
    translate([spring_r - (spring_r*2 - wide)/2,-(axle_distance/2+corner_r*1.5-spring_r),bar_height_above_axles])cylinder(r=spring_r,h=axle_mount_size);
    
    translate([spring_r - (spring_r*2 - wide)/2,-(axle_distance/2-corner_r*1.5+spring_r),bar_height_above_axles])cylinder(r=spring_r,h=axle_mount_size);
    
    
    //axle mounting
    translate([0,-(axle_distance/2+axle_mount_size/2),bar_height_above_axles])cube([wide,axle_mount_size, axle_mount_size]);
    
    sphere_r = wide*2;
    //sticky out bit on axle mount - want the tip of a sphere
    //line up exactly with axle_height, so we can judge the size of the rest around this
    intersection(){
        translate([-sphere_r*0.43,-axle_distance/2,axle_height+thick])sphere(r=wide*2);
        translate([wide,-(axle_distance/2+axle_mount_size/2),corner_r])cube([wide,axle_mount_size, axle_mount_size]);
    }
    
    //bottom of axle mount
    
    translate([0,-(axle_distance/2+axle_mount_bottom_length/2),bar_height_above_axles+axle_mount_size])cube([wide,axle_mount_bottom_length, axle_mount_ledge_thick]);
    
}//end union
//ensure this really is only half so it doesn't overlap with its mirror
    translate([-wide*5,-100,-50])cube([wide*10,100,100]);
}//end intersection
}

//base at (0,0), facing +ve x
module intermodal_bogie_cosmetics(axle_distance, wheel_diameter,wide){
    
     mirror_x() intermodal_bogie_cosmetics_half(axle_distance, wheel_diameter,wide);        
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
        centredCube(0,long_arm_length/2,coupling_arm_wide,long_arm_length,thick + coupling_height);
        centredCube(0,coupling_from_axle+axle_distance/2,coupling_width,coupling_arm_wide,thick + coupling_height);
        
        //lengthening of hole for m3 screw
        cylinder(h=m3_hole_depth, r=(m3_thread_loose_size/2)+m3_hole_thick);
    }
    
    union(){
        //space for wheels
        translate([0,-axle_distance/2,axle_height+thick]){
            axle_hole(wheel_max_d,axle_space,axle_centre_space);
        }
        translate([0,axle_distance/2,axle_height+thick]){           
            axle_hole(wheel_max_d,axle_space,axle_centre_space);
        }
        //extra deep hole for couplings
        translate([0,axle_distance/2 + coupling_from_axle,-thick]){
            cylinder(h=thick*4,r=m2_thread_size/2, $fn=200);
        }
        //m3 hole to connect to main chassis
        cylinder(h=100,r=m3_thread_loose_size/2, $fn=200, center=true);
    }
}

//just to be confusing, axle_holder adds thickness itself
axle_holder(axle_space, 20, axle_height);

translate([0,axle_distance/2 + coupling_from_axle,thick +  coupling_height]){
    coupling_mount(0);
}
difference(){
    union(){
        //cosmetic bits on the outside
        translate([width/2-thick*0.8,0,0]) intermodal_bogie_cosmetics(axle_distance, wheel_diameter, thick);
        mirror([1,0,0])translate([width/2-thick*0.8,0,0]) intermodal_bogie_cosmetics(axle_distance, wheel_diameter, thick);
    }
    //punch out the holes for the axle again
    axle_holder(axle_space, 20, axle_height, true);
    
}
r=getWheelDiameter();
mirror_x(){color("gray")translate([0,-axle_space/2,axle_height+thick])rotate([0,90,0]) cylinder(h=axle_width*0.9, r=r/2 ,center=true);}