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

//set either of these to true for the special versions
/*

gen_pi_cam_wagon = false;
gen_battery_wagon = false;









length=gen_pi_cam_wagon ? 85 : 75;
//height of the apex of the ends
height=gen_pi_cam_wagon ? 31+8 : 31;
//+1 for the girder thickness
width=gen_pi_cam_wagon ? 35+1 : gen_battery_wagon ? 29+wall_thick*2 :30+1;
*/

module fruit_van(width=31,length=75,height=31, gen_pi_cam_wagon=false,gen_battery_wagon=false, axle_distance = 40){

wall_thick=1.5;
door_width=0.5;
door_adornments_width=1;
plank_indent=0.25;

base_thick=4;
pi_mount_length=58;
pi_mount_width=23;
pi_mount_height=3.5;
pi_mount_height2=1.5;
pi_mount_d=2.25;//2.75-some wiggle
pi_mount_base_d = pi_mount_d*2;
pi_mount_offset_x = -0.5;
//space for SD card
pi_mount_from_end=6.5;

//similar but trying not the same as truck_base
/*module centred_cube(width,length, height){
    translate([-width/2, -length/2,0]){
        cube([width,length, height]);
    }
    
}*/

module pi_mount(height){
    translate([pi_mount_width/2,pi_mount_length/2,0]){
        cylinder(h=height,r=pi_mount_base_d/2,$fn=200);
        cylinder(h=height+pi_mount_height2,r=pi_mount_d/2,$fn=200);
    }
    translate([pi_mount_width/2,-pi_mount_length/2,0]){
        cylinder(h=height,r=pi_mount_base_d/2,$fn=200);
        cylinder(h=height+pi_mount_height2,r=pi_mount_d/2,$fn=200);
    }
    translate([-pi_mount_width/2,pi_mount_length/2,0]){
        cylinder(h=height,r=pi_mount_base_d/2,$fn=200);
        cylinder(h=height+pi_mount_height2,r=pi_mount_d/2,$fn=200);
    }
    translate([-pi_mount_width/2,-pi_mount_length/2,0]){
        cylinder(h=height,r=pi_mount_base_d/2,$fn=200);
        cylinder(h=height+pi_mount_height2,r=pi_mount_d/2,$fn=200);
    }
}

//facing +ve x
module door(plank_height,side_height,door_length,height){
    translate([width/2,0,0]){
        hinges_height = side_height*0.15;
        difference(){
            centred_cube(door_width,door_length,height);
            union(){
                //plank effects
                for(i=[-5:5]){
                    translate([sqrt(2)*plank_height/2+door_width/2-plank_indent,i*plank_height,0]){
                        rotate([0,0,45]){
                            cube([plank_height,plank_height,height*3],center = true);
                        }
                    }
                }
            }
        }
        //centreline
        centred_cube(door_adornments_width,door_adornments_width,height);
        
        handle_length = door_adornments_width*1.5;
        
        translate([0,-handle_length/2,side_height/2-door_adornments_width/2]){
            //handle/lock in the centre
            centred_cube(door_adornments_width,handle_length,door_adornments_width);
        }
        
        translate([0,0,0]){
            //handle/lock at the bottom
            centred_cube(door_adornments_width,door_adornments_width*2,door_adornments_width);
        }
        
        
        //either side
        translate([0,door_length/2,0]){
            centred_cube(door_adornments_width,door_adornments_width,height);
        }
        translate([0,-door_length/2,0]){
            centred_cube(door_adornments_width,door_adornments_width,height);
        }
        hinge_length = door_length*0.4;
        //hinges
        translate([0,-door_length/2+hinge_length/2,hinges_height-door_adornments_width/2]){
            centred_cube(door_adornments_width,hinge_length,door_adornments_width);
        }
        translate([0,-(-door_length/2+hinge_length/2),hinges_height-door_adornments_width/2]){
            centred_cube(door_adornments_width,hinge_length,door_adornments_width);
        }
        translate([0,-door_length/2+hinge_length/2,side_height-hinges_height-door_adornments_width/2]){
            centred_cube(door_adornments_width,hinge_length,door_adornments_width);
        }
        translate([0,-(-door_length/2+hinge_length/2),side_height-hinges_height-door_adornments_width/2]){
            centred_cube(door_adornments_width,hinge_length,door_adornments_width);
        }
    }
    
}

//facing +ve y
module vent(width, height,angle){
    thick = height*sin(angle);
    difference(){
        translate([0,thick,0]){
            rotate([90+angle,0, 0]){
                cube([width, height,thick]);
            }
        }
        translate([0,-50-thick/2,0]){
            cube([width*2,100,100],center=true);
        }
    }
}




hole_for_battery_cables = gen_pi_cam_wagon ? true : gen_battery_wagon;
hole_for_motor_cables = gen_pi_cam_wagon;
hole_for_pi_cam = gen_pi_cam_wagon;
pi_mounting = gen_pi_cam_wagon;




echo("Width: ", width, ", length: ",length, ", height: ",height);

//aiming for side height of 26;
roof_radius=31.4;
side_height= roof_radius*cos(asin((width/2)/roof_radius)) - (roof_radius-height);
echo(side_height);
//distance between the two axles (perpendicular to each axle)
//axle_distance = 40;
wheel_max_space = 17;
wheel_diameter = 14.0;
axle_space = 23.0;
axle_height = 5;




//7.25+some wiggle room
pi_cam_d = 7.5;
pi_cam_from_top = -pi_cam_d/2;

cable_d=5.5;
motor_cable_d=6;

plank_height= side_height/12;//2.25;

support_width = 1.5;
mid_support_width = 1.1;

vent_height = plank_height*4.5;//height*0.35;
vent_angle = 8;



door_length=length/3;

//from truck base
//wall thickness + screw head size + wiggle room
top_screw_holders_from_edge = 5;
//turns out my screws weren't m2. 2.2 works for the screws provided with couplings
//trying actually 2.0 for m2
m2_thread_size=2.0;
edge=5;
truck_width=30;

difference(){
//intersect with horizontal cylinder for roof shape
intersection(){
        
    union(){
        difference(){
            union(){
            centred_cube(width,length,base_thick);

            translate([width/2-wall_thick/2,0]){
                centred_cube(wall_thick,length,height);
            }

            translate([-(width/2-wall_thick/2),0]){
                centred_cube(wall_thick,length,height);
            }

            translate([0,length/2-wall_thick/2,0]){
                centred_cube(width,wall_thick,height);
            }

            translate([0,-(length/2-wall_thick/2),0]){
                centred_cube(width,wall_thick,height);
            }
        }
        
        //subtract notches to make things look like planks
        union(){
            for(i=[1:20]){
                //subtract all the bits to make it look like planks
                translate([width/2+sqrt(2)*wall_thick/2-plank_indent,0,i*plank_height]){
                    rotate([0,45,0]){
                        cube([wall_thick,length*2,wall_thick],center=true);
                    }
                }
            
            }
            rotate([0,0,90]){
                  for(i=[1:20]){
                //subtract all the bits to make it look like planks
                translate([length/2+sqrt(2)*wall_thick/2-plank_indent,0,i*plank_height]){
                    rotate([0,45,0]){
                        cube([wall_thick,length*2,wall_thick],center=true);
                    }
                }
            
            }
            }
            
            rotate([0,0,180]){
                  for(i=[1:20]){
                //subtract all the bits to make it look like planks
                translate([width/2+sqrt(2)*wall_thick/2-plank_indent,0,i*plank_height]){
                    rotate([0,45,0]){
                        cube([wall_thick,length*2,wall_thick],center=true);
                    }
                }
            
            }
            }
            rotate([0,0,-90]){
                  for(i=[1:20]){
                //subtract all the bits to make it look like planks
                translate([length/2+sqrt(2)*wall_thick/2-plank_indent,0,i*plank_height]){
                    rotate([0,45,0]){
                        cube([wall_thick,length*2,wall_thick],center=true);
                    }
                }
            
            }
            }
            
            //subtract screw holes as well
            
        translate([-(truck_width/2-top_screw_holders_from_edge),0,0]){
            cylinder(r=m2_thread_size/2,h=height*2,$fn=200,center=true);
        }
        translate([(truck_width/2-top_screw_holders_from_edge),0,0]){
            cylinder(r=m2_thread_size/2,h=height*2,$fn=200,center=true);
        }
        
        translate([0,length/2-edge/2,0]){
            cylinder(h=base_thick*5,r=m2_thread_size/2, $fn=200,center=true);
        }
        translate([0,-(length/2-edge/2),0]){
            cylinder(h=base_thick*5,r=m2_thread_size/2, $fn=200,center=true);
        }
        
        }
    }
        
        //posts in corners
        translate([width/2,length/2,0]){
            centred_cube(support_width,support_width,height);
        }
        //posts in corners
        translate([-width/2,length/2,0]){
            centred_cube(support_width,support_width,height);
        }
        //posts in corners
        translate([-width/2,-length/2,0]){
            centred_cube(support_width,support_width,height);
        }
        //posts in corners
        translate([width/2,-length/2,0]){
            centred_cube(support_width,support_width,height);
        }
        
        //mid supports
        translate([width/2,(length-door_length)/2,0]){
            centred_cube(mid_support_width,mid_support_width,height);
        }
        //mid supports
        translate([width/2,-(length-door_length)/2,0]){
            centred_cube(mid_support_width,mid_support_width,height);
        }
        //mid supports
        translate([-width/2,(length-door_length)/2,0]){
            centred_cube(mid_support_width,mid_support_width,height);
        }
        //mid supports
        translate([-width/2,-(length-door_length)/2,0]){
            centred_cube(mid_support_width,mid_support_width,height);
        }
        section_width=(length-door_length)/2-mid_support_width;
        cross_support_angle = atan(side_height/section_width);
        echo(cross_support_angle);
        //cross mid support
        translate([width/2, door_length/2 + section_width/2 + mid_support_width/2,side_height/2]){
            rotate([cross_support_angle-90,0,0]){
                cube([mid_support_width,mid_support_width,height*2], center=true);
            }
        }
        mirror([1,0,0]){
            translate([width/2, door_length/2 + section_width/2 + mid_support_width/2,side_height/2]){
                rotate([cross_support_angle-90,0,0]){
                    cube([mid_support_width,mid_support_width,height*2], center=true);
                }
            }
        }
        rotate([0,0,180]){
            translate([width/2, door_length/2 + section_width/2 + mid_support_width/2,side_height/2]){
                rotate([cross_support_angle-90,0,0]){
                    cube([mid_support_width,mid_support_width,height*2], center=true);
                }
            }
            mirror([1,0,0]){
            translate([width/2, door_length/2 + section_width/2 + mid_support_width/2,side_height/2]){
                rotate([cross_support_angle-90,0,0]){
                    cube([mid_support_width,mid_support_width,height*2], center=true);
                }
            }
        }
        }
        
        
        //mid supports on the ends
        translate([(width/3)/2,-length/2,0]){
            centred_cube(mid_support_width,mid_support_width,height);
        }
        translate([(-width/3)/2,-length/2,0]){
            centred_cube(mid_support_width,mid_support_width,height);
        }
        translate([(width/3)/2, length/2,0]){
            centred_cube(mid_support_width,mid_support_width,height);
        }
        translate([(-width/3)/2, length/2,0]){
            centred_cube(mid_support_width,mid_support_width,height);
        }
        cross_support_angle_end = atan((height-vent_height)/(width/3));
        cross_support_length_end = sqrt((height-vent_height)*(height-vent_height) + (width/3)*(width/3));
        //vents on the ends
        translate([width/6+mid_support_width/2,length/2, height-vent_height]){
            vent(width/3-mid_support_width, vent_height, vent_angle);
        }
        
        translate([-width/2,length/2,0]){
            rotate([0,90-cross_support_angle_end,0]){
                centred_cube(mid_support_width,mid_support_width,cross_support_length_end);
            }
        }
        
        
        mirror([0,1,0]){
            translate([width/6+mid_support_width/2,length/2,height-vent_height]){
                vent(width/3-mid_support_width, vent_height, vent_angle);
            }
            translate([-width/2,length/2,0]){
            rotate([0,90-cross_support_angle_end,0]){
                centred_cube(mid_support_width,mid_support_width,cross_support_length_end);
            }
        }
        }
        mirror([1,0,0]){
            translate([width/6+mid_support_width/2,length/2,height-vent_height]){
                vent(width/3-mid_support_width, vent_height, vent_angle);
            }
            translate([-width/2,length/2,0]){
            rotate([0,90-cross_support_angle_end,0]){
                centred_cube(mid_support_width,mid_support_width,cross_support_length_end);
            }
        }
            mirror([0,1,0]){
                translate([width/6+mid_support_width/2,length/2,height-vent_height]){
                    vent(width/3-mid_support_width, vent_height, vent_angle);
                }
                translate([-width/2,length/2,0]){
            rotate([0,90-cross_support_angle_end,0]){
                centred_cube(mid_support_width,mid_support_width,cross_support_length_end);
            }
        }
            }
        }
        rotate([0,0,180]){
            door(plank_height,side_height,door_length,height);
        }
        
        door(plank_height,side_height,door_length,height);
        if(pi_mounting){
            translate([pi_mount_offset_x,(length/2-pi_mount_length/2 -pi_mount_from_end-wall_thick),0]){
                pi_mount(pi_mount_height+base_thick);
            }
        }
    }

    //only include bits that wouldn't stick outside the roof
    translate([0,0,height-roof_radius]){
        rotate([90,0,0]){
            cylinder(r=roof_radius,h=length*2,center=true,$fn=200);
        }
    }
}//end intersection with roof cylinder

    //ensure nothing extends below floor
    translate([0,0,-50]){
        cube([100,100,100], center=true);
    }
    if(hole_for_battery_cables){
        translate([0,length/2,cable_d/2+base_thick]){
            rotate([90,0,0]){
                cylinder(h=wall_thick*10,r=cable_d/2,center=true,$fn=200);
            }
        }
    }
    
    if(hole_for_motor_cables){
        //to one side of the camera ribbon cable
        translate([width/3.5,-length/2,motor_cable_d/2+base_thick]){
            rotate([90,0,0]){
                cylinder(h=wall_thick*10,r=motor_cable_d/2,center=true,$fn=200);
            }
        }
    }
    
    if(hole_for_pi_cam){
         translate([0,-length/2,height-pi_cam_from_top - pi_cam_d/2]){
            rotate([90,0,0]){
                cylinder(h=wall_thick*10,r=pi_cam_d/2,center=true,$fn=200);
            }
        }
    }
    
    //little bit of extra space for larger wheels
    translate([0,-axle_distance/2,0]){
            cube([axle_space,wheel_max_space,base_thick+0.01], center=true);
        }
        translate([0,axle_distance/2,0]){
            cube([axle_space,wheel_max_space,base_thick+0.01], center=true);
        }

}//end difference with chopping off floor
    

}
//fruit_van();