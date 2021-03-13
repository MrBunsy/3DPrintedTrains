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

include <truck_bits.scad>
//include <hornby_bachman_style.scad>
include<constants.scad>

include <threads.scad>


/*

Bogie designed to look like FSA/FTA wagon bogie, which I think is a varient of the y25 bogie

*/
//"dapol", "hornby", "NEM"
COUPLING_TYPE = "NEM";

dapol_wheels = true;
spoked = false;

//misc useful bits copypated from truck_base TODO consider how to abstract out


thick = 2;

//distance between the two axle holders - the pointy bits (along the axle)
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


coupling_from_axle = bogie_from_end - axle_distance/2 - coupling_from_edge;



bar_thick = 2.5;
side_arm_thick = 1;
width=axle_space+side_arm_thick*2;
//length=axle_distance + coupling_end_from_axle + non_coupling_end_from_axle;
length=bar_thick*3;
coupling_arm_wide = 5;
coupling_width = 17;

echo("width",width,"length",length, "axle_height",axle_height, "thick",thick);

//facing +ve x from 0,0
module hubcap(axle_mount_size){
    sphere_r = axle_mount_size;//wide*2;
    //sticky out bit on axle mount - want the tip of a sphere on a cylinder
    cylinder_l = axle_mount_size*0.1;
    cylinder_r = sqrt(sphere_r*sphere_r - (sphere_r*0.95)*(sphere_r*0.95));
    
    bolt_r = cylinder_r*0.2;
    bolt_distance = cylinder_r*0.8;
    
    translate([cylinder_l,0,0])
    intersection(){
        translate([-sphere_r*0.95,0,0])sphere(r=sphere_r, $fn=100);
        //-(axle_distance/2+axle_mount_size/2),corner_r
        translate([0,-50,-50])cube([100,100, 100]);
    }
    rotate([0,90,0])cylinder(r=cylinder_r, h=cylinder_l);
    
    for(i=[0:4]){
        rotate([90*i,0,0]){
            hull(){
                translate([0,bolt_distance,bolt_distance])rotate([0,90,0])cylinder(r=bolt_r, h= cylinder_l, $fn=20);
                
                rotate([0,90,0])cylinder(r=bolt_r*4, h= cylinder_l, $fn=20);
            }
            translate([0,bolt_distance,bolt_distance])rotate([0,90,0])cylinder(r=bolt_r*0.6, h= cylinder_l*1.1, $fn=20);
        }
        
    }
    
}
bar_height_above_axles = wheel_diameter*0.275*0.9;
corner_r = wheel_diameter*0.275;
//size of hole punched through
central_hole_r2 = wheel_diameter*0.275*0.45;

//easier to do one half and mirror the whole lot after
module intermodal_bogie_cosmetics_half(axle_distance, wheel_diameter,wide){
    
    //the bit supported by springs is wider than the main A-frame bit
    axle_holder_wide = wide*1.2;
        
    
    //size aroudn the hole, for the main bogie A-frame
    central_hole_r1 = wheel_diameter*0.275*0.75;
    
    //size of hole raised outwards around main hole
    hole_wider1=0.6;
    hole_wider2=0.4;
    hole_raised1 = 0.4;
    hole_raised2 = 0.3;//hide it for now, it doesn't slice well
    offset_hole_r1 = wheel_diameter*0.275*0.4;
    offset_hole_r2 = wheel_diameter*0.275*0.3;
    
    axle_box_hole_r1 = wheel_diameter*0.275*0.2;
    axle_box_hole_r2 = wheel_diameter*0.275*0.15;
    
   
    spring_r = wide*0.6;
    axle_mount_ledge_thick=0.2;
    
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
                
                
                //big triangle shape with holes
            hull(){
                translate([0,-(axle_distance/2-corner_r*1.3),0])cube([wide,axle_distance/2-corner_r/2, bar_height_above_axles]);
                translate([0,0,corner_r]) rotate([0,90,0]) cylinder(h=wide,r=central_hole_r1);
            }
           
            
            
            //raised bit around main hole
            translate([0,0,corner_r]) rotate([0,90,0]) cylinder(h=wide+hole_raised1,r=central_hole_r2+hole_wider1);
            translate([0,0,corner_r]) rotate([0,90,0]) cylinder(h=wide+hole_raised2,r=central_hole_r2+hole_wider2);
        }
        //punch holes out
        
        union(){
            //main hole in the centre
           translate([0,0,corner_r]) rotate([0,90,0]) cylinder(h=wide*3,r=central_hole_r2, center=true);
            //triangular holes offset from centre
            hull(){
                translate([0,-central_hole_r1*1.6,bar_height_above_axles*0.6]) rotate([0,90,0]) cylinder(h=wide*3,r=offset_hole_r1, center=true);
                translate([0,-central_hole_r1*2.5,bar_height_above_axles*0.6-offset_hole_r2*0.3]) rotate([0,90,0]) cylinder(h=wide*3,r=offset_hole_r2, center=true);
            }
            
            
            //smaller triangular holes above axle box
            hull(){
                translate([0,-axle_distance/2+axle_box_hole_r2,bar_height_above_axles*0.5]) rotate([0,90,0]) cylinder(h=wide*3,r=axle_box_hole_r1, center=true);
                translate([0,-axle_distance/2-axle_box_hole_r2,bar_height_above_axles*0.5+(axle_box_hole_r1-axle_box_hole_r2)]) rotate([0,90,0]) cylinder(h=wide*3,r=axle_box_hole_r2, center=true);
            }
        }
    }
    axle_mount_size = corner_r*3 - spring_r*5;
    echo(axle_mount_size);
    axle_mount_bottom_length = corner_r*3;
    
    //springs
    //a metric thread is totally a spring, right?
    translate([spring_r - (spring_r*2 - wide)/2,-(axle_distance/2+corner_r*1.5-spring_r),bar_height_above_axles])metric_thread(diameter=spring_r*2, pitch=0.7,thread_size=0.5, groove=true, length=axle_mount_size);
    
    translate([spring_r - (spring_r*2 - wide)/2,-(axle_distance/2-corner_r*1.5+spring_r),bar_height_above_axles])metric_thread(diameter=spring_r*2, thread_size=0.5, groove=true, pitch=0.7, length=axle_mount_size);
    
    
    //axle mounting
    translate([0,-(axle_distance/2+axle_mount_size/2),bar_height_above_axles])cube([wide,axle_mount_size, axle_mount_size]);
    
    translate([wide,-axle_distance/2,axle_height+thick]) hubcap(axle_mount_size);
    
    //bottom of axle mount
    ledge_wide = wide*1.2;
    
        translate([ledge_wide/2,-(axle_distance/2),bar_height_above_axles+axle_mount_size])
        rounded_cube(ledge_wide,axle_mount_bottom_length, axle_mount_ledge_thick,wide*0.2);
     
    hull(){   
        //triangular bit linking ledge to button of hubcap
        //cube([ledge_wide,])
    }
    
    translate([wide/2,-(axle_distance/2),bar_height_above_axles+axle_mount_size+axle_mount_ledge_thick])
        rounded_cube(wide,axle_mount_bottom_length*0.9, axle_mount_ledge_thick,wide*0.2);
    
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
    
        //side arms to axle holders (don't trust the cosmetic bits to be strong enough by themselves)
        difference(){
            mirror_y()translate([width/2-side_arm_thick/2,0,0])centredCube(0,0,side_arm_thick,axle_space+3,bar_height_above_axles);
            //don't put a backing behind the main hole - keep at least that a real hole
             translate([0,0,corner_r]) rotate([0,90,0]) cylinder(h=50,r=central_hole_r2, center=true);
        }

        
        //long_arm_length = coupling_from_axle+axle_distance/2 + (COUPLING_TYPE == "dapol" ? -4 : coupling_arm_wide/2);
        long_arm_length = bogie_from_end - generic_coupling_mount_from_edge(COUPLING_TYPE);
        //long arm to coupling
        color("blue")centredCube(0,long_arm_length/2,coupling_arm_wide,long_arm_length,thick + coupling_height);
        // if(COUPLING_TYPE != "dapol"){
        //     color("green")centredCube(0,coupling_from_axle+axle_distance/2,coupling_width,coupling_arm_wide,thick + coupling_height);
        // }
        
        //lengthening of hole for m3 screw
        cylinder(h=m3_hole_depth, r=(m3_thread_loose_size/2)+m3_hole_thick);
        
         //cosmetic bits on the outside
        mirror_y()translate([width/2-side_arm_thick,0,0]) intermodal_bogie_cosmetics(axle_distance, wheel_diameter, thick);
    }
    
    union(){
        //space for wheels
        mirror_x() translate([0,-axle_distance/2,axle_height+thick]){
            axle_hole(wheel_max_d,axle_space,axle_centre_space);
        }
        //extra deep hole for couplings
        translate([0,axle_distance/2 + coupling_from_axle,-thick]){
            cylinder(h=thick*4,r=m2_thread_size/2, $fn=200);
        }
        //m3 hole to connect to main chassis
        cylinder(h=100,r=m3_thread_loose_size/2, $fn=200, center=true);
        //punch out the holes for the axle
        axle_holder(axle_space, 20, axle_height+thick, axle_distance, true, false);
    }
}

//just to be confusing, axle_holder adds thickness itself
//axle_holder(axle_space, 20, axle_height);

translate([0,bogie_from_end, thick+coupling_height]){
    generic_coupling_mount(COUPLING_TYPE, thick+coupling_height);
}

/*
r=getWheelDiameter();
mirror_x(){color("gray")translate([0,-axle_space/2,axle_height+thick])rotate([0,90,0]) cylinder(h=axle_width*0.9, r=r/2 ,center=true);}
*/